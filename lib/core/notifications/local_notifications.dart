import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/notifications/notification_poller.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Phone notifications (no Firebase). The payload is the in-app link, e.g.
/// `/requests/r-124`, opened when the owner taps the notification.
class LocalNotifications implements LocalNotifier, UpdateNotifier {
  new([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  /// Prepares the plugin. [onTap] receives the link of a tapped
  /// notification while the app is running.
  Future<void> init({void Function(String target)? onTap}) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final target = response.payload;
        if (target != null && target.isNotEmpty) onTap?.call(target);
      },
    );
  }

  /// The link of the notification that launched the app, if any.
  Future<String?> launchTarget() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (!(details?.didNotificationLaunchApp ?? false)) return null;
    return details?.notificationResponse?.payload;
  }

  /// Android 13+ asks the owner once.
  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  @override
  Future<void> show(NotificationEvent event) {
    final l10n = lookupAppLocalizations(const Locale('fa'));
    final (String channel, String name) = switch (event.kind) {
      // countResult is never shown (see isShown); listed for completeness.
      NotificationEventKind.requestEscalated ||
      NotificationEventKind.requestDecided ||
      NotificationEventKind.countResult => ('requests', l10n.channelRequests),
      NotificationEventKind.chatMessage => ('messages', l10n.channelMessages),
    };
    return _plugin.show(
      id: event.id.hashCode & 0x7fffffff,
      title: event.titleFa,
      body: event.bodyFa,
      payload: event.target,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          name,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// One notification for updates: «ready to install» replaces «available».
  static const _updateId = 0x55504454;

  @override
  Future<void> showUpdate({
    required String version,
    required bool ready,
    required String target,
  }) {
    final l10n = lookupAppLocalizations(const Locale('fa'));
    final shown = toPersianDigits(version);
    return _plugin.show(
      id: _updateId,
      title: ready ? l10n.updateReadyNotifyTitle : l10n.updateNotifyTitle,
      body: ready
          ? l10n.updateReadyNotifyBody(shown)
          : l10n.updateNotifyBody(shown),
      payload: target,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'updates',
          l10n.channelUpdates,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
