import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Shown in release builds instead of Flutter's grey box when a part of a
/// screen fails to build: a short Persian message and «بازگشت». The error
/// itself goes to the on-device log (`FlutterError.onError` in bootstrap).
class FriendlyErrorWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    // Built where something broke: don't rely on anything above it.
    final l10n =
        Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        lookupAppLocalizations(const Locale('fa'));
    final theme = Theme.of(context);
    final navigator = Navigator.maybeOf(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: theme.colorScheme.surface,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.unknown,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: Space.md),
                Text(
                  l10n.errorWidgetTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: Space.sm),
                Text(
                  l10n.errorWidgetBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                if (navigator != null && navigator.canPop()) ...[
                  const SizedBox(height: Space.lg),
                  FilledButton(
                    onPressed: navigator.maybePop,
                    child: Text(l10n.errorWidgetBack),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
