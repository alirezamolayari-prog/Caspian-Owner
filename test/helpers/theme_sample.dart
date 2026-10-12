import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';

/// A screen that exercises the theme: type scale, hero card, chips, buttons.
/// Used by the M2 golden and accessibility tests.
class ThemeSample extends StatelessWidget {
  const new({super.key});

  static final DateTime fixedNow = DateTime(2026, 10, 12, 15);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final text = theme.textTheme;
    final updated = formatRelativeTime(
      fixedNow.subtract(const Duration(minutes: 10)),
      now: fixedNow,
      l10n: l10n,
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.page),
          children: [
            Text(l10n.appTitle, style: text.headlineMedium),
            const SizedBox(height: Space.md),
            Card(
              color: s.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(Radii.hero)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatNumber(3),
                      style: text.displaySmall?.copyWith(color: s.onPrimary),
                    ),
                    const SizedBox(height: Space.md),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: s.onPrimary,
                        foregroundColor: s.primary,
                      ),
                      onPressed: () {},
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Space.md),
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                StatusChip(label: l10n.statusPending, icon: AppIcons.pending),
                StatusChip(
                  label: l10n.statusApproved,
                  icon: AppIcons.approved,
                  tone: StatusTone.success,
                ),
                StatusChip(
                  label: l10n.statusRejected,
                  icon: AppIcons.rejected,
                  tone: StatusTone.error,
                ),
                StatusChip(
                  label: l10n.lowStock,
                  icon: AppIcons.low,
                  tone: StatusTone.warning,
                ),
              ],
            ),
            const SizedBox(height: Space.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Text(l10n.lastUpdated(updated), style: text.bodySmall),
              ),
            ),
            const SizedBox(height: Space.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(l10n.statusRejected),
                  ),
                ),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(l10n.statusApproved),
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
