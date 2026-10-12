// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockItem _$StockItemFromJson(Map<String, dynamic> json) => _StockItem(
  code: json['code'] as String,
  nameFa: json['name_fa'] as String,
  unitFa: json['unit_fa'] as String,
  qty: (json['qty'] as num?)?.toDouble(),
  low: json['low'] as bool,
  lockedByCount: json['locked_by_count'] as bool,
  shelfFa: json['shelf_fa'] as String?,
);

Map<String, dynamic> _$StockItemToJson(_StockItem instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name_fa': instance.nameFa,
      'unit_fa': instance.unitFa,
      'qty': instance.qty,
      'low': instance.low,
      'locked_by_count': instance.lockedByCount,
      'shelf_fa': ?instance.shelfFa,
    };

_StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    _StockMovement(
      date: DateTime.parse(json['date'] as String),
      kind: $enumDecode(_$StockMovementKindEnumMap, json['kind']),
      qty: (json['qty'] as num).toDouble(),
      documentNo: json['document_no'] as String,
      place: json['place'] == null
          ? null
          : ConsumptionPlace.fromJson(json['place'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockMovementToJson(_StockMovement instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'kind': _$StockMovementKindEnumMap[instance.kind]!,
      'qty': instance.qty,
      'document_no': instance.documentNo,
      'place': ?instance.place?.toJson(),
    };

const _$StockMovementKindEnumMap = {
  StockMovementKind.incoming: 'in',
  StockMovementKind.outgoing: 'out',
  StockMovementKind.adjustment: 'adjustment',
};
