import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/pin_hasher.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// What the lock knows at startup (bootstrap).
class LockSetup {
  const new({
    required this.deviceAuthAvailable,
    required this.hasPin,
    this.useDevice = true,
  });

  /// The phone has a fingerprint or screen lock that local_auth can use.
  final bool deviceAuthAvailable;

  /// An app PIN was set (fallback for phones without a screen lock).
  final bool hasPin;

  /// The owner chose fingerprint unlock (or never said no to it).
  final bool useDevice;
}

class LockState {
  const new({
    required this.locked,
    required this.deviceAuthAvailable,
    required this.hasPin,
    this.useDevice = true,
    this.offerPending = false,
    this.pinAttemptsLeft = AppLockController.maxPinAttempts,
  });

  final bool locked;
  final bool deviceAuthAvailable;
  final bool hasPin;

  /// The owner wants fingerprint unlock (asked after each password login).
  final bool useDevice;

  /// Just logged in with a password: ask «اثر انگشت فعال شود؟» first.
  final bool offerPending;
  final int pinAttemptsLeft;

  /// Fingerprint (or the phone's own lock) opens the app.
  bool get deviceUnlock => deviceAuthAvailable && useDevice;

  /// Without fingerprint unlock, an app PIN must protect the data.
  bool get needsPinSetup => !offerPending && !deviceUnlock && !hasPin;

  LockState copyWith({
    bool? locked,
    bool? hasPin,
    bool? useDevice,
    bool? offerPending,
    int? pinAttemptsLeft,
  }) => LockState(
    locked: locked ?? this.locked,
    deviceAuthAvailable: deviceAuthAvailable,
    hasPin: hasPin ?? this.hasPin,
    useDevice: useDevice ?? this.useDevice,
    offerPending: offerPending ?? this.offerPending,
    pinAttemptsLeft: pinAttemptsLeft ?? this.pinAttemptsLeft,
  );
}

final lockSetupProvider = Provider<LockSetup>(
  (ref) => const LockSetup(deviceAuthAvailable: true, hasPin: false),
);

final appLockControllerProvider =
    NotifierProvider<AppLockController, LockState>(AppLockController.new);

/// Locks the app on launch and after [relockAfter] in the background.
/// Unlocks with the phone's fingerprint/PIN prompt or the app PIN. This
/// only opens the session kept on the phone; it never replaces the server
/// password (a `401` from the server still means logging in again).
class AppLockController extends Notifier<LockState> {
  static const relockAfter = Duration(minutes: 5);
  static const maxPinAttempts = 5;

  DateTime? _backgroundedAt;

  @override
  LockState build() {
    final setup = ref.read(lockSetupProvider);
    // Signing in with the password or out leaves the app unlocked; after a
    // password login the owner is asked whether to use the fingerprint.
    ref.listen(authControllerProvider, (previous, next) {
      if (previous.runtimeType != next.runtimeType) {
        final signedIn = next is SignedIn;
        state = state.copyWith(
          locked: false,
          hasPin: signedIn && state.hasPin,
          useDevice: true,
          offerPending: signedIn && state.deviceAuthAvailable,
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
      // «فعلاً نه» counts only once an app PIN exists. Closed before the
      // PIN was made: the fingerprint still guards the stored session
      // (otherwise whoever holds the phone could make a PIN and get in).
      useDevice: setup.useDevice || !setup.hasPin,
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
  Future<bool> unlockWithDevice(AuthPrompt prompt) async {
    final ok = await ref.read(deviceAuthenticatorProvider).authenticate(prompt);
    if (ok) {
      state = state.copyWith(locked: false, pinAttemptsLeft: maxPinAttempts);
    }
    return ok;
  }

  /// «بله، فعال شود» (or the setting): one touch to confirm the finger
  /// works, then the app opens with it. False if the touch failed.
  Future<bool> enableDeviceUnlock(AuthPrompt prompt) async {
    if (!state.deviceAuthAvailable) return false;
    final ok = await ref.read(deviceAuthenticatorProvider).authenticate(prompt);
    if (!ok) return false;
    await ref.read(secureStoreProvider).write(SecureKeys.deviceUnlock, 'on');
    state = state.copyWith(useDevice: true, offerPending: false);
    return true;
  }

  /// «فعلاً نه»: no fingerprint; an app PIN is set next if there is none.
  Future<void> declineDeviceUnlock() async {
    await ref.read(secureStoreProvider).write(SecureKeys.deviceUnlock, 'off');
    state = state.copyWith(useDevice: false, offerPending: false);
  }

  /// Checks the app PIN. After [maxPinAttempts] wrong PINs the owner is
  /// signed out and must log in again with the password.
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
