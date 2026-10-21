import 'dart:async';

import 'package:caspian_owner/core/notifications/local_notifications.dart';
import 'package:caspian_owner/core/notifications/notification_poller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Starts and stops the background check. A no-op unless bootstrap
/// provides the real one (tests and previews don't schedule anything).
class NotificationScheduler {
  const new({
    this.start = _noop,
    this.stop = _noop,
    this.askPermission = _noop,
  });

  final Future<void> Function() start;
  final Future<void> Function() stop;
  final Future<void> Function() askPermission;

  static Future<void> _noop() async {}
}

final notificationSchedulerProvider = Provider<NotificationScheduler>(
  (ref) => const NotificationScheduler(),
);

final localNotificationsProvider = Provider<LocalNotifications?>((ref) => null);

/// Shows notifications for what arrives while the app is open (null: none,
/// as in tests that don't record them).
final foregroundNotifierProvider = Provider<LocalNotifier?>(
  (ref) => ref.watch(localNotificationsProvider),
);

/// Links from tapped notifications while the app runs.
final notificationTapsProvider = Provider<StreamController<String>>((ref) {
  final controller = StreamController<String>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});

/// The link of the notification that launched the app, if any.
final launchNotificationTargetProvider = Provider<String?>((ref) => null);
