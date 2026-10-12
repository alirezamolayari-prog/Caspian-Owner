import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/features/reports/application/report_providers.dart';
import 'package:caspian_owner/features/reports/domain/consumption_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «گزارش‌ها»: consumption by floor (building order P4 → بام) or location.
class ReportsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportGrouping _groupBy = ReportGrouping.floor;
  ReportPeriod _period = ReportPeriod.thisMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final query = (groupBy: _groupBy, period: _period);
    final report = ref.watch(consumptionReportProvider(query));
    final range = periodRange(_period);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.page,
          Space.sm,
          Space.page,
          Space.lg,
        ),
        children: [
          SegmentedButton<ReportGrouping>(
            segments: [
              ButtonSegment(
                value: ReportGrouping.floor,
                label: Text(l10n.reportByFloor),
              ),
              ButtonSegment(
                value: ReportGrouping.location,
                label: Text(l10n.reportByLocation),
              ),
            ],
            selected: {_groupBy},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _groupBy = s.first),
          ),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final (period, label) in [
                (ReportPeriod.thisMonth, l10n.periodThisMonth),
                (ReportPeriod.last30, l10n.periodLast30),
                (ReportPeriod.last90, l10n.periodLast90),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _period == period,
                  onSelected: (_) => setState(() => _period = period),
                ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            l10n.reportRange(
              formatJalaliDate(range.from),
              formatJalaliDate(range.to),
            ),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: Space.md),
          switch (report) {
            AsyncValue(:final value?) => _ReportRows(report: value),
            AsyncValue(:final error?) => ErrorState(
              error: error,
              onRetry: () => ref.invalidate(consumptionReportProvider(query)),
            ),
            _ => const Padding(
              padding: EdgeInsets.all(Space.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
          },
        ],
      ),
    );
  }
}

class _ReportRows extends StatelessWidget {
  const new({required this.report});

  final ConsumptionReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rows = report.rows;
    final maxTotal = rows.fold<double>(0, (m, r) => r.total > m ? r.total : m);

    if (rows.isEmpty || maxTotal == 0) {
      return Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Text(
          l10n.reportEmpty,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (i, row) in rows.indexed) ...[
            if (i > 0) const Divider(indent: Space.md, endIndent: Space.md),
            ExpansionTile(
              title: Text(toPersianDigits(row.nameFa)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.total == 0
                        ? l10n.reportNoConsumption
                        : l10n.reportRowTotal(row.total.round()),
                  ),
                  const SizedBox(height: Space.xs),
                  // Decorative: the number above carries the value.
                  ExcludeSemantics(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Space.xs),
                      ),
                      child: LinearProgressIndicator(
                        value: row.total / maxTotal,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.surfaceContainer,
                      ),
                    ),
                  ),
                ],
              ),
              enabled: (row.lines ?? const []).isNotEmpty,
              children: [
                for (final line in row.lines ?? const <ConsumptionLine>[])
                  ListTile(
                    dense: true,
                    title: Text(
                      l10n.historyLine(
                        line.itemNameFa,
                        formatNumber(line.qty),
                        line.unitFa,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
