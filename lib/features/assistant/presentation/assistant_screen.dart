import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/features/assistant/application/assistant_controller.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Assistant tab (UI spec 5.6).
class AssistantScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _ask(String text) async {
    _input.clear();
    final done = ref.read(assistantControllerProvider.notifier).ask(text);
    _scrollToEnd();
    await done;
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _showHistory() async {
    final l10n = AppLocalizations.of(context);
    final questions = ref
        .read(assistantControllerProvider.notifier)
        .previousQuestions;
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: Space.md),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.lg,
                0,
                Space.lg,
                Space.sm,
              ),
              child: Text(
                l10n.assistantHistory,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (questions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Text(l10n.assistantHistoryEmpty),
              )
            else
              for (final q in questions)
                ListTile(
                  title: Text(q.text),
                  subtitle: Text(formatJalaliDateTime(q.at)),
                  onTap: () => Navigator.pop(context, q.text),
                ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) await _ask(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final assistant = ref.watch(assistantControllerProvider);
    final thinking = assistant.value?.thinking ?? false;
    final suggestions = [
      l10n.assistantSuggestionToday,
      l10n.assistantSuggestionMonth,
      l10n.assistantSuggestionCount,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assistantTitle),
        actions: [
          IconButton(
            tooltip: l10n.assistantHistory,
            icon: const Icon(AppIcons.history),
            onPressed: _showHistory,
          ),
          const SizedBox(width: Space.sm),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: switch (assistant) {
              AsyncValue(:final value?) => ListView(
                controller: _scroll,
                padding: const EdgeInsets.all(Space.page),
                children: [
                  Text(
                    l10n.assistantDemoNote,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: Space.md),
                  if (value.messages.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(Space.lg),
                      child: Text(
                        l10n.assistantEmpty,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  for (final m in value.messages) _Message(message: m),
                  if (value.thinking)
                    _Bubble(
                      fromAssistant: true,
                      child: Semantics(
                        liveRegion: true,
                        child: Text(l10n.assistantThinking),
                      ),
                    ),
                  if (value.failed case final failed?)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () => _ask(failed),
                        icon: const Icon(AppIcons.retry),
                        label: Text(l10n.assistantFailed),
                      ),
                    ),
                ],
              ),
              AsyncValue(:final error?) => ErrorState(
                error: error,
                onRetry: () => ref.invalidate(assistantControllerProvider),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.page,
                Space.sm,
                Space.page,
                Space.sm,
              ),
              child: Column(
                children: [
                  // Wrap, not a sideways scroller: all three suggestions
                  // stay visible on narrow phones.
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: Space.sm,
                      runSpacing: Space.xs,
                      children: [
                        for (final s in suggestions)
                          ActionChip(
                            label: Text(s),
                            onPressed: thinking ? null : () => _ask(s),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _input,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: thinking ? null : _ask,
                          decoration: InputDecoration(
                            labelText: l10n.assistantInputLabel,
                          ),
                        ),
                      ),
                      const SizedBox(width: Space.sm),
                      IconButton.filled(
                        tooltip: l10n.chatSend,
                        constraints: const BoxConstraints.tightFor(
                          width: 56,
                          height: 56,
                        ),
                        icon: const Icon(AppIcons.send),
                        onPressed: thinking ? null : () => _ask(_input.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const new({required this.message});

  final AssistantMessage message;

  @override
  Widget build(BuildContext context) {
    final fromAssistant = message.role == AssistantRole.assistant;
    final s = Theme.of(context).colorScheme;
    return _Bubble(
      fromAssistant: fromAssistant,
      child: Text(
        message.text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: fromAssistant ? s.onSurface : s.onPrimaryContainer,
        ),
      ),
    );
  }
}

/// The assistant's messages carry a small sparkle avatar.
class _Bubble extends StatelessWidget {
  const new({required this.fromAssistant, required this.child});

  final bool fromAssistant;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final bubble = Flexible(
      child: Container(
        margin: const EdgeInsets.only(bottom: Space.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md - Space.xs,
          vertical: Space.sm + Space.xs,
        ),
        decoration: BoxDecoration(
          color: fromAssistant ? s.surfaceContainer : s.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(Radii.card)),
        ),
        child: child,
      ),
    );
    return Row(
      mainAxisAlignment: fromAssistant
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fromAssistant) ...[
          ExcludeSemantics(
            child: CircleAvatar(
              radius: 16,
              backgroundColor: s.primaryContainer,
              child: Icon(
                AppIcons.assistant,
                size: 18,
                color: s.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: Space.sm),
        ],
        bubble,
        if (!fromAssistant) const SizedBox(width: Space.xl),
      ],
    );
  }
}
