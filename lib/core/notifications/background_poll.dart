import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/core/notifications/local_notifications.dart';
import 'package:caspian_owner/core/notifications/notification_poller.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

/// Background check every 15 minutes (Android's minimum), only with a
/// network connection. Replaced later by a push channel through the same
/// `NotificationSource` interface.
abstract final class NotificationSchedule {
  static const uniqueName = 'caspian-owner-poll';
  static const taskName = 'poll-notifications';
  static const frequency = Duration(minutes: 15);

  static Future<void> initialize() =>
      Workmanager().initialize(notificationCallbackDispatcher);

  static Future<void> start() => Workmanager().registerPeriodicTask(
    uniqueName,
    taskName,
    frequency: frequency,
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

  static Future<void> stop() => Workmanager().cancelByUniqueName(uniqueName);
}

/// Runs in a background isolate, with no app state.
@pragma('vm:entry-point')
void notificationCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    const store = DeviceSecureStore();
    // Nothing to do when logged out or turned off in Settings.
    if (await store.read(SecureKeys.session) == null) return true;
    if (!(await AppSettings.load(store)).notifications) return true;

    final notifier = LocalNotifications();
    await notifier.init();
    try {
      await NotificationPoller(
        source: await _source(),
        store: store,
        notifier: notifier,
      ).run();
    } on Object {
      // Offline or server error: try again next time.
    }
    return true;
  });
}

Future<NotificationSource> _source() async => switch (ApiConfig.dataSource) {
  DataSource.mock => MockNotificationSource(
    MockBackend(
      await MockFixtures.load(rootBundle, now: DateTime.now()),
      latency: Duration.zero,
    ),
  ),
  DataSource.api => throw UnimplementedError(
    'The API notification source is added with the middle server.',
  ),
};
