import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/config/app_info.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
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

  final authenticator = LocalDeviceAuthenticator();
  final info = await AppInfo.load(deviceId: deviceId);
  final session = await AuthController.restore(store);
  final lockSetup = LockSetup(
    deviceAuthAvailable: await authenticator.isAvailable(),
    hasPin: await store.read(SecureKeys.pinHash) != null,
  );

  return [
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
