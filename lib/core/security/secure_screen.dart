import 'package:flutter/services.dart';

/// Blocks screenshots and the recent-apps preview (Android FLAG_SECURE)
/// on sensitive screens. Owners can turn it off in Settings (M10).
class SecureScreen {
  const new([this._channel = const MethodChannel('caspian/secure_screen')]);

  final MethodChannel _channel;

  Future<void> set({required bool secure}) async {
    try {
      await _channel.invokeMethod<void>('setSecure', secure);
    } on MissingPluginException {
      // Not on Android (tests, desktop): nothing to do.
    } on PlatformException {
      // Never break a screen because the flag could not be changed.
    }
  }
}
