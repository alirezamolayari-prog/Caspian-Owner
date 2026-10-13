import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/config/app_info.dart';
import 'package:caspian_owner/core/domain/config_repository.dart';
import 'package:caspian_owner/core/logging/app_log.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_config_repository.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/core/storage/cache_store.dart';
import 'package:caspian_owner/core/storage/pending_decision_queue.dart';
import 'package:caspian_owner/features/assistant/data/mock_assistant_repository.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_repository.dart';
import 'package:caspian_owner/features/auth/data/mock_auth_repository.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:caspian_owner/features/chat/data/mock_chat_repository.dart';
import 'package:caspian_owner/features/chat/domain/chat_repository.dart';
import 'package:caspian_owner/features/count/data/mock_count_repository.dart';
import 'package:caspian_owner/features/count/domain/count_repository.dart';
import 'package:caspian_owner/features/reports/data/mock_reports_repository.dart';
import 'package:caspian_owner/features/reports/domain/reports_repository.dart';
import 'package:caspian_owner/features/requests/data/mock_requests_repository.dart';
import 'package:caspian_owner/features/requests/domain/requests_repository.dart';
import 'package:caspian_owner/features/stock/data/mock_stock_repository.dart';
import 'package:caspian_owner/features/stock/domain/stock_repository.dart';
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

/// The in-app mock server; only used while [ApiConfig.dataSource] is mock.
final mockBackendProvider = Provider<MockBackend>(
  (ref) => throw UnimplementedError('Provided by bootstrap'),
);

// Storage built on the database.

final cacheStoreProvider = Provider<CacheStore>(
  (ref) => CacheStore(ref.watch(appDatabaseProvider)),
);

final pendingDecisionQueueProvider = Provider<PendingDecisionQueue>(
  (ref) => PendingDecisionQueue(ref.watch(appDatabaseProvider)),
);

// Repositories. This is the only place that knows whether data comes from
// the mock backend or the server.

T _source<T>(Ref ref, T Function(MockBackend backend) mock) =>
    switch (ApiConfig.dataSource) {
      DataSource.mock => mock(ref.watch(mockBackendProvider)),
      DataSource.api => throw UnimplementedError(
        'API repositories are added when the middle server exists.',
      ),
    };

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => _source(ref, MockAuthRepository.new),
);

final configRepositoryProvider = Provider<ConfigRepository>(
  (ref) => _source(ref, MockConfigRepository.new),
);

final requestsRepositoryProvider = Provider<RequestsRepository>(
  (ref) => _source(ref, MockRequestsRepository.new),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => _source(ref, MockChatRepository.new),
);

final stockRepositoryProvider = Provider<StockRepository>(
  (ref) => _source(ref, MockStockRepository.new),
);

final countRepositoryProvider = Provider<CountRepository>(
  (ref) => _source(ref, MockCountRepository.new),
);

final assistantRepositoryProvider = Provider<AssistantRepository>(
  (ref) => _source(ref, MockAssistantRepository.new),
);

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => _source(ref, MockReportsRepository.new),
);

final notificationSourceProvider = Provider<NotificationSource>(
  (ref) => _source(ref, MockNotificationSource.new),
);
