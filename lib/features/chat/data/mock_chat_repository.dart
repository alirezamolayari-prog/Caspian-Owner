import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/chat/domain/chat_repository.dart';
import 'package:clock/clock.dart';

class MockChatRepository implements ChatRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<List<ChatMessage>> messages(String requestId) => _backend.call(
    () => [
      for (final m in _backend.chats)
        if (m.requestId == requestId) m,
    ]..sort((a, b) => a.sentAt.compareTo(b.sentAt)),
  );

  @override
  Future<ChatMessage> send({
    required String requestId,
    required String text,
    required String clientId,
  }) => _backend.call(
    () => _backend.idempotent(clientId, () {
      final message = ChatMessage(
        id: _backend.nextId('m'),
        requestId: requestId,
        author: ChatAuthor(
          kind: ChatAuthorKind.owner,
          nameFa: _backend.me.nameFa,
          isMe: true,
        ),
        text: text,
        sentAt: clock.now(),
      );
      _backend.chats.add(message);
      return message;
    }),
  );
}
