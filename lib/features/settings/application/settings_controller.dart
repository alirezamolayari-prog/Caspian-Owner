import 'dart:async';
import 'dart:convert';

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/config/server_url.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Owner preferences. Defaults are the safe choices. Kept on the phone
/// (survives logout, unlike the session).
class AppSettings {
  const new({
    this.fingerprintForApproval = true,
    this.secureScreens = true,
    this.notifications = true,
    this.themeMode = ThemeMode.system,
    this.serverUrl = ApiConfig.defaultServerUrl,
  });

  factory fromJson(Map<String, Object?> json) => AppSettings(
    fingerprintForApproval: json['fingerprint_for_approval'] as bool? ?? true,
    secureScreens: json['secure_screens'] as bool? ?? true,
    notifications: json['notifications'] as bool? ?? true,
    themeMode:
        ThemeMode.values.asNameMap()[json['theme_mode']] ?? ThemeMode.system,
    // A saved address that is no longer allowed (e.g. http after LAN http
    // is switched off) falls back to the default.
    serverUrl:
        ServerUrl.normalize(json['server_url'] as String? ?? '') ??
        ApiConfig.defaultServerUrl,
  );

  /// «آدرس سرور»: where Caspian Server runs, e.g. `http://192.168.10.58:8000`
  /// now, an https address on the Iranian host later.
  final String serverUrl;

  /// «تأیید با اثر انگشت برای تأیید درخواست»: one touch before approving.
  final bool fingerprintForApproval;

  /// Block screenshots on stock, requests and counts (FLAG_SECURE).
  final bool secureScreens;

  /// Background check for new requests, count results and messages.
  final bool notifications;

  /// Follows the phone by default.
  final ThemeMode themeMode;

  Map<String, Object?> toJson() => {
    'fingerprint_for_approval': fingerprintForApproval,
    'secure_screens': secureScreens,
    'notifications': notifications,
    'theme_mode': themeMode.name,
    'server_url': serverUrl,
  };

  AppSettings copyWith({
    bool? fingerprintForApproval,
    bool? secureScreens,
    bool? notifications,
    ThemeMode? themeMode,
    String? serverUrl,
  }) => AppSettings(
    fingerprintForApproval:
        fingerprintForApproval ?? this.fingerprintForApproval,
    secureScreens: secureScreens ?? this.secureScreens,
    notifications: notifications ?? this.notifications,
    themeMode: themeMode ?? this.themeMode,
    serverUrl: serverUrl ?? this.serverUrl,
  );

  /// Reads saved settings (bootstrap), or the defaults.
  static Future<AppSettings> load(SecureStore store) async {
    final raw = await store.read(SecureKeys.settings);
    if (raw == null) return const AppSettings();
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      return const AppSettings();
    }
  }
}

/// Settings loaded at startup (bootstrap).
final initialSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings(),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  void setFingerprintForApproval({required bool enabled}) =>
      _save(state.copyWith(fingerprintForApproval: enabled));

  void setSecureScreens({required bool enabled}) =>
      _save(state.copyWith(secureScreens: enabled));

  void setNotifications({required bool enabled}) =>
      _save(state.copyWith(notifications: enabled));

  set themeMode(ThemeMode mode) => _save(state.copyWith(themeMode: mode));
  ThemeMode get themeMode => state.themeMode;

  /// Saves a new server address. Returns false (and saves nothing) when
  /// [ServerUrl.problem] rejects it.
  bool setServerUrl(String url) {
    final normalized = ServerUrl.normalize(url);
    if (normalized == null) return false;
    _save(state.copyWith(serverUrl: normalized));
    return true;
  }

  void _save(AppSettings settings) {
    state = settings;
    unawaited(
      ref
          .read(secureStoreProvider)
          .write(SecureKeys.settings, jsonEncode(settings.toJson())),
    );
  }
}
