import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/count/application/count_providers.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «تاریخچه شمارش‌ها»: every surprise count, newest first.
class CountHistoryScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final counts = ref.watch(countsControllerProvider);
    final controller = ref.read(countsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.countHistoryTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.countNew),
        icon: const Icon(AppIcons.count),
        label: Text(l10n.countStart),
      ),
      body: switch (counts) {
        AsyncValue(:final value?) => RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              Space.page,
              Space.sm,
              Space.page,
              Space.xl * 3,
            ),
            children: [
              if (value.cachedAt case final cachedAt?) ...[
                StaleNotice(cachedAt: cachedAt),
                const SizedBox(height: Space.md),
              ],
              if (value.value.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(Space.xl),
                  child: Text(
                    l10n.countHistoryEmpty,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              else
                for (final count in value.value) ...[
                  _CountTile(count: count),
                  const SizedBox(height: Space.sm),
                ],
            ],
          ),
        ),
        AsyncValue(:final error?) => ErrorState(
          error: error,
          onRetry: controller.refresh,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _CountTile extends StatelessWidget {
  const new({required this.count});

  final SurpriseCount count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final running = count.status == CountStatus.running;
    final discrepancies =
        count.results?.where((r) => r.hasDiscrepancy).length ?? 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(Routes.count(count.id)),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatJalaliDate(count.orderedAt),
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      [
                        count.orderedBy.nameFa,
                        l10n.countItemsCount(count.items.length),
                        if (!running) l10n.countDiscrepancies(discrepancies),
                      ].join(' – '),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Space.sm),
              if (running)
                StatusChip(
                  label: l10n.countStatusRunning,
                  icon: AppIcons.pending,
                  tone: StatusTone.warning,
                )
              else
                StatusChip(
                  label: l10n.countStatusDone,
                  icon: AppIcons.approved,
                  tone: discrepancies > 0
                      ? StatusTone.error
                      : StatusTone.success,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
