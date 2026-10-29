import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/card_segment.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/more/domain/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «کاربران و دسترسی‌ها» (admin only), read-only: accounts waiting for
/// approval first, then everyone. Approving, roles and deactivating are done
/// in the server's admin panel.
class UsersScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final users = ref.watch(usersListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreUsers)),
      body: switch (users) {
        AsyncValue(:final value?) => RefreshIndicator(
          onRefresh: () => ref.refresh(usersListProvider.future),
          child: _UsersList(users: value),
        ),
        AsyncValue(:final error?) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(usersListProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _UsersList extends ConsumerWidget {
  const new({required this.users});

  final List<AppUser> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final meId = auth is SignedIn ? auth.session.owner.id : '';
    final waiting = [
      for (final u in users)
        if (u.approval == UserApproval.pending) u,
    ];

    Widget section(String title, List<AppUser> list) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: Text(title, style: theme.textTheme.titleSmall),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (i, user) in list.indexed)
                ZebraRow(
                  index: i,
                  last: i == list.length - 1,
                  child: _UserTile(user: user, isMe: user.id == meId),
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.lg),
      ],
    );

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        Space.page,
        Space.page,
        Space.page,
        Space.page + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(l10n.usersNote, style: theme.textTheme.bodyMedium),
        const SizedBox(height: Space.md),
        if (waiting.isNotEmpty) section(l10n.usersPendingSection, waiting),
        section(l10n.usersAllSection, users),
      ],
    );
  }
}

class _UserTile extends StatelessWidget {
  const new({required this.user, required this.isMe});

  final AppUser user;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = switch (user.role) {
      UserRole.owner => l10n.usersOwner,
      UserRole.warehouse => l10n.roleWarehouse,
      UserRole.admin => l10n.roleAdmin,
      UserRole.unassigned => l10n.roleUnassigned,
    };
    // Status always in words, never colour alone.
    final (String status, IconData icon, StatusTone tone) = switch (user) {
      AppUser(approval: UserApproval.pending) => (
        l10n.usersApprovalPending,
        AppIcons.pending,
        StatusTone.warning,
      ),
      AppUser(approval: UserApproval.rejected) => (
        l10n.usersApprovalRejected,
        AppIcons.rejected,
        StatusTone.error,
      ),
      AppUser(active: false) => (
        l10n.usersInactive,
        AppIcons.cancelled,
        StatusTone.neutral,
      ),
      _ => (l10n.usersActive, AppIcons.approved, StatusTone.success),
    };
    final initial = user.nameFa.characters.firstOrNull ?? '؟';
    return ListTile(
      leading: ExcludeSemantics(child: CircleAvatar(child: Text(initial))),
      title: Text(isMe ? '${user.nameFa} (${l10n.usersYou})' : user.nameFa),
      subtitle: Text(role),
      trailing: StatusChip(label: status, icon: icon, tone: tone),
    );
  }
}
