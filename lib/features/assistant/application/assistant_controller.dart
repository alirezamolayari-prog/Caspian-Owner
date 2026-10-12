import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AssistantState {
  const new({required this.messages, this.thinking = false, this.failed});

  final List<AssistantMessage> messages;

  /// Waiting for the answer to the last question.
  final bool thinking;

  /// The last question could not be answered (shown with a retry).
  final String? failed;
}

final assistantControllerProvider =
    AsyncNotifierProvider<AssistantController, AssistantState>(
      AssistantController.new,
    );

/// «دستیار کاسپین». Mock answers for now; the real assistant will run on
/// the server and answer from the mall's data.
class AssistantController extends AsyncNotifier<AssistantState> {
  @override
  Future<AssistantState> build() async => AssistantState(
    messages: await ref.read(assistantRepositoryProvider).history(),
  );

  Future<void> ask(String text) async {
    final question = text.trim();
    final current = state.value;
    if (question.isEmpty || current == null || current.thinking) return;

    final mine = AssistantMessage(
      id: const Uuid().v4(),
      role: AssistantRole.user,
      text: question,
      at: clock.now(),
    );
    // A retried question replaces its failed copy.
    final messages = [
      for (final m in current.messages)
        if (!(current.failed != null &&
            m.role == AssistantRole.user &&
            m.text == current.failed))
          m,
      mine,
    ];
    state = AsyncData(AssistantState(messages: messages, thinking: true));
    try {
      final answer = await ref.read(assistantRepositoryProvider).ask(question);
      state = AsyncData(AssistantState(messages: [...messages, answer]));
    } on Object {
      state = AsyncData(AssistantState(messages: messages, failed: question));
    }
  }

  /// Earlier questions, newest first, for the history sheet.
  List<AssistantMessage> get previousQuestions => [
    for (final m in (state.value?.messages ?? const <AssistantMessage>[]))
      if (m.role == AssistantRole.user) m,
  ].reversed.toList();
}
