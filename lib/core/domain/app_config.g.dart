// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
  featureFlags: (json['feature_flags'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  modules: (json['modules'] as List<dynamic>).map((e) => e as String).toList(),
  minSupportedBuild: (json['min_supported_build'] as num).toInt(),
);

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'feature_flags': instance.featureFlags,
      'modules': instance.modules,
      'min_supported_build': instance.minSupportedBuild,
    };
