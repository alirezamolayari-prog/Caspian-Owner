import 'dart:async';

import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/features/chat/application/chat_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The chat about one request, messenger style:
/// - opens at the newest message; older pages load when scrolling up;
/// - the input stays at the bottom, above the keyboard;
/// - «جدیدترین» jumps back down;
/// - Jalali date separators; my messages on the right in one color, the
///   others' on the left with the sender's name (on RTL and LTR alike).
/// Works for every request status.
class ChatScreen extends ConsumerStatefulWidget {
  const new({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _showJump = false;
  DateTime? _markedRead;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      // The list is reversed: offset 0 is the newest message.
      final show = _scroll.hasClients && _scroll.offset > 400;
      if (show != _showJump) setState(() => _showJump = show);
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    unawaited(_jumpToNewest());
    await ref
        .read(chatControllerProvider(widget.requestId).notifier)
        .send(text);
  }

  Future<void> _jumpToNewest() async {
    if (!_scroll.hasClients) return;
    await _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// The newest message seen; the tile on the request screen loses its dot.
  void _markRead(ChatState chat) {
    final newest = chat.entries.lastOrNull?.message.sentAt;
    if (newest == null || newest == _markedRead) return;
    _markedRead = newest;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(markChatRead(ref, widget.requestId, newest));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final chat = ref.watch(chatControllerProvider(widget.requestId));
    final request = ref.watch(requestDetailProvider(widget.requestId)).value;
    final number = request == null
        ? ''
        : toPersianDigits('${request.value.number}');
    final item = request?.value.lines.firstOrNull?.itemNameFa;

    if (chat.value case final value?) _markRead(value);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.chatScreenTitle(number)),
            if (item != null)
              Text(
                item,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showJump
          ? Padding(
              padding: const EdgeInsets.only(bottom: 72),
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: _jumpToNewest,
                icon: const Icon(AppIcons.newest),
                label: Text(l10n.chatJumpToNewest),
              ),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: switch (chat) {
              AsyncValue(:final value?) when value.entries.isEmpty => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Text(
                    l10n.chatEmpty,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              AsyncValue(:final value?) => _MessageList(
                requestId: widget.requestId,
                chat: value,
                controller: _scroll,
              ),
              AsyncValue(:final error?) => ErrorState(
                error: error,
                onRetry: () =>
                    ref.invalidate(chatControllerProvider(widget.requestId)),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
          _InputBar(controller: _input, onSend: _send),
        ],
      ),
    );
  }
}

/// One row of the reversed list: a message, a date separator, or the
/// "loading older" row at the top.
sealed class _Row {
  const new();
}

class _MessageRow extends _Row {
  const new(this.entry);
  final ChatEntry entry;
}

class _DateRow extends _Row {
  const new(this.day);
  final DateTime day;
}

class _OlderRow extends _Row {
  const new();
}

class _MessageList extends ConsumerWidget {
  const new({
    required this.requestId,
    required this.chat,
    required this.controller,
  });

  final String requestId;
  final ChatState chat;
  final ScrollController controller;

  /// Newest first (the list is reversed), with a date row above each day.
  static List<_Row> rows(ChatState chat) {
    DateTime day(DateTime t) {
      final local = t.toLocal();
      return DateTime(local.year, local.month, local.day);
    }

    final entries = chat.entries.reversed.toList();
    return [
      for (var i = 0; i < entries.length; i++) ...[
        _MessageRow(entries[i]),
        if (i == entries.length - 1 ||
            day(entries[i + 1].message.sentAt) !=
                day(entries[i].message.sentAt))
          _DateRow(day(entries[i].message.sentAt)),
      ],
      if (chat.hasOlder) const _OlderRow(),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = rows(chat);
    final notifier = ref.read(chatControllerProvider(requestId).notifier);
    return ListView.builder(
      controller: controller,
      reverse: true,
      padding: const EdgeInsets.symmetric(
        horizontal: Space.page,
        vertical: Space.md,
      ),
      itemCount: list.length,
      itemBuilder: (context, i) => switch (list[i]) {
        _MessageRow(:final entry) => _Bubble(
          entry: entry,
          onRetry: () => notifier.retry(entry.message),
        ),
        _DateRow(:final day) => _DateSeparator(day: day),
        // Built when scrolled to the top: fetch the page before.
        _OlderRow() => _LoadOlder(onShown: notifier.loadOlder),
      },
    );
  }
}

class _LoadOlder extends StatefulWidget {
  const new({required this.onShown});

  final Future<void> Function() onShown;

  @override
  State<_LoadOlder> createState() => _LoadOlderState();
}

class _LoadOlderState extends State<_LoadOlder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onShown());
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Space.md),
    child: Center(
      child: Semantics(
        label: AppLocalizations.of(context).chatLoadingOlder,
        child: const SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    ),
  );
}

class _DateSeparator extends StatelessWidget {
  const new({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.sm),
            child: Text(
              formatJalaliDate(day),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
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
    const corner = Radius.circular(Radii.card);
    const tail = Radius.circular(Space.xs);

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 300),
      margin: const EdgeInsets.only(bottom: Space.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md - Space.xs,
        vertical: Space.sm,
      ),
      decoration: BoxDecoration(
        color: mine ? s.primaryContainer : s.surfaceContainerLowest,
        border: mine ? null : Border.all(color: s.outlineVariant),
        // A small corner on the sender's side, like most messengers.
        borderRadius: BorderRadius.only(
          topLeft: corner,
          topRight: corner,
          bottomLeft: mine ? corner : tail,
          bottomRight: mine ? tail : corner,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mine ? l10n.chatYou : message.author.nameFa,
            style: theme.textTheme.labelMedium?.copyWith(
              color: mine ? s.onPrimaryContainer : s.primary,
            ),
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
                ? l10n.chatSending
                : formatTime(message.sentAt),
            style: theme.textTheme.labelSmall?.copyWith(
              color: entry.failed ? s.error : s.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );

    return Align(
      // Fixed sides, whatever the text direction: mine on the right, the
      // others' on the left (start/end would put mine on the left in RTL).
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: entry.failed ? InkWell(onTap: onRetry, child: bubble) : bubble,
    );
  }
}

/// Always at the bottom; the Scaffold lifts it above the keyboard.
class _InputBar extends StatelessWidget {
  const new({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: s.surface,
        border: Border(top: BorderSide(color: s.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Space.sm),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  decoration: InputDecoration(hintText: l10n.chatInputLabel),
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
                onPressed: onSend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
