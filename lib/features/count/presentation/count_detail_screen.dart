import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/security/secure_screen_scope.dart';
import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/features/count/application/count_providers.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A count's status, then its results (UI spec 5.5, step 3).
class CountDetailScreen extends ConsumerWidget {
  const new({required this.countId, super.key});

  final String countId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(countDetailProvider(countId));

    return SecureScreenScope(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.countDetailTitle)),
        body: switch (detail) {
          AsyncValue(:final value?) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(countDetailProvider(countId)),
            child: _CountBody(count: value.value, cachedAt: value.cachedAt),
          ),
          AsyncValue(:final error?) => ErrorState(
            error: error,
            onRetry: () => ref.invalidate(countDetailProvider(countId)),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _CountBody extends StatelessWidget {
  const new({required this.count, this.cachedAt});

  final SurpriseCount count;
  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cachedAt = this.cachedAt;
    final ordered = l10n.countOrderedBy(
      count.orderedBy.nameFa,
      formatRelativeTime(count.orderedAt, now: clock.now(), l10n: l10n),
    );
    final units = {for (final i in count.items) i.itemCode: i};

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        Space.page,
        Space.sm,
        Space.page,
        Space.lg,
      ),
      children: [
        if (cachedAt != null) ...[
          StaleNotice(cachedAt: cachedAt),
          const SizedBox(height: Space.md),
        ],
        if (count.status == CountStatus.running)
          Card(
            color: theme.colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.hidden, color: theme.colorScheme.primary),
                      const SizedBox(width: Space.sm),
                      Expanded(
                        child: Text(
                          l10n.countRunningTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    l10n.countRunningBody,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: Space.sm),
                  Text(ordered, style: theme.textTheme.bodySmall),
                  const SizedBox(height: Space.md),
                  for (final item in count.items)
                    Text(
                      '• ${item.itemNameFa}',
                      style: theme.textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          )
        else ...[
          Text(l10n.countDoneTitle, style: theme.textTheme.titleLarge),
          Text(ordered, style: theme.textTheme.bodySmall),
          if (count.finishedAt case final finished?)
            Text(
              l10n.countFinishedAt(formatJalaliDateTime(finished)),
              style: theme.textTheme.bodySmall,
            ),
          const SizedBox(height: Space.md),
          for (final result in count.results ?? const <CountResult>[]) ...[
            _ResultCard(
              result: result,
              name: units[result.itemCode]?.itemNameFa ?? result.itemCode,
              unit: units[result.itemCode]?.unitFa ?? '',
            ),
            const SizedBox(height: Space.md),
          ],
          Text(l10n.countNoAutoAdjust, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}

/// System vs counted, the difference (text + icon), and every entry.
class _ResultCard extends StatelessWidget {
  const new({required this.result, required this.name, required this.unit});

  final CountResult result;
  final String name;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final diff = result.difference;
    final amount = formatNumber(diff.abs());

    final (String label, IconData icon, Color fg, Color bg) = diff == 0
        ? (
            l10n.countMatch,
            AppIcons.approved,
            colors.success,
            colors.successContainer,
          )
        : diff < 0
        ? (
            l10n.countShort(amount, unit),
            AppIcons.low,
            theme.colorScheme.onErrorContainer,
            theme.colorScheme.errorContainer,
          )
        : (
            l10n.countOver(amount, unit),
            AppIcons.low,
            colors.warning,
            colors.warningContainer,
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            Row(
              children: [
                Expanded(
                  child: _Number(
                    label: l10n.countSystem,
                    value: l10n.qtyWithUnit(
                      formatNumber(result.systemQty),
                      unit,
                    ),
                  ),
                ),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: _Number(
                    label: l10n.countCounted,
                    value: l10n.qtyWithUnit(
                      formatNumber(result.countedQty),
                      unit,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.sm),
            DecoratedBox(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.all(
                  Radius.circular(Radii.chip),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Space.sm),
                child: Row(
                  children: [
                    Icon(icon, color: fg),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(color: fg),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Space.md),
            Text(l10n.countEntries, style: theme.textTheme.labelMedium),
            for (final entry in result.entries)
              Text(
                l10n.countEntry(
                  formatNumber(entry.qty),
                  entry.enteredBy.nameFa,
                  formatTime(entry.enteredAt),
                ),
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(Radii.chip + 6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.md - Space.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            Text(value, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
