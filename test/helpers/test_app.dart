import 'package:caspian_owner/app.dart';
import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/config/app_info.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/secure_screen.dart';
import 'package:caspian_owner/core/security/secure_screen_scope.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/core/theme/app_theme.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show DatabaseConnection, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import 'mock_setup.dart';

/// A single widget with the app's theme and Persian locale (no router).
Widget themedApp(Widget home, {ThemeMode themeMode = ThemeMode.light}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: CaspianOwnerApp.locale,
      supportedLocales: const [CaspianOwnerApp.locale],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    );

class FakeAuthenticator implements DeviceAuthenticator {
  new({this.available = true, this.succeeds = true});

  bool available;
  bool succeeds;
  int prompts = 0;
  AuthPrompt? lastPrompt;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(AuthPrompt prompt) async {
    prompts++;
    lastPrompt = prompt;
    return succeeds;
  }
}

/// Records what the app asked Android for (FLAG_SECURE).
class FakeSecureScreen extends SecureScreen {
  /// The last value sent; null before the first change.
  bool? secure;

  @override
  Future<void> set({required bool secure}) async => this.secure = secure;
}

const testOwner = Owner(id: 'o-1', nameFa: 'علیرضا', isAdmin: true);

AuthSession testSession([Owner owner = testOwner]) => AuthSession(
  accessToken: 'a',
  refreshToken: 'r',
  expiresAt: DateTime(2030),
  owner: owner,
);

/// Everything the full app needs, with in-memory fakes.
class TestHarness {
  new _({
    required this.backend,
    required this.store,
    required this.authenticator,
    required this.database,
    required this.secureScreen,
    required this.overrides,
  });

  /// Builds the fakes from already-loaded [fixtures]. Synchronous, so it is
  /// safe inside `testWidgets` (real file I/O never completes on its fake
  /// clock; load fixtures in `setUpAll`).
  ///
  /// With [server] the app talks to that fake Caspian Server instead of the
  /// mock backend, through the real `ApiClient` (token, 401 → sign out).
  factory create(
    MockFixtures fixtures, {
    bool signedIn = false,
    bool deviceAuthAvailable = true,
    bool hasPin = false,
    bool isDebug = true,
    Owner owner = testOwner,
    UpdateChecker? updateChecker,
    HttpClientAdapter? server,
  }) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final backend = MockBackend(fixtures, latency: Duration.zero);
    final store = MemorySecureStore();
    final authenticator = FakeAuthenticator(available: deviceAuthAvailable);
    final secureScreen = FakeSecureScreen();
    // Synchronous stream closing: drift otherwise closes unused query
    // streams on a timer, which widget tests report as a pending Timer.
    final database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    return TestHarness._(
      backend: backend,
      store: store,
      authenticator: authenticator,
      database: database,
      secureScreen: secureScreen,
      overrides: [
        appInfoProvider.overrideWithValue(
          AppInfo(
            version: '0.1.0',
            buildNumber: 1,
            deviceId: 'test-device',
            deviceModel: 'test',
            isDebug: isDebug,
          ),
        ),
        secureStoreProvider.overrideWithValue(store),
        deviceAuthenticatorProvider.overrideWithValue(authenticator),
        secureScreenProvider.overrideWithValue(secureScreen),
        appDatabaseProvider.overrideWithValue(database),
        mockBackendProvider.overrideWithValue(backend),
        dataSourceProvider.overrideWithValue(
          server == null ? DataSource.mock : DataSource.api,
        ),
        if (server != null)
          apiDioProvider.overrideWith(
            (ref) => Dio()..httpClientAdapter = server,
          ),
        // No network in tests: the update check finds nothing.
        updateCheckerProvider.overrideWithValue(
          updateChecker ?? UpdateChecker(urls: const []),
        ),
        initialSessionProvider.overrideWithValue(
          signedIn ? testSession(owner) : null,
        ),
        lockSetupProvider.overrideWithValue(
          LockSetup(deviceAuthAvailable: deviceAuthAvailable, hasPin: hasPin),
        ),
      ],
    );
  }

  final MockBackend backend;
  final MemorySecureStore store;
  final FakeAuthenticator authenticator;
  final AppDatabase database;
  final FakeSecureScreen secureScreen;
  final List<Override> overrides;

  /// Loads the fixtures, then creates. For plain (non-widget) tests.
  static Future<TestHarness> load({
    bool signedIn = false,
    bool deviceAuthAvailable = true,
    bool hasPin = false,
  }) async => TestHarness.create(
    await loadTestFixtures(),
    signedIn: signedIn,
    deviceAuthAvailable: deviceAuthAvailable,
    hasPin: hasPin,
  );

  /// The whole app, as `main()` builds it.
  Widget app({List<Override> extra = const []}) => ProviderScope(
    overrides: [...overrides, ...extra],
    retry: (retryCount, error) => null,
    child: const CaspianOwnerApp(themeMode: ThemeMode.light),
  );

  ProviderContainer container({List<Override> extra = const []}) =>
      ProviderContainer(
        overrides: [...overrides, ...extra],
        retry: (retryCount, error) => null,
      );
}
