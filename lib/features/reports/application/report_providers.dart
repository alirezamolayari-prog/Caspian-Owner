import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/features/reports/domain/consumption_report.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:shamsi_date/shamsi_date.dart';

enum ReportPeriod { thisMonth, last30, last90 }

/// First and last day of [period], ending today. «این ماه» is the Jalali
/// month, as owners count months.
({DateTime from, DateTime to}) periodRange(ReportPeriod period) {
  final now = clock.now();
  final today = DateTime(now.year, now.month, now.day);
  return switch (period) {
    ReportPeriod.thisMonth => (
      from: Jalali.fromDateTime(today).copy(day: 1).toDateTime(),
      to: today,
    ),
    ReportPeriod.last30 => (
      from: today.subtract(const Duration(days: 29)),
      to: today,
    ),
    ReportPeriod.last90 => (
      from: today.subtract(const Duration(days: 89)),
      to: today,
    ),
  };
}

typedef ReportQuery = ({ReportGrouping groupBy, ReportPeriod period});

final FutureProviderFamily<ConsumptionReport, ReportQuery>
consumptionReportProvider = FutureProvider.family((ref, query) {
  final range = periodRange(query.period);
  return ref
      .read(reportsRepositoryProvider)
      .consumption(groupBy: query.groupBy, from: range.from, to: range.to);
});
