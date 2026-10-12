import 'package:caspian_owner/features/reports/domain/consumption_report.dart';

/// Reports (contract: `/v1/reports/...`).
abstract interface class ReportsRepository {
  /// Consumption in [from]..[to] (inclusive dates). Grouped by floor, rows
  /// come in building order P4 → بام.
  Future<ConsumptionReport> consumption({
    required ReportGrouping groupBy,
    required DateTime from,
    required DateTime to,
  });
}
