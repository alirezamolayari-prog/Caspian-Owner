import 'package:flutter/foundation.dart' show kReleaseMode;

/// Where the app gets its data.
enum DataSource {
  /// In-app mock backend (`lib/core/mock/`), following `api/openapi.yaml`.
  /// Used by tests and previews.
  mock,

  /// The Caspian Server (FastAPI middle server).
  api,
}

/// Network configuration.
abstract final class ApiConfig {
  static const DataSource dataSource = DataSource.api;

  /// Caspian Server on the Iranian host. Release builds always use it.
  static const String defaultServerUrl = 'https://api.caspianmoblserver.ir';

  /// Debug builds only: the server address can be changed (Settings ›
  /// «آدرس سرور», developer testing against a PC on the mall Wi-Fi).
  /// Release builds ignore any saved address.
  static const bool serverUrlEditable = !kReleaseMode;

  /// Debug builds only: plain `http://` to local-network addresses
  /// (192.168.x.x, 10.x.x.x, 172.16–31.x.x, localhost). Release builds
  /// are https only, here and in Android's network security config.
  static const bool allowLanHttp = !kReleaseMode;

  /// How often the open app asks the server «what changed?» (`/changes`).
  static const Duration liveSyncInterval = Duration(seconds: 5);

  /// Update manifest on the server; empty: the GitHub release is used.
  static const String baseUrl = '';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
