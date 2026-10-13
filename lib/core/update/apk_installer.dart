import 'package:flutter/services.dart';

/// Hands the downloaded APK to Android's package installer
/// (`MainActivity`: FileProvider + ACTION_VIEW). Android itself refuses an
/// update signed with a different key.
class ApkInstaller {
  const new([this._channel = const MethodChannel('caspian/installer')]);

  final MethodChannel _channel;

  /// "Install unknown apps" is allowed for this app.
  Future<bool> canInstall() async =>
      await _channel.invokeMethod<bool>('canRequestInstall') ?? false;

  /// Opens the system page where the owner allows installing updates.
  Future<void> openInstallPermission() =>
      _channel.invokeMethod<void>('openInstallSettings');

  Future<void> install(String apkPath) =>
      _channel.invokeMethod<void>('install', apkPath);
}
