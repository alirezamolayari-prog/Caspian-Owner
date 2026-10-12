import 'package:freezed_annotation/freezed_annotation.dart';

part 'consumption_report.freezed.dart';
part 'consumption_report.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ReportGrouping { floor, location }

@freezed
abstract class ConsumptionLine with _$ConsumptionLine {
  const factory({
    required String itemNameFa,
    required double qty,
    required String unitFa,
  }) = _ConsumptionLine;

  factory fromJson(Map<String, Object?> json) =>
      _$ConsumptionLineFromJson(json);
}

@freezed
abstract class ConsumptionReportRow with _$ConsumptionReportRow {
  const factory({
    required String code,
    required String nameFa,

    /// Number of issued line items in the period.
    required double total,
    List<ConsumptionLine>? lines,
  }) = _ConsumptionReportRow;

  factory fromJson(Map<String, Object?> json) =>
      _$ConsumptionReportRowFromJson(json);
}

/// Consumption by floor (building order) or by location
/// (contract: `ConsumptionReport`).
@freezed
abstract class ConsumptionReport with _$ConsumptionReport {
  const factory({
    required ReportGrouping groupBy,
    required DateTime from,
    required DateTime to,
    required List<ConsumptionReportRow> rows,
  }) = _ConsumptionReport;

  factory fromJson(Map<String, Object?> json) =>
      _$ConsumptionReportFromJson(json);
}
