import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:caspian_owner/core/modules/module_providers.dart';
import 'package:caspian_owner/core/router/app_shell.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «کاسپین»: where the app opens. One large tile per Caspian module, in a
/// 2×2 grid; each active module has its own bottom tabs behind its tile.
class HubScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final auth = ref.watch(authControllerProvider);
    final name = auth is SignedIn ? auth.session.owner.nameFa : '';
    final config = ref.watch(appConfigProvider).value;
    final tiles = config == null
        ? const <(AppModule, ModuleAvailability)>[]
        : ref.watch(moduleRegistryProvider).hubTiles(config);

    return UpdateOfferHost(
      child: Scaffold(
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
        body: config == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(Space.page),
                children: [
                  // Two per row; rows grow with large text instead of
                  // clipping it (no fixed-aspect grid).
                  for (var i = 0; i < tiles.length; i += 2) ...[
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _ModuleTile(entry: tiles[i])),
                          const SizedBox(width: Space.md),
                          Expanded(
                            child: i + 1 < tiles.length
                                ? _ModuleTile(entry: tiles[i + 1])
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Space.md),
                  ],
                ],
              ),
      ),
    );
  }
}

class _ModuleTile extends ConsumerWidget {
  const new({required this.entry});

  final (AppModule, ModuleAvailability) entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (module, availability) = entry;
    final active = availability == ModuleAvailability.active;
    final badge = active ? module.badge(ref) : null;
    final title = module.title(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => active
            ? context.go(module.tabs.first.path)
            : context.push(Routes.module(module.id)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 168),
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The badge moves under the icon when there's no room beside
                // it (narrow phones, large text).
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: active
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainer,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Radii.chip + 6),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Space.sm + Space.xs),
                        child: Icon(
                          module.icon,
                          size: 36,
                          color: active
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (!active)
                      StatusChip(
                        label: l10n.comingSoonBadge,
                        icon: AppIcons.pending,
                      )
                    else if (badge != null && badge > 0)
                      StatusChip(
                        label: l10n.hubPendingBadge(toPersianDigits('$badge')),
                        icon: AppIcons.pending,
                        tone: StatusTone.warning,
                      ),
                  ],
                ),
                const SizedBox(height: Space.md),
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: Space.xs),
                Text(
                  module.subtitle(context),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
