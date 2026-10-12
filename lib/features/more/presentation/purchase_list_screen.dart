import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// «لیست خرید»: placeholder until purchasing exists.
class PurchaseListScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.morePurchaseList)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppIcons.purchase,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: Space.md),
              Text(l10n.comingSoonBadge, style: theme.textTheme.titleLarge),
              const SizedBox(height: Space.sm),
              Text(
                l10n.purchaseBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
