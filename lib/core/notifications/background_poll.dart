import 'dart:io';

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/logging/app_log.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/core/network/changes_feed.dart';
import 'package:caspian_owner/core/notifications/api_notification_source.dart';
import 'package:caspian_owner/core/notifications/local_notifications.dart';
import 'package:caspian_owner/core/notifications/notification_poller.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
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
    final log = await _log();
    const store = DeviceSecureStore();
    // Nothing to do when logged out or turned off in Settings.
    if (await store.read(SecureKeys.session) == null) {
      log?.info('Background check skipped: signed out');
      return await _done(log);
    }
    if (!(await AppSettings.load(store)).notifications) {
      log?.info('Background check skipped: notifications off');
      return await _done(log);
    }

    try {
      final notifier = LocalNotifications();
      await notifier.init();
      final shown = await NotificationPoller(
        source: await _source(store),
        store: store,
        notifier: notifier,
      ).run();
      log?.info('Background check: $shown shown');
    } on Object catch (e, s) {
      // Offline, server error or session expired: try again next time.
      log?.error('Background check failed', e, s);
    }
    return await _done(log);
  });
}

/// The app's on-device log, with every background run recorded (also in
/// release builds), so «did the check run on this phone?» has an answer.
/// Null if the log folder can't be opened: the check runs anyway.
Future<AppLog?> _log() async {
  try {
    final dir = await getApplicationSupportDirectory();
    return AppLog(Directory('${dir.path}/logs'), minLevel: LogLevel.info);
  } on Object {
    return null;
  }
}

/// Writes the log before the background isolate ends.
Future<bool> _done(AppLog? log) async {
  await log?.flush();
  return true;
}

/// Built from what's on the phone: no app state lives in this isolate.
Future<NotificationSource> _source(SecureStore store) async =>
    switch (ApiConfig.dataSource) {
      DataSource.mock => MockNotificationSource(
        MockBackend(
          await MockFixtures.load(rootBundle, now: DateTime.now()),
          latency: Duration.zero,
        ),
      ),
      DataSource.api => await _apiSource(store),
    };

Future<NotificationSource> _apiSource(SecureStore store) async {
  final session = await AuthController.restore(store);
  final settings = await AppSettings.load(store);
  final client = ApiClient(
    baseUrl: settings.serverUrl,
    token: () => session?.accessToken,
  );
  return ApiNotificationSource(
    ChangesFeed(client),
    myId: () => session?.owner.id,
  );
}
