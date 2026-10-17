import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/security/secure_screen_scope.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/card_segment.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/module_app_bar.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/stock/application/stock_providers.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:caspian_owner/features/stock/presentation/movements_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Stock tab (UI spec 5.4).
class StockScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stock = ref.watch(stockControllerProvider);
    final controller = ref.read(stockControllerProvider.notifier);
    return SecureScreenScope(
      child: Scaffold(
        appBar: ModuleAppBar(title: Text(l10n.stockTitle)),
        body: switch (stock) {
          AsyncValue(:final value?) => RefreshIndicator(
            onRefresh: controller.refresh,
            child: _StockList(items: value.value, cachedAt: value.cachedAt),
          ),
          AsyncValue(:final error?) => ErrorState(
            error: error,
            onRetry: controller.refresh,
          ),
          _ => Skeletonizer(child: _StockList(items: _placeholder)),
        },
      ),
    );
  }
}

final List<StockItem> _placeholder = List.generate(
  8,
  (i) => StockItem(
    code: 'I-$i',
    nameFa: 'نام کالای انبار',
    unitFa: 'عدد',
    qty: 10,
    shelfFa: 'قفسه ۱ – ردیف ۲',
    low: false,
    lockedByCount: false,
  ),
);

class _StockList extends ConsumerWidget {
  const new({required this.items, this.cachedAt});

  final List<StockItem> items;
  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(stockQueryProvider);
    final lowOnly = ref.watch(stockLowOnlyProvider);
    final visible = filterStock(items, query: query, lowOnly: lowOnly);
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
              const _SearchField(),
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.sm,
                children: [
                  ChoiceChip(
                    label: Text(l10n.filterAll),
                    selected: !lowOnly,
                    onSelected: (_) =>
                        ref.read(stockLowOnlyProvider.notifier).lowOnly = false,
                  ),
                  ChoiceChip(
                    label: Text(l10n.filterLow),
                    selected: lowOnly,
                    onSelected: (_) =>
                        ref.read(stockLowOnlyProvider.notifier).lowOnly = true,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (visible.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Space.xl),
              child: Text(
                lowOnly && query.isEmpty ? l10n.stockNoLow : l10n.stockEmpty,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Space.page,
              0,
              Space.page,
              Space.lg,
            ),
            // Built lazily; the striped rows together look like one card.
            sliver: CardSliverList(
              itemCount: visible.length,
              itemBuilder: (context, i) => _StockRow(item: visible[i]),
            ),
          ),
      ],
    );
  }
}

class _SearchField extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  late final _controller = TextEditingController(
    text: ref.read(stockQueryProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        ref.read(stockQueryProvider.notifier).query = value;
        // Show or hide the clear button.
        setState(() {});
      },
      // A hint only: a floating label collides with the rounded outline
      // when the field is focused. TalkBack reads the hint as the label.
      decoration: InputDecoration(
        hintText: l10n.stockSearchLabel,
        prefixIcon: const Icon(AppIcons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: l10n.stockClearSearch,
                icon: const Icon(AppIcons.clear),
                onPressed: () {
                  _controller.clear();
                  ref.read(stockQueryProvider.notifier).query = '';
                  setState(() {});
                },
              ),
      ),
    );
  }
}

class _StockRow extends StatelessWidget {
  const new({required this.item});

  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final qty = item.qty;

    return InkWell(
      onTap: () => showMovementsSheet(context, item),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.md - Space.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.nameFa, style: theme.textTheme.titleSmall),
                    if (item.shelfFa case final shelf?)
                      Text(shelf, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: Space.sm),
              // Chip and quantity stack when there is no room side by
              // side (very large text).
              Flexible(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  children: [
                    if (item.lockedByCount || qty == null)
                      StatusChip(
                        label: l10n.hiddenByCount,
                        icon: AppIcons.hidden,
                      )
                    else ...[
                      if (item.low)
                        StatusChip(
                          label: l10n.lowStock,
                          icon: AppIcons.low,
                          tone: StatusTone.warning,
                        ),
                      Text(
                        l10n.qtyWithUnit(formatNumber(qty), item.unitFa),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
