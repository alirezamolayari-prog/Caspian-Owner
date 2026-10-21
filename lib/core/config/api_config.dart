/// Where the app gets its data.
enum DataSource {
  /// In-app mock backend (`lib/core/mock/`), following `api/openapi.yaml`.
  /// Used by tests and previews.
  mock,

  /// The Caspian Server (FastAPI middle server).
  api,
}

/// Network configuration. The server address itself is an owner setting
/// (Settings › «آدرس سرور», kept on the phone); this is only its default.
abstract final class ApiConfig {
  static const DataSource dataSource = DataSource.api;

  /// First-run server address: Alireza's PC on the mall Wi-Fi. Changes to
  /// an https address on the Iranian host later (Settings or this value).
  static const String defaultServerUrl = 'http://192.168.10.58:8000';

  /// TEMPORARY for local testing: allow plain `http://` to addresses on the
  /// local network (192.168.x.x, 10.x.x.x, 172.16–31.x.x, localhost).
  /// Public addresses always need https. To remove: set this to false and
  /// set `cleartextTrafficPermitted="false"` in
  /// `android/app/src/main/res/xml/network_security_config.xml`.
  static const bool allowLanHttp = true;

  /// How often the open app asks the server «what changed?» (`/changes`).
  static const Duration liveSyncInterval = Duration(seconds: 5);

  /// Update manifest on the server; empty: the GitHub release is used.
  static const String baseUrl = '';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
