import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/features/chat/application/chat_controller.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «گفتگو درباره این درخواست»: chat with the person who sent the request.
class RequestChatCard extends ConsumerStatefulWidget {
  const new({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<RequestChatCard> createState() => _RequestChatCardState();
}

class _RequestChatCardState extends ConsumerState<RequestChatCard> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    await ref
        .read(chatControllerProvider(widget.requestId).notifier)
        .send(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final chat = ref.watch(chatControllerProvider(widget.requestId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.chatTitle, style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: Space.md),
            switch (chat) {
              AsyncValue(:final value?) when value.isEmpty => Text(
                l10n.chatEmpty,
                style: theme.textTheme.bodySmall,
              ),
              AsyncValue(:final value?) => Column(
                children: [
                  for (final entry in value)
                    _Bubble(
                      entry: entry,
                      onRetry: () => ref
                          .read(
                            chatControllerProvider(widget.requestId).notifier,
                          )
                          .retry(entry.message),
                    ),
                ],
              ),
              AsyncValue(hasError: true) => Text(
                l10n.errorGeneric,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              _ => const Padding(
                padding: EdgeInsets.all(Space.md),
                child: Center(child: CircularProgressIndicator()),
              ),
            },
            const SizedBox(height: Space.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(labelText: l10n.chatInputLabel),
                  ),
                ),
                const SizedBox(width: Space.sm),
                IconButton.filled(
                  tooltip: l10n.chatSend,
                  iconSize: 24,
                  constraints: const BoxConstraints.tightFor(
                    width: 56,
                    height: 56,
                  ),
                  icon: const Icon(AppIcons.send),
                  onPressed: _send,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const new({required this.entry, required this.onRetry});

  final ChatEntry entry;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final message = entry.message;
    final mine = message.author.isMe;
    final time = formatRelativeTime(
      message.sentAt,
      now: clock.now(),
      l10n: l10n,
    );

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 300),
      margin: const EdgeInsets.only(bottom: Space.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md - Space.xs,
        vertical: Space.sm,
      ),
      decoration: BoxDecoration(
        color: mine ? s.primaryContainer : s.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(Radii.card)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine)
            Text(
              message.author.nameFa,
              style: theme.textTheme.labelMedium?.copyWith(color: s.primary),
            ),
          Text(
            message.text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: mine ? s.onPrimaryContainer : s.onSurface,
            ),
          ),
          const SizedBox(height: Space.xs),
          Text(
            entry.failed
                ? l10n.chatSendFailed
                : entry.sending
                ? '…'
                : time,
            style: theme.textTheme.labelSmall?.copyWith(
              color: entry.failed ? s.error : s.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );

    return Align(
      alignment: mine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: entry.failed ? InkWell(onTap: onRetry, child: bubble) : bubble,
    );
  }
}
