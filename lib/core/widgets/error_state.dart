import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:flutter/material.dart';

/// Shown when data could not be loaded and nothing is cached.
class ErrorState extends StatelessWidget {
  const new({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.error, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: Space.md),
            Text(
              l10n.errorTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.sm),
            Text(
              errorMessage(error, l10n),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.lg),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(AppIcons.retry),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
