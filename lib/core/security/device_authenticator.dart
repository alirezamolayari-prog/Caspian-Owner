import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

/// The texts of the system fingerprint dialog, from the ARB files (the
/// plugin's defaults are English). The «Use PIN» button is drawn by Android
/// itself, in the phone's language; apps can't change it.
class AuthPrompt {
  const new({
    required this.title,
    required this.reason,
    required this.cancel,
    this.hint = '',
  });

  /// [reason] says what is being confirmed, e.g. «تأیید درخواست ۱۲۴».
  factory of(AppLocalizations l10n, String reason) => AuthPrompt(
    title: l10n.authPromptTitle,
    hint: l10n.authPromptHint,
    reason: reason,
    cancel: l10n.cancel,
  );

  final String title;

  /// A short line under the title; the reason is shown below it anyway.
  final String hint;
  final String reason;
  final String cancel;
}

/// Fingerprint, face or the phone's own PIN/pattern (local_auth).
abstract interface class DeviceAuthenticator {
  /// True when the phone has a biometric or a screen lock set up.
  Future<bool> isAvailable();

  /// Shows the system prompt. True when the owner passed it.
  Future<bool> authenticate(AuthPrompt prompt);
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
  Future<bool> authenticate(AuthPrompt prompt) async {
    try {
      // biometricOnly: false lets older phones fall back to the device PIN.
      return await _auth.authenticate(
        localizedReason: prompt.reason,
        authMessages: [
          AndroidAuthMessages(
            signInTitle: prompt.title,
            signInHint: prompt.hint,
            cancelButton: prompt.cancel,
          ),
        ],
        persistAcrossBackgrounding: true,
      );
    } on Object {
      return false;
    }
  }
}
