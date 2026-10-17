import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/security/secure_screen_scope.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/features/count/application/count_providers.dart';
import 'package:caspian_owner/features/stock/application/stock_providers.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Start a surprise count (UI spec 5.5): pick items, confirm, start now.
class CountStartScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CountStartScreen> createState() => _CountStartScreenState();
}

class _CountStartScreenState extends ConsumerState<CountStartScreen> {
  String _query = '';
  bool _starting = false;

  Future<void> _confirmAndStart(List<StockItem> picked) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      // Above the bottom tabs, so the sheet is never cut off.
      useRootNavigator: true,
      builder: (context) => _ConfirmSheet(items: picked),
    );
    if (!(confirmed ?? false) || !mounted) return;

    setState(() => _starting = true);
    try {
      final count = await ref.read(countsControllerProvider.notifier).start([
        for (final i in picked) i.code,
      ]);
      if (!mounted) return;
      context.pushReplacement(Routes.count(count.id));
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage(e, l10n))));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final stock = ref.watch(stockControllerProvider);
    final selected = ref.watch(countSelectionProvider);
    final all = stock.value?.value ?? const <StockItem>[];
    final visible = filterStock(all, query: _query, lowOnly: false);
    final picked = [
      for (final i in all)
        if (selected.contains(i.code)) i,
    ];

    return SecureScreenScope(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.countPickTitle)),
        body: switch (stock) {
          AsyncValue(hasValue: true) => ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.page,
              0,
              Space.page,
              Space.lg,
            ),
            children: [
              Text(l10n.countPickHelp, style: theme.textTheme.bodyMedium),
              const SizedBox(height: Space.md),
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: l10n.stockSearchLabel,
                  prefixIcon: const Icon(AppIcons.search),
                ),
              ),
              const SizedBox(height: Space.md),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (final item in visible)
                      CheckboxListTile(
                        value: selected.contains(item.code),
                        // Items already being counted can't be picked.
                        onChanged: item.lockedByCount
                            ? null
                            : (_) => ref
                                  .read(countSelectionProvider.notifier)
                                  .toggle(item.code),
                        title: Text(item.nameFa),
                        subtitle: Text(
                          item.lockedByCount
                              ? l10n.countAlreadyRunning
                              : item.shelfFa ?? '',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          AsyncValue(:final error?) => ErrorState(
            error: error,
            onRetry: () => ref.invalidate(stockControllerProvider),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
        bottomNavigationBar: picked.isEmpty
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(Space.md),
                  child: FilledButton(
                    onPressed: _starting
                        ? null
                        : () => _confirmAndStart(picked),
                    child: Text(l10n.countContinueCount(picked.length)),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ConfirmSheet extends StatelessWidget {
  const new({required this.items});

  final List<StockItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.countConfirmTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: Space.sm),
            Text(l10n.countConfirmBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: Space.md),
            for (final item in items)
              Text('• ${item.nameFa}', style: theme.textTheme.bodyMedium),
            const SizedBox(height: Space.lg),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.countConfirmStart),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
