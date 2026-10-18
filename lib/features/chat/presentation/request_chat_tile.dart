import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/features/chat/application/chat_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «گفتگو» on the request screen: how many messages, the last one and its
/// time, and a dot while there is something unread. It opens the chat page,
/// so the request screen stays short however long the chat gets.
class RequestChatTile extends ConsumerWidget {
  const new({required this.requestId, this.summary, super.key});

  final String requestId;
  final ChatSummary? summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final last = summary?.last;
    final count = summary?.count ?? 0;
    final lastRead = ref.watch(chatLastReadProvider(requestId)).value;
    final unread =
        last != null &&
        !last.author.isMe &&
        (lastRead == null || last.sentAt.isAfter(lastRead));

    final subtitle = last == null
        ? l10n.chatEmpty
        : l10n.chatLastMessage(
            last.author.isMe ? l10n.chatYou : last.author.nameFa,
            last.text,
            formatRelativeTime(last.sentAt, now: clock.now(), l10n: l10n),
          );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minVerticalPadding: Space.md,
        leading: Badge(
          isLabelVisible: unread,
          smallSize: 10,
          child: Icon(AppIcons.chat, color: theme.colorScheme.primary),
        ),
        title: Text(
          count == 0
              ? l10n.chatTileTitle
              : l10n.chatTileTitleCount(toPersianDigits('$count')),
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          unread ? '${l10n.chatUnread} – $subtitle' : subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(AppIcons.forward),
        onTap: () async {
          await context.push(Routes.requestChat(requestId));
          // New messages from the chat page update the count and preview.
          ref.invalidate(requestDetailProvider(requestId));
        },
      ),
    );
  }
}
