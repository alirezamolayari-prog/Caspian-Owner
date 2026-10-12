import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/security/pin_hasher.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// What the lock knows at startup (bootstrap).
class LockSetup {
  const new({required this.deviceAuthAvailable, required this.hasPin});

  /// The phone has a fingerprint or screen lock that local_auth can use.
  final bool deviceAuthAvailable;

  /// An app PIN was set (fallback for phones without a screen lock).
  final bool hasPin;
}

class LockState {
  const new({
    required this.locked,
    required this.deviceAuthAvailable,
    required this.hasPin,
    this.pinAttemptsLeft = AppLockController.maxPinAttempts,
  });

  final bool locked;
  final bool deviceAuthAvailable;
  final bool hasPin;
  final int pinAttemptsLeft;

  /// Phones with no screen lock must set an app PIN before using the app.
  bool get needsPinSetup => !deviceAuthAvailable && !hasPin;

  LockState copyWith({bool? locked, bool? hasPin, int? pinAttemptsLeft}) =>
      LockState(
        locked: locked ?? this.locked,
        deviceAuthAvailable: deviceAuthAvailable,
        hasPin: hasPin ?? this.hasPin,
        pinAttemptsLeft: pinAttemptsLeft ?? this.pinAttemptsLeft,
      );
}

final lockSetupProvider = Provider<LockSetup>(
  (ref) => const LockSetup(deviceAuthAvailable: true, hasPin: false),
);

final appLockControllerProvider =
    NotifierProvider<AppLockController, LockState>(AppLockController.new);

/// Locks the app on launch and after [relockAfter] in the background.
/// Unlocks with the phone's fingerprint/PIN prompt or the app PIN.
class AppLockController extends Notifier<LockState> {
  static const relockAfter = Duration(minutes: 5);
  static const maxPinAttempts = 5;

  DateTime? _backgroundedAt;

  @override
  LockState build() {
    final setup = ref.read(lockSetupProvider);
    // Signing in (with an SMS code) or out leaves the app unlocked.
    ref.listen(authControllerProvider, (previous, next) {
      if (previous.runtimeType != next.runtimeType) {
        state = state.copyWith(
          locked: false,
          hasPin: next is SignedIn && state.hasPin,
          pinAttemptsLeft: maxPinAttempts,
        );
      }
    });
    return LockState(
      // A stored session means a cold start: lock until the owner proves
      // it's them.
      locked: ref.read(authControllerProvider) is SignedIn,
      deviceAuthAvailable: setup.deviceAuthAvailable,
      hasPin: setup.hasPin,
    );
  }

  void onBackgrounded() => _backgroundedAt = clock.now();

  void onForegrounded() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (since == null || ref.read(authControllerProvider) is! SignedIn) return;
    if (clock.now().difference(since) >= relockAfter) {
      state = state.copyWith(locked: true);
    }
  }

  /// Fingerprint, face or the phone's own PIN. True when unlocked.
  Future<bool> unlockWithDevice(String reason) async {
    final ok = await ref.read(deviceAuthenticatorProvider).authenticate(reason);
    if (ok) {
      state = state.copyWith(locked: false, pinAttemptsLeft: maxPinAttempts);
    }
    return ok;
  }

  /// Checks the app PIN. After [maxPinAttempts] wrong PINs the owner is
  /// signed out and must log in again with an SMS code.
  Future<bool> unlockWithPin(String pin) async {
    final store = ref.read(secureStoreProvider);
    final hash = await store.read(SecureKeys.pinHash);
    final salt = await store.read(SecureKeys.pinSalt);
    if (hash != null && salt != null && PinHasher.hash(pin, salt) == hash) {
      state = state.copyWith(locked: false, pinAttemptsLeft: maxPinAttempts);
      return true;
    }
    final left = state.pinAttemptsLeft - 1;
    if (left <= 0) {
      await ref
          .read(authControllerProvider.notifier)
          .signOut(SignOutReason.tooManyPinAttempts);
    } else {
      state = state.copyWith(pinAttemptsLeft: left);
    }
    return false;
  }

  /// Sets (or replaces) the app PIN.
  Future<void> setPin(String pin) async {
    final store = ref.read(secureStoreProvider);
    final salt = PinHasher.newSalt();
    await store.write(SecureKeys.pinSalt, salt);
    await store.write(SecureKeys.pinHash, PinHasher.hash(pin, salt));
    state = state.copyWith(hasPin: true, locked: false);
  }
}
