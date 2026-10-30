import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The bell in the hub and module app bars. A dot means a new app version
/// is waiting (its row leads «اعلان‌ها»); the tooltip says so in words.
class NotificationsBell extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasUpdate = ref.watch(availableUpdateProvider) != null;
    return IconButton(
      tooltip: hasUpdate
          ? l10n.notificationsTooltipUpdate
          : l10n.notificationsTooltip,
      icon: Badge(
        isLabelVisible: hasUpdate,
        child: const Icon(AppIcons.notifications),
      ),
      onPressed: () => context.push(Routes.notifications),
    );
  }
}
