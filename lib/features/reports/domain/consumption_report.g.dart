// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsumptionLine _$ConsumptionLineFromJson(Map<String, dynamic> json) =>
    _ConsumptionLine(
      itemNameFa: json['item_name_fa'] as String,
      qty: (json['qty'] as num).toDouble(),
      unitFa: json['unit_fa'] as String,
    );

Map<String, dynamic> _$ConsumptionLineToJson(_ConsumptionLine instance) =>
    <String, dynamic>{
      'item_name_fa': instance.itemNameFa,
      'qty': instance.qty,
      'unit_fa': instance.unitFa,
    };

_ConsumptionReportRow _$ConsumptionReportRowFromJson(
  Map<String, dynamic> json,
) => _ConsumptionReportRow(
  code: json['code'] as String,
  nameFa: json['name_fa'] as String,
  total: (json['total'] as num).toDouble(),
  lines: (json['lines'] as List<dynamic>?)
      ?.map((e) => ConsumptionLine.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ConsumptionReportRowToJson(
  _ConsumptionReportRow instance,
) => <String, dynamic>{
  'code': instance.code,
  'name_fa': instance.nameFa,
  'total': instance.total,
  'lines': ?instance.lines?.map((e) => e.toJson()).toList(),
};

_ConsumptionReport _$ConsumptionReportFromJson(Map<String, dynamic> json) =>
    _ConsumptionReport(
      groupBy: $enumDecode(_$ReportGroupingEnumMap, json['group_by']),
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => ConsumptionReportRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConsumptionReportToJson(_ConsumptionReport instance) =>
    <String, dynamic>{
      'group_by': _$ReportGroupingEnumMap[instance.groupBy]!,
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
      'rows': instance.rows.map((e) => e.toJson()).toList(),
    };

const _$ReportGroupingEnumMap = {
  ReportGrouping.floor: 'floor',
  ReportGrouping.location: 'location',
};
