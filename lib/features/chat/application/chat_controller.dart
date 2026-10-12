import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show AsyncNotifierProviderFamily;
import 'package:uuid/uuid.dart';

/// A message in the chat, including ones still being sent by me.
class ChatEntry {
  const new(this.message, {this.sending = false, this.failed = false});

  final ChatMessage message;
  final bool sending;
  final bool failed;
}

final AsyncNotifierProviderFamily<ChatController, List<ChatEntry>, String>
chatControllerProvider = AsyncNotifierProvider.family(ChatController.new);

/// Chat about one request. Sent messages show at once; a failed send stays
/// visible with «تلاش دوباره» and reuses its id, so it is never duplicated.
class ChatController extends AsyncNotifier<List<ChatEntry>> {
  new(this.requestId);

  final String requestId;

  @override
  Future<List<ChatEntry>> build() async {
    final messages = await ref.read(chatRepositoryProvider).messages(requestId);
    return [for (final m in messages) ChatEntry(m)];
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final auth = ref.read(authControllerProvider);
    final draft = ChatMessage(
      id: const Uuid().v4(),
      requestId: requestId,
      author: ChatAuthor(
        kind: ChatAuthorKind.owner,
        nameFa: auth is SignedIn ? auth.session.owner.nameFa : '',
        isMe: true,
      ),
      text: trimmed,
      sentAt: clock.now(),
    );
    await _deliver(draft);
  }

  /// Retries a message whose send failed.
  Future<void> retry(ChatMessage message) => _deliver(message);

  Future<void> _deliver(ChatMessage draft) async {
    _upsert(ChatEntry(draft, sending: true));
    try {
      final sent = await ref
          .read(chatRepositoryProvider)
          .send(requestId: requestId, text: draft.text, clientId: draft.id);
      _replace(draft.id, ChatEntry(sent));
    } on Object {
      _upsert(ChatEntry(draft, failed: true));
    }
  }

  void _upsert(ChatEntry entry) {
    final current = state.value ?? const <ChatEntry>[];
    final index = current.indexWhere((e) => e.message.id == entry.message.id);
    final updated = [...current];
    if (index < 0) {
      updated.add(entry);
    } else {
      updated[index] = entry;
    }
    state = AsyncData(updated);
  }

  void _replace(String draftId, ChatEntry entry) {
    final current = state.value ?? const <ChatEntry>[];
    state = AsyncData([
      for (final e in current)
        if (e.message.id == draftId) entry else e,
    ]);
  }
}
