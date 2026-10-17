import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/code_text.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:caspian_owner/features/stock/application/stock_providers.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Recent in/out history of one item (UI spec 5.4).
Future<void> showMovementsSheet(BuildContext context, StockItem item) {
  // Close the keyboard first, or focus (and the keyboard) comes back to the
  // field under the sheet when it closes.
  FocusManager.instance.primaryFocus?.unfocus();
  return showModalBottomSheet<void>(
    context: context,
    // Above the bottom tabs, so the sheet is never cut off.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scroll) =>
          _MovementsSheet(item: item, scrollController: scroll),
    ),
  );
}

class _MovementsSheet extends ConsumerWidget {
  const new({required this.item, required this.scrollController});

  final StockItem item;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final hidden = item.lockedByCount || item.qty == null;
    final movements = hidden
        ? null
        : ref.watch(stockMovementsProvider(item.code));

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
      children: [
        Text(item.nameFa, style: theme.textTheme.titleLarge),
        LabeledCode(
          label: l10n.itemCodeLabel,
          code: item.code,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: Space.md),
        Semantics(
          header: true,
          child: Text(l10n.movementsTitle, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: Space.sm),
        if (hidden)
          Text(l10n.stockHiddenExplain, style: theme.textTheme.bodyMedium)
        else
          switch (movements!) {
            AsyncValue(:final value?) when value.value.isEmpty => Text(
              l10n.movementsEmpty,
              style: theme.textTheme.bodyMedium,
            ),
            AsyncValue(:final value?) => Column(
              children: [
                for (final m in value.value)
                  _MovementRow(movement: m, unit: item.unitFa),
              ],
            ),
            AsyncValue(:final error?) => Text(
              errorMessage(error, l10n),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            _ => const Padding(
              padding: EdgeInsets.all(Space.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
          },
      ],
    );
  }
}

class _MovementRow extends ConsumerWidget {
  const new({required this.movement, required this.unit});

  final StockMovement movement;
  final String unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final directory = ref.watch(locationDirectoryProvider).value;
    final place = movement.place;

    final (String kind, IconData icon, Color color) = switch (movement.kind) {
      StockMovementKind.incoming => (
        l10n.movementIn,
        AppIcons.incoming,
        colors.success,
      ),
      StockMovementKind.outgoing => (
        l10n.movementOut,
        AppIcons.outgoing,
        theme.colorScheme.onSurfaceVariant,
      ),
      // Words, not a minus sign: easier to read correctly in RTL.
      StockMovementKind.adjustment => (
        movement.qty < 0 ? l10n.movementAdjustDown : l10n.movementAdjustUp,
        AppIcons.adjust,
        colors.warning,
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.historyLine(
                    kind,
                    formatNumber(movement.qty.abs()),
                    unit,
                  ),
                  style: theme.textTheme.titleSmall,
                ),
                if (place != null && directory != null)
                  Text(
                    directory.label(place),
                    style: theme.textTheme.bodySmall,
                  ),
                Text(
                  l10n.movementMeta(
                    formatJalaliDate(movement.date),
                    toPersianDigits(movement.documentNo),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
