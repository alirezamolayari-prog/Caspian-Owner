/// Where the app gets its data.
enum DataSource {
  /// In-app mock backend (`lib/core/mock/`), following `api/openapi.yaml`.
  mock,

  /// The middle server over HTTPS.
  api,
}

/// Network configuration. Switching to the real server is one change:
/// set [dataSource] to [DataSource.api] and fill in [baseUrl].
/// (Debug builds can also switch at runtime from the developer screen.)
abstract final class ApiConfig {
  static const DataSource dataSource = DataSource.mock;

  /// HTTPS base URL of the middle server. Empty until it exists.
  static const String baseUrl = '';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
