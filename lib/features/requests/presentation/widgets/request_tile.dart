import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_status_chip.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_texts.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

/// One request in a list: initial avatar, title, «sender – time», status.
/// Warehouse-manager decisions say «مدیر انبار»; decisions waiting offline
/// say «در صف ارسال».
class RequestTile extends StatelessWidget {
  const new({
    required this.request,
    required this.onTap,
    this.queued = false,
    super.key,
  });

  final GoodsRequest request;
  final VoidCallback onTap;
  final bool queued;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final sender = request.requester.nameFa;
    final time = formatRelativeTime(
      request.createdAt,
      now: clock.now(),
      l10n: l10n,
    );
    final byManager = request.decidedBy?.kind == DeciderKind.manager;
    final subtitle = l10n.senderAndTime(sender, time);

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.md - Space.xs,
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: Text(sender.characters.first),
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requestTitle(request, l10n),
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: Space.xs),
                    Text(
                      byManager ? '$subtitle – ${l10n.managerLabel}' : subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Space.sm),
              if (queued)
                StatusChip(label: l10n.queuedLabel, icon: AppIcons.queued)
              else
                RequestStatusChip(request.status),
            ],
          ),
        ),
      ),
    );
  }
}
