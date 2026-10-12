import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:caspian_owner/core/modules/module_providers.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// More (opened from the avatar, UI spec 5.7): module entries, then
/// settings and about; logout sits last, separated.
class MoreScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final error = Theme.of(context).colorScheme.error;
    final auth = ref.watch(authControllerProvider);
    final config = ref.watch(appConfigProvider).value;
    final entries = auth is SignedIn && config != null
        ? ref
              .watch(moduleRegistryProvider)
              .moreEntriesFor(config, auth.session.owner)
        : const <MoreEntry>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreTitle)),
      body: ListView(
        children: [
          for (final entry in entries)
            ListTile(
              leading: Icon(entry.icon),
              title: Text(entry.label(context)),
              trailing: entry.comingSoon
                  ? StatusChip(
                      label: l10n.comingSoonBadge,
                      icon: AppIcons.pending,
                    )
                  : null,
              onTap: () => context.push(entry.path),
            ),
          ListTile(
            leading: const Icon(AppIcons.settings),
            title: Text(l10n.moreSettings),
            onTap: () => context.push(Routes.settings),
          ),
          ListTile(
            leading: const Icon(AppIcons.about),
            title: Text(l10n.moreAbout),
            onTap: () => context.push(Routes.about),
          ),
          const SizedBox(height: Space.lg),
          const Divider(),
          ListTile(
            leading: Icon(AppIcons.logout, color: error),
            title: Text(l10n.logout, style: TextStyle(color: error)),
            onTap: () => _confirmLogout(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
}
