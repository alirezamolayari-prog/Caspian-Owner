import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/chat/domain/chat_repository.dart';
import 'package:clock/clock.dart';

class MockChatRepository implements ChatRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<List<ChatMessage>> messages(
    String requestId, {
    String? before,
    int limit = ChatRepository.pageSize,
  }) => _backend.call(() {
    final all = _backend.chatFor(requestId);
    final end = before == null
        ? all.length
        : all.indexWhere((m) => m.id == before).clamp(0, all.length);
    final start = (end - limit).clamp(0, end);
    return all.sublist(start, end);
  });

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
