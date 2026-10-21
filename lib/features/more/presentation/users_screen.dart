import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/card_segment.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «کاربران و دسترسی‌ها» (admin only). Read-only until the server exists.
class UsersScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final meId = auth is SignedIn ? auth.session.owner.id : '';
    // No users API on the server yet: only the logged-in owner is known.
    final owners = switch ((ref.watch(dataSourceProvider), auth)) {
      (DataSource.mock, _) => ref.watch(mockBackendProvider).owners,
      (DataSource.api, SignedIn(:final session)) => [session.owner],
      _ => const <Owner>[],
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreUsers)),
      body: ListView(
        padding: const EdgeInsets.all(Space.page),
        children: [
          Text(l10n.usersNote, style: theme.textTheme.bodyMedium),
          const SizedBox(height: Space.md),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, owner) in owners.indexed)
                  ZebraRow(
                    index: i,
                    last: i == owners.length - 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(owner.nameFa.characters.first),
                      ),
                      title: Text(
                        owner.id == meId
                            ? '${owner.nameFa} (${l10n.usersYou})'
                            : owner.nameFa,
                      ),
                      trailing: owner.isAdmin
                          ? StatusChip(
                              label: l10n.usersAdmin,
                              icon: AppIcons.admin,
                              tone: StatusTone.success,
                            )
                          : StatusChip(
                              label: l10n.usersOwner,
                              icon: AppIcons.account,
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
