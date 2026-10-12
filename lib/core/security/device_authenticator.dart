import 'package:local_auth/local_auth.dart';

/// Fingerprint, face or the phone's own PIN/pattern (local_auth).
abstract interface class DeviceAuthenticator {
  /// True when the phone has a biometric or a screen lock set up.
  Future<bool> isAvailable();

  /// Shows the system prompt. True when the owner passed it.
  Future<bool> authenticate(String reason);
}

class LocalDeviceAuthenticator implements DeviceAuthenticator {
  new([LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      // biometricOnly: false lets older phones fall back to the device PIN.
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on Object {
      return false;
    }
  }
}
