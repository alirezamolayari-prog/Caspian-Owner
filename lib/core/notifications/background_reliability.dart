import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// What can stop notifications on this phone while the app is closed.
class BackgroundStatus {
  const new({
    required this.notificationsAllowed,
    required this.batteryUnrestricted,
    required this.hasAutostart,
  });

  /// Android lets the app show notifications at all.
  final bool notificationsAllowed;

  /// The app is exempt from battery optimization, so Android doesn't keep
  /// postponing the 15-minute background check.
  final bool batteryUnrestricted;

  /// The phone has its own «Autostart» switch (Xiaomi, Redmi, POCO). While
  /// it is off the background check never runs, and apps can't read it.
  final bool hasAutostart;
}

/// Reads [BackgroundStatus] and opens the system pages that fix it
/// (`MainActivity`, channel `caspian/background`).
class BackgroundReliability {
  const new([this._channel = const MethodChannel('caspian/background')]);

  final MethodChannel _channel;

  Future<BackgroundStatus> status() async {
    final map = await _channel.invokeMapMethod<String, Object?>('status');
    return BackgroundStatus(
      notificationsAllowed: map?['notificationsAllowed'] == true,
      batteryUnrestricted: map?['batteryUnrestricted'] == true,
      hasAutostart: map?['hasAutostart'] == true,
    );
  }

  Future<void> openNotificationSettings() =>
      _channel.invokeMethod<void>('openNotificationSettings');

  Future<void> openBatterySettings() =>
      _channel.invokeMethod<void>('openBatterySettings');

  Future<void> openAutostartSettings() =>
      _channel.invokeMethod<void>('openAutostartSettings');
}

/// Provided by bootstrap on the phone; null in tests and previews, where
/// Settings hides the section.
final backgroundReliabilityProvider = Provider<BackgroundReliability?>(
  (ref) => null,
);

/// The current [BackgroundStatus] (null without
/// [backgroundReliabilityProvider]). Settings reads it again when the owner
/// comes back from a system page.
final FutureProvider<BackgroundStatus?> backgroundStatusProvider =
    FutureProvider.autoDispose(
      (ref) async => await ref.watch(backgroundReliabilityProvider)?.status(),
    );
