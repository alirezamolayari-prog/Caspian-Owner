import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/home/presentation/home_placeholder.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Home (UI spec 5.1): pending hero card, latest requests, surprise count.
/// Nothing else.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final auth = ref.watch(authControllerProvider);
    final name = auth is SignedIn ? auth.session.owner.nameFa : '';
    final home = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: Space.page,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeGreeting(name), style: text.bodySmall),
            Text(Brand.shortNameFa, style: text.headlineMedium),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.notificationsTooltip,
            icon: const Icon(AppIcons.notifications),
            onPressed: () => context.push(Routes.notifications),
          ),
          IconButton(
            tooltip: l10n.accountTooltip,
            icon: const Icon(AppIcons.account),
            onPressed: () => context.push(Routes.more),
          ),
          const SizedBox(width: Space.sm),
        ],
      ),
      body: switch (home) {
        AsyncValue(:final value?) => RefreshIndicator(
          onRefresh: controller.refresh,
          child: _HomeContent(data: value),
        ),
        AsyncValue(:final error?) => ErrorState(
          error: error,
          onRetry: controller.refresh,
        ),
        _ => Skeletonizer(child: _HomeContent(data: homePlaceholder())),
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const new({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final cachedAt = data.cachedAt;
    return ListView(
      // Always scrollable, so pull-to-refresh works on short content.
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
        _PendingCard(count: data.pendingCount),
        const SizedBox(height: Space.md),
        _LatestRequestsCard(data: data),
        const SizedBox(height: Space.md),
        _CountCard(lastCount: data.lastCount),
      ],
    );
  }
}

/// Hero card: «منتظر تأیید شما – ۴ درخواست», or a calm empty state.
class _PendingCard extends StatelessWidget {
  const new({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(Radii.hero)),
    );

    if (count == 0) {
      return Card(
        color: s.primaryContainer,
        shape: shape,
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(
            children: [
              Icon(AppIcons.allDone, size: 40, color: s.onPrimaryContainer),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeAllReviewed,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: s.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      l10n.homeAllReviewedBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: s.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: s.primary,
      shape: shape,
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homePendingTitle,
              style: theme.textTheme.titleMedium?.copyWith(color: s.onPrimary),
            ),
            const SizedBox(height: Space.xs),
            Text(
              l10n.homePendingCount(count),
              style: theme.textTheme.displaySmall?.copyWith(color: s.onPrimary),
            ),
            const SizedBox(height: Space.md),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: s.onPrimary,
                foregroundColor: s.primary,
              ),
              onPressed: () => context.go(Routes.requests),
              child: Text(l10n.homeReviewRequests),
            ),
          ],
        ),
      ),
    );
  }
}

/// «آخرین درخواست‌ها»: the 3 newest requests.
class _LatestRequestsCard extends StatelessWidget {
  const new({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.md,
              Space.md,
              Space.md,
              Space.xs,
            ),
            child: Semantics(
              header: true,
              child: Text(
                l10n.homeLatestRequests,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          if (data.latest.isEmpty)
            Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Text(
                l10n.homeNoRequests,
                style: theme.textTheme.bodyMedium,
              ),
            )
          else
            for (final (i, request) in data.latest.indexed) ...[
              if (i > 0) const Divider(indent: Space.md, endIndent: Space.md),
              RequestTile(
                request: request,
                onTap: () => context.push(Routes.request(request.id)),
              ),
            ],
          const SizedBox(height: Space.xs),
        ],
      ),
    );
  }
}

/// «شمارش غافلگیرانه»: when the last count was, and «شروع».
class _CountCard extends StatelessWidget {
  const new({required this.lastCount});

  final SurpriseCount? lastCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final count = lastCount;
    final subtitle = switch (count) {
      null => l10n.countNever,
      SurpriseCount(status: CountStatus.running) => l10n.countRunningNow,
      SurpriseCount(:final finishedAt, :final orderedAt) => l10n.countLastTime(
        toPersianDigits(formatJalaliDate(finishedAt ?? orderedAt)),
      ),
    };

    return Card(
      color: theme.colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      // The card opens the count history; «شروع» starts a new count.
      child: InkWell(
        onTap: () => context.push(Routes.counts),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Row(
            children: [
              Icon(AppIcons.count, color: theme.colorScheme.primary),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.countCardTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: Space.sm),
              FilledButton.tonal(
                onPressed: () => context.push(Routes.countNew),
                child: Text(l10n.countStart),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
