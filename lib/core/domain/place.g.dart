// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Floor _$FloorFromJson(Map<String, dynamic> json) => _Floor(
  code: json['code'] as String,
  nameFa: json['name_fa'] as String,
  sortOrder: (json['sort_order'] as num).toInt(),
);

Map<String, dynamic> _$FloorToJson(_Floor instance) => <String, dynamic>{
  'code': instance.code,
  'name_fa': instance.nameFa,
  'sort_order': instance.sortOrder,
};

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  code: json['code'] as String,
  nameFa: json['name_fa'] as String,
  type: $enumDecode(_$LocationTypeEnumMap, json['type']),
  needsFloor: json['needs_floor'] as bool,
  isActive: json['is_active'] as bool,
  floorCode: json['floor_code'] as String?,
  aliases:
      (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  mergedWith:
      (json['merged_with'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'code': instance.code,
  'name_fa': instance.nameFa,
  'type': _$LocationTypeEnumMap[instance.type]!,
  'needs_floor': instance.needsFloor,
  'is_active': instance.isActive,
  'floor_code': ?instance.floorCode,
  'aliases': instance.aliases,
  'merged_with': instance.mergedWith,
};

const _$LocationTypeEnumMap = {
  LocationType.plate: 'plate',
  LocationType.named: 'named',
  LocationType.vertical: 'vertical',
  LocationType.general: 'general',
  LocationType.floorPlace: 'floor_place',
};

_LocationsSnapshot _$LocationsSnapshotFromJson(Map<String, dynamic> json) =>
    _LocationsSnapshot(
      version: json['version'] as String,
      floors: (json['floors'] as List<dynamic>)
          .map((e) => Floor.fromJson(e as Map<String, dynamic>))
          .toList(),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsSnapshotToJson(_LocationsSnapshot instance) =>
    <String, dynamic>{
      'version': instance.version,
      'floors': instance.floors.map((e) => e.toJson()).toList(),
      'locations': instance.locations.map((e) => e.toJson()).toList(),
    };

_ConsumptionPlace _$ConsumptionPlaceFromJson(Map<String, dynamic> json) =>
    _ConsumptionPlace(
      locationCode: json['location_code'] as String,
      floorCode: json['floor_code'] as String,
      usageNote: json['usage_note'] as String?,
    );

Map<String, dynamic> _$ConsumptionPlaceToJson(_ConsumptionPlace instance) =>
    <String, dynamic>{
      'location_code': instance.locationCode,
      'floor_code': instance.floorCode,
      'usage_note': ?instance.usageNote,
    };
