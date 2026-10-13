import 'dart:async';
import 'dart:io';

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/config/app_info.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/logging/app_log.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/notifications/background_poll.dart';
import 'package:caspian_owner/core/notifications/local_notifications.dart';
import 'package:caspian_owner/core/notifications/notification_providers.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Everything the app needs before its first frame, as provider overrides:
/// stored session, device id, app info, lock setup, database, mock data.
Future<List<Override>> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  const store = DeviceSecureStore();
  var deviceId = await store.read(SecureKeys.deviceId);
  if (deviceId == null) {
    deviceId = const Uuid().v4();
    await store.write(SecureKeys.deviceId, deviceId);
  }

  // On-device error log (no third-party crash service).
  final log = AppLog(
    Directory('${(await getApplicationSupportDirectory()).path}/logs'),
  );
  final flutterOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    log.error('Flutter error', details.exception, details.stack);
    flutterOnError?.call(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log.error('Uncaught error', error, stack);
    return true;
  };

  final authenticator = LocalDeviceAuthenticator();
  final info = await AppInfo.load(deviceId: deviceId);
  log.info('Start ${info.fullVersion} on ${info.deviceModel}');
  final session = await AuthController.restore(store);
  final lockSetup = LockSetup(
    deviceAuthAvailable: await authenticator.isAvailable(),
    hasPin: await store.read(SecureKeys.pinHash) != null,
  );

  // Notifications: taps while running go through a stream; a tap that
  // launched the app is opened after the first frame.
  final taps = StreamController<String>.broadcast();
  final notifications = LocalNotifications();
  String? launchTarget;
  try {
    await notifications.init(onTap: taps.add);
    launchTarget = await notifications.launchTarget();
    await NotificationSchedule.initialize();
  } on Object catch (e, s) {
    log.error('Notifications setup failed', e, s);
  }

  return [
    localNotificationsProvider.overrideWithValue(notifications),
    notificationTapsProvider.overrideWithValue(taps),
    launchNotificationTargetProvider.overrideWithValue(launchTarget),
    notificationSchedulerProvider.overrideWithValue(
      NotificationScheduler(
        start: NotificationSchedule.start,
        stop: NotificationSchedule.stop,
        askPermission: notifications.requestPermission,
      ),
    ),
    appLogProvider.overrideWithValue(log),
    initialSettingsProvider.overrideWithValue(await AppSettings.load(store)),
    appInfoProvider.overrideWithValue(info),
    secureStoreProvider.overrideWithValue(store),
    deviceAuthenticatorProvider.overrideWithValue(authenticator),
    appDatabaseProvider.overrideWithValue(AppDatabase()),
    initialSessionProvider.overrideWithValue(session),
    lockSetupProvider.overrideWithValue(lockSetup),
    if (ApiConfig.dataSource == DataSource.mock)
      mockBackendProvider.overrideWithValue(
        MockBackend(await MockFixtures.load(rootBundle, now: DateTime.now())),
      ),
  ];
}
