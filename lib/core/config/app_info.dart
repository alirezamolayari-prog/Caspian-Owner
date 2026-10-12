import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Facts about this install, sent with every decision (contract headers
/// `X-Device-Id`, `X-App-Version`).
class AppInfo {
  const new({
    required this.version,
    required this.buildNumber,
    required this.deviceId,
    required this.deviceModel,
    required this.isDebug,
  });

  final String version;
  final int buildNumber;

  /// Random id created on first launch, kept in secure storage.
  final String deviceId;
  final String deviceModel;

  /// Debug builds allow the test login code and the mock/API switch.
  final bool isDebug;

  /// `X.Y.Z+BUILD`
  String get fullVersion => '$version+$buildNumber';

  static Future<AppInfo> load({required String deviceId}) async {
    final package = await PackageInfo.fromPlatform();
    var model = 'unknown';
    try {
      final android = await DeviceInfoPlugin().androidInfo;
      model = '${android.manufacturer} ${android.model}';
    } on Object {
      // Not Android (tests, desktop): keep "unknown".
    }
    return AppInfo(
      version: package.version,
      buildNumber: int.tryParse(package.buildNumber) ?? 0,
      deviceId: deviceId,
      deviceModel: model,
      isDebug: kDebugMode,
    );
  }
}
