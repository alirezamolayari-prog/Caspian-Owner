import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/security/secure_screen_scope.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/card_segment.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/module_app_bar.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/features/home/presentation/home_placeholder.dart';
import 'package:caspian_owner/features/requests/application/decision_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum RequestFilter { pending, reviewed, all }

final requestFilterProvider =
    NotifierProvider<RequestFilterController, RequestFilter>(
      RequestFilterController.new,
    );

class RequestFilterController extends Notifier<RequestFilter> {
  @override
  RequestFilter build() => RequestFilter.pending;

  RequestFilter get filter => state;
  set filter(RequestFilter value) => state = value;
}

bool matchesFilter(GoodsRequest r, RequestFilter filter) => switch (filter) {
  RequestFilter.pending => r.canDecide,
  RequestFilter.reviewed => r.isDecided,
  RequestFilter.all => true,
};

/// Requests tab (UI spec 5.2).
class RequestsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final requests = ref.watch(requestsControllerProvider);
    final filter = ref.watch(requestFilterProvider);

    Future<void> refresh() async {
      await ref.read(decisionControllerProvider.notifier).flush();
      await ref.read(requestsControllerProvider.notifier).refresh();
    }

    return SecureScreenScope(
      child: Scaffold(
        appBar: ModuleAppBar(title: Text(l10n.requestsTitle)),
        body: switch (requests) {
          AsyncValue(:final value?) => RefreshIndicator(
            onRefresh: refresh,
            child: _RequestsList(
              requests: value.value,
              cachedAt: value.cachedAt,
              filter: filter,
            ),
          ),
          AsyncValue(:final error?) => ErrorState(
            error: error,
            onRetry: refresh,
          ),
          _ => Skeletonizer(
            child: _RequestsList(
              requests: homePlaceholder().latest,
              filter: RequestFilter.all,
            ),
          ),
        },
      ),
    );
  }
}

class _RequestsList extends ConsumerWidget {
  const new({required this.requests, required this.filter, this.cachedAt});

  final List<GoodsRequest> requests;
  final RequestFilter filter;
  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final queued = ref.watch(queuedRequestIdsProvider).value ?? const {};
    final local = ref.watch(decisionControllerProvider);
    final visible = [
      for (final r in requests)
        if (matchesFilter(r, filter)) r,
    ];
    final pendingCount = requests.where((r) => r.canDecide).length;
    final cachedAt = this.cachedAt;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            Space.page,
            0,
            Space.page,
            Space.md,
          ),
          sliver: SliverList.list(
            children: [
              if (cachedAt != null) ...[
                StaleNotice(cachedAt: cachedAt),
                const SizedBox(height: Space.md),
              ],
              _FilterChips(selected: filter, pendingCount: pendingCount),
              if (visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.xl),
                  child: Text(
                    switch (filter) {
                      RequestFilter.pending => l10n.requestsEmptyPending,
                      RequestFilter.reviewed => l10n.requestsEmptyReviewed,
                      RequestFilter.all => l10n.requestsEmptyAll,
                    },
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
        // Built lazily: smooth with hundreds of requests.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            Space.page,
            0,
            Space.page,
            Space.lg,
          ),
          sliver: CardSliverList(
            itemCount: visible.length,
            itemBuilder: (context, i) {
              final request = visible[i];
              return RequestTile(
                request: request,
                queued:
                    queued.contains(request.id) ||
                    local[request.id]?.phase == DecisionPhase.queued,
                onTap: () => context.push(Routes.request(request.id)),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const new({required this.selected, required this.pendingCount});

  final RequestFilter selected;
  final int pendingCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final labels = {
      RequestFilter.pending: l10n.filterPending(pendingCount),
      RequestFilter.reviewed: l10n.filterReviewed,
      RequestFilter.all: l10n.filterAll,
    };
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: [
        for (final MapEntry(key: filter, value: label) in labels.entries)
          ChoiceChip(
            label: Text(label),
            selected: selected == filter,
            onSelected: (_) =>
                ref.read(requestFilterProvider.notifier).filter = filter,
          ),
      ],
    );
  }
}
