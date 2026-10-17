import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

/// Server-side switches for this owner (contract: `AppConfig`).
@freezed
abstract class AppConfig with _$AppConfig {
  const factory({
    /// Enabled features, e.g. `assistant`, `reports`.
    required List<String> featureFlags,

    /// Enabled modules, e.g. `warehouse`. Other Caspian apps plug in here.
    required List<String> modules,

    /// Builds below this must update before use (blocking update screen).
    required int minSupportedBuild,
  }) = _AppConfig;

  const new _();

  factory fromJson(Map<String, Object?> json) => _$AppConfigFromJson(json);

  bool hasFlag(String flag) => featureFlags.contains(flag);
}

/// Feature flag names used by the app.
abstract final class FeatureFlags {
  static const assistant = 'assistant';
  static const reports = 'reports';
  static const purchaseList = 'purchase_list';
}
