import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Waits for the SMS with a login code, using Android's SMS User Consent
/// API: the system asks the owner once to let the app read that single
/// message. No SMS permission, no access to other messages.
///
/// Typing the code by hand always works too; the listener only saves the
/// typing when it can.
abstract interface class SmsCodeListener {
  /// The 6-digit code from the next SMS, or null when the owner declined,
  /// the phone has no Google Play services, 5 minutes passed, or [cancel]
  /// was called.
  Future<String?> nextCode();

  /// Stops waiting (screen closed or code typed by hand).
  Future<void> cancel();
}

/// The Android side lives in `MainActivity.kt` (`caspian/sms_consent`) and
/// uses Google's small `play-services-auth-api-phone` library, the app's
/// only Google Play services part.
class AndroidSmsCodeListener implements SmsCodeListener {
  const new([this._channel = const MethodChannel('caspian/sms_consent')]);

  final MethodChannel _channel;

  static final _sixDigits = RegExp(r'(?<!\d)\d{6}(?!\d)');

  @override
  Future<String?> nextCode() async {
    try {
      final message = await _channel.invokeMethod<String>('start');
      return message == null ? null : codeIn(message);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Future<void> cancel() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on PlatformException {
      // Nothing was waiting.
    } on MissingPluginException {
      // Not on Android.
    }
  }

  /// The first 6-digit number in [message] (Persian digits accepted).
  static String? codeIn(String message) =>
      _sixDigits.firstMatch(toLatinDigits(message))?.group(0);
}

final smsCodeListenerProvider = Provider<SmsCodeListener>(
  (ref) => const AndroidSmsCodeListener(),
);
