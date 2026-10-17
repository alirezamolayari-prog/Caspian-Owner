import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/modules/module_providers.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A module that isn't built yet («به‌زودی»): what it will offer the
/// owner, and that it's only a part of that Caspian app.
class ModulePlaceholderScreen extends ConsumerWidget {
  const new({required this.moduleId, super.key});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final module = ref.watch(moduleRegistryProvider).byId(moduleId);
    final title = module?.title(context) ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (module != null)
                Icon(
                  module.icon,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              const SizedBox(height: Space.lg),
              Text(
                l10n.moduleComingSoonTitle(title),
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.sm),
              Text(
                l10n.moduleComingSoonBody,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
