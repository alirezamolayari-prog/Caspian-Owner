import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/config/app_info.dart';
import 'package:caspian_owner/core/domain/config_repository.dart';
import 'package:caspian_owner/core/logging/app_log.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_config_repository.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/core/network/changes_feed.dart';
import 'package:caspian_owner/core/network/not_connected.dart';
import 'package:caspian_owner/core/notifications/api_notification_source.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/core/storage/cache_store.dart';
import 'package:caspian_owner/core/storage/pending_decision_queue.dart';
import 'package:caspian_owner/features/assistant/data/mock_assistant_repository.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_repository.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/auth/data/api_account_repository.dart';
import 'package:caspian_owner/features/auth/data/api_auth_repository.dart';
import 'package:caspian_owner/features/auth/data/mock_account_repository.dart';
import 'package:caspian_owner/features/auth/data/mock_auth_repository.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:caspian_owner/features/chat/data/api_chat_repository.dart';
import 'package:caspian_owner/features/chat/data/mock_chat_repository.dart';
import 'package:caspian_owner/features/chat/domain/chat_repository.dart';
import 'package:caspian_owner/features/more/data/users_repositories.dart';
import 'package:caspian_owner/features/more/domain/app_user.dart';
import 'package:caspian_owner/features/reports/data/mock_reports_repository.dart';
import 'package:caspian_owner/features/reports/domain/reports_repository.dart';
import 'package:caspian_owner/features/requests/data/api_requests_repository.dart';
import 'package:caspian_owner/features/requests/data/mock_requests_repository.dart';
import 'package:caspian_owner/features/requests/domain/requests_repository.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:caspian_owner/features/stock/data/mock_stock_repository.dart';
import 'package:caspian_owner/features/stock/domain/stock_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Values created at startup (bootstrap.dart) or by tests, then injected
// with `overrideWithValue`.

final appInfoProvider = Provider<AppInfo>(
  (ref) => throw UnimplementedError('Provided by bootstrap'),
);

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('Provided by bootstrap'),
);

final secureStoreProvider = Provider<SecureStore>(
  (ref) => throw UnimplementedError('Provided by bootstrap'),
);

/// The on-device log (null in tests that don't need it).
final appLogProvider = Provider<AppLog?>((ref) => null);

final deviceAuthenticatorProvider = Provider<DeviceAuthenticator>(
  (ref) => LocalDeviceAuthenticator(),
);

/// The in-app mock server; only used while [dataSourceProvider] is mock.
final mockBackendProvider = Provider<MockBackend>(
  (ref) => throw UnimplementedError('Provided by bootstrap'),
);

/// Mock or the real server. The app uses [ApiConfig.dataSource]; tests
/// override this with [DataSource.mock].
final dataSourceProvider = Provider<DataSource>((ref) => ApiConfig.dataSource);

// Storage built on the database.

final cacheStoreProvider = Provider<CacheStore>(
  (ref) => CacheStore(ref.watch(appDatabaseProvider)),
);

final pendingDecisionQueueProvider = Provider<PendingDecisionQueue>(
  (ref) => PendingDecisionQueue(ref.watch(appDatabaseProvider)),
);

// The server.

/// The logged-in owner's id, or null.
String? _myId(Ref ref) => switch (ref.read(authControllerProvider)) {
  SignedIn(:final session) => session.owner.id,
  SignedOut() => null,
};

/// The HTTP engine. Tests swap in a fake server (`test/helpers/fake_server.dart`)
/// so everything above it, token and `401` handling included, is the real code.
final apiDioProvider = Provider<Dio>((ref) => Dio());

/// Talks to the address from Settings, with the stored token. A `401` on
/// a signed-in request ends the session (back to the login screen).
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    dio: ref.watch(apiDioProvider),
    baseUrl: ref.watch(settingsControllerProvider.select((s) => s.serverUrl)),
    token: () => switch (ref.read(authControllerProvider)) {
      SignedIn(:final session) => session.accessToken,
      SignedOut() => null,
    },
    onUnauthorized: () =>
        ref.read(authControllerProvider.notifier).sessionExpired(),
  ),
);

final changesFeedProvider = Provider<ChangesFeed>(
  (ref) => ChangesFeed(ref.watch(apiClientProvider)),
);

/// What the current data source can do. Caspian Server v1 sends no stock,
/// 30-day use or same-place history, and has no «برگشت برای اصلاح».
class ServerCapabilities {
  const new({required this.stockInfo, required this.returnForEdit});

  /// «موجودی فعلی», «مصرف ۳۰ روز اخیر» and the same-place history.
  final bool stockInfo;
  final bool returnForEdit;

  /// Stock, assistant, reports and the notification list have data.
  bool get extraModules => stockInfo;
}

final serverCapabilitiesProvider = Provider<ServerCapabilities>(
  (ref) => switch (ref.watch(dataSourceProvider)) {
    DataSource.mock => const ServerCapabilities(
      stockInfo: true,
      returnForEdit: true,
    ),
    DataSource.api => const ServerCapabilities(
      stockInfo: false,
      returnForEdit: false,
    ),
  },
);

// Repositories. This is the only place that knows whether data comes from
// the mock backend or the server.

T _source<T>(
  Ref ref, {
  required T Function(MockBackend backend) mock,
  required T Function(ApiClient client) api,
}) => switch (ref.watch(dataSourceProvider)) {
  DataSource.mock => mock(ref.watch(mockBackendProvider)),
  DataSource.api => api(ref.watch(apiClientProvider)),
};

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) =>
      _source(ref, mock: MockAuthRepository.new, api: ApiAuthRepository.new),
);

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => _source(
    ref,
    mock: MockAccountRepository.new,
    api: ApiAccountRepository.new,
  ),
);

final configRepositoryProvider = Provider<ConfigRepository>(
  (ref) => _source(
    ref,
    mock: MockConfigRepository.new,
    api: (_) => const LocalConfigRepository(),
  ),
);

final requestsRepositoryProvider = Provider<RequestsRepository>(
  (ref) => _source(
    ref,
    mock: MockRequestsRepository.new,
    api: (client) => ApiRequestsRepository(client, myId: () => _myId(ref)),
  ),
);

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) =>
      _source(ref, mock: MockUsersRepository.new, api: ApiUsersRepository.new),
);

/// Every account, for «کاربران و دسترسی‌ها» (admins only).
final FutureProvider<List<AppUser>> usersListProvider =
    FutureProvider.autoDispose<List<AppUser>>(
      (ref) => ref.watch(usersRepositoryProvider).list(),
    );

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => _source(
    ref,
    mock: MockChatRepository.new,
    api: (client) => ApiChatRepository(client, myId: () => _myId(ref)),
  ),
);

final stockRepositoryProvider = Provider<StockRepository>(
  (ref) => _source(
    ref,
    mock: MockStockRepository.new,
    api: (_) => const NotConnectedStockRepository(),
  ),
);

final assistantRepositoryProvider = Provider<AssistantRepository>(
  (ref) => _source(
    ref,
    mock: MockAssistantRepository.new,
    api: (_) => const NotConnectedAssistantRepository(),
  ),
);

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => _source(
    ref,
    mock: MockReportsRepository.new,
    api: (_) => const NotConnectedReportsRepository(),
  ),
);

final notificationSourceProvider = Provider<NotificationSource>(
  (ref) => _source(
    ref,
    mock: MockNotificationSource.new,
    api: (_) => ApiNotificationSource(
      ref.watch(changesFeedProvider),
      myId: () => _myId(ref),
    ),
  ),
);
