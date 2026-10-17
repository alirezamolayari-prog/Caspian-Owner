import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

const _prompt = AuthPrompt(title: 't', reason: 'r', cancel: 'c');

void main() {
  late TestHarness harness;
  late ProviderContainer container;

  AppLockController lock() =>
      container.read(appLockControllerProvider.notifier);
  LockState state() => container.read(appLockControllerProvider);

  /// Locks the app the way it really happens: 5 minutes in the background.
  void relock() {
    final start = DateTime(2026, 10, 12, 12);
    withClock(Clock.fixed(start), lock().onBackgrounded);
    withClock(
      Clock.fixed(start.add(AppLockController.relockAfter)),
      lock().onForegrounded,
    );
  }

  Future<void> setUpWith({bool signedIn = true, bool hasPin = false}) async {
    harness = await TestHarness.load(signedIn: signedIn, hasPin: hasPin);
    container = harness.container();
    addTearDown(container.dispose);
    addTearDown(harness.database.close);
  }

  test('a stored session starts locked; signed out does not', () async {
    await setUpWith();
    expect(state().locked, isTrue);

    await setUpWith(signedIn: false);
    expect(state().locked, isFalse);
  });

  test('fingerprint unlocks', () async {
    await setUpWith();
    expect(await lock().unlockWithDevice(_prompt), isTrue);
    expect(state().locked, isFalse);
  });

  test('a failed fingerprint stays locked', () async {
    await setUpWith();
    harness.authenticator.succeeds = false;
    expect(await lock().unlockWithDevice(_prompt), isFalse);
    expect(state().locked, isTrue);
  });

  test('relocks after 5 minutes in the background, not before', () async {
    await setUpWith();
    await lock().unlockWithDevice(_prompt);
    final start = DateTime(2026, 10, 12, 12);

    withClock(Clock.fixed(start), lock().onBackgrounded);
    withClock(
      Clock.fixed(start.add(const Duration(minutes: 4, seconds: 59))),
      lock().onForegrounded,
    );
    expect(state().locked, isFalse);

    withClock(Clock.fixed(start), lock().onBackgrounded);
    withClock(
      Clock.fixed(start.add(AppLockController.relockAfter)),
      lock().onForegrounded,
    );
    expect(state().locked, isTrue);
  });

  test('app PIN: set, then unlock with it', () async {
    await setUpWith();
    await lock().setPin('1234');
    expect(state().hasPin, isTrue);
    expect(harness.store.values[SecureKeys.pinHash], isNot(contains('1234')));

    relock();
    expect(state().locked, isTrue);
    expect(await lock().unlockWithPin('0000'), isFalse);
    expect(state().pinAttemptsLeft, AppLockController.maxPinAttempts - 1);
    expect(await lock().unlockWithPin('1234'), isTrue);
    expect(state().locked, isFalse);
    expect(state().pinAttemptsLeft, AppLockController.maxPinAttempts);
  });

  test('five wrong PINs sign the owner out and wipe secrets', () async {
    await setUpWith();
    await lock().setPin('1234');
    for (var i = 0; i < AppLockController.maxPinAttempts; i++) {
      await lock().unlockWithPin('9999');
    }
    final auth = container.read(authControllerProvider);
    expect(auth, isA<SignedOut>());
    expect((auth as SignedOut).reason, SignOutReason.tooManyPinAttempts);
    expect(harness.store.values[SecureKeys.pinHash], isNull);
  });

  test('a phone without a screen lock needs an app PIN', () async {
    harness = await TestHarness.load(
      signedIn: true,
      deviceAuthAvailable: false,
    );
    container = harness.container();
    addTearDown(container.dispose);
    expect(state().needsPinSetup, isTrue);
    await lock().setPin('2580');
    expect(state().needsPinSetup, isFalse);
  });
}
