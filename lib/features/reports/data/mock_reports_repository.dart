import 'package:caspian_owner/core/domain/place_label.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/reports/domain/consumption_report.dart';
import 'package:caspian_owner/features/reports/domain/reports_repository.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';

class MockReportsRepository implements ReportsRepository {
  new(this._backend)
    : _directory = LocationDirectory(_backend.fixtures.locations);

  final MockBackend _backend;
  final LocationDirectory _directory;

  @override
  Future<ConsumptionReport> consumption({
    required ReportGrouping groupBy,
    required DateTime from,
    required DateTime to,
  }) => _backend.call(() {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day + 1);
    final items = {for (final s in _backend.stock) s.code: s};

    final issues = _backend.isEmpty
        ? const <({String key, ConsumptionLine line})>[]
        : [
            for (final m in _backend.movements)
              if (m.movement.kind == StockMovementKind.outgoing &&
                  m.movement.place != null &&
                  !m.movement.date.isBefore(start) &&
                  m.movement.date.isBefore(end))
                (
                  key: groupBy == ReportGrouping.floor
                      ? m.movement.place!.floorCode
                      : m.movement.place!.locationCode,
                  line: ConsumptionLine(
                    itemNameFa: items[m.itemCode]?.nameFa ?? m.itemCode,
                    qty: m.movement.qty,
                    unitFa: items[m.itemCode]?.unitFa ?? '',
                  ),
                ),
          ];

    List<ConsumptionLine> linesFor(String key) => [
      for (final i in issues)
        if (i.key == key) i.line,
    ];

    final rows = switch (groupBy) {
      // Every floor, in building order P4 → بام, even without consumption.
      ReportGrouping.floor => [
        for (final floor in _directory.floors)
          ConsumptionReportRow(
            code: floor.code,
            nameFa: floor.nameFa,
            total: linesFor(floor.code).length.toDouble(),
            lines: linesFor(floor.code),
          ),
      ],
      // Only locations that consumed something, busiest first.
      ReportGrouping.location => [
        for (final code in {for (final i in issues) i.key})
          ConsumptionReportRow(
            code: code,
            nameFa: toPersianDigits(_directory.location(code)?.nameFa ?? code),
            total: linesFor(code).length.toDouble(),
            lines: linesFor(code),
          ),
      ]..sort((a, b) => b.total.compareTo(a.total)),
    };

    return ConsumptionReport(groupBy: groupBy, from: from, to: to, rows: rows);
  });
}
