// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surprise_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CountItem _$CountItemFromJson(Map<String, dynamic> json) => _CountItem(
  itemCode: json['item_code'] as String,
  itemNameFa: json['item_name_fa'] as String,
  unitFa: json['unit_fa'] as String,
);

Map<String, dynamic> _$CountItemToJson(_CountItem instance) =>
    <String, dynamic>{
      'item_code': instance.itemCode,
      'item_name_fa': instance.itemNameFa,
      'unit_fa': instance.unitFa,
    };

_CountEntry _$CountEntryFromJson(Map<String, dynamic> json) => _CountEntry(
  qty: (json['qty'] as num).toDouble(),
  enteredBy: Person.fromJson(json['entered_by'] as Map<String, dynamic>),
  enteredAt: DateTime.parse(json['entered_at'] as String),
);

Map<String, dynamic> _$CountEntryToJson(_CountEntry instance) =>
    <String, dynamic>{
      'qty': instance.qty,
      'entered_by': instance.enteredBy.toJson(),
      'entered_at': instance.enteredAt.toIso8601String(),
    };

_CountResult _$CountResultFromJson(Map<String, dynamic> json) => _CountResult(
  itemCode: json['item_code'] as String,
  systemQty: (json['system_qty'] as num).toDouble(),
  countedQty: (json['counted_qty'] as num).toDouble(),
  entries: (json['entries'] as List<dynamic>)
      .map((e) => CountEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  countedBy: (json['counted_by'] as List<dynamic>)
      .map((e) => Person.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CountResultToJson(_CountResult instance) =>
    <String, dynamic>{
      'item_code': instance.itemCode,
      'system_qty': instance.systemQty,
      'counted_qty': instance.countedQty,
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'counted_by': instance.countedBy.map((e) => e.toJson()).toList(),
    };

_SurpriseCount _$SurpriseCountFromJson(Map<String, dynamic> json) =>
    _SurpriseCount(
      id: json['id'] as String,
      orderedBy: Owner.fromJson(json['ordered_by'] as Map<String, dynamic>),
      orderedAt: DateTime.parse(json['ordered_at'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => CountItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$CountStatusEnumMap, json['status']),
      finishedAt: json['finished_at'] == null
          ? null
          : DateTime.parse(json['finished_at'] as String),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => CountResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurpriseCountToJson(_SurpriseCount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ordered_by': instance.orderedBy.toJson(),
      'ordered_at': instance.orderedAt.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'status': _$CountStatusEnumMap[instance.status]!,
      'finished_at': ?instance.finishedAt?.toIso8601String(),
      'results': ?instance.results?.map((e) => e.toJson()).toList(),
    };

const _$CountStatusEnumMap = {
  CountStatus.running: 'running',
  CountStatus.done: 'done',
};
