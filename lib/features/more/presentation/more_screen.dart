import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// More (opened from the avatar). Reports, settings, about, etc. come in
/// M10; logout always sits last, separated from the rest.
class MoreScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final error = Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreTitle)),
      body: ListView(
        children: [
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
