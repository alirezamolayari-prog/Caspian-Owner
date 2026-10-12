import 'package:caspian_owner/features/chat/domain/chat_message.dart';

/// Chat about one request (contract: `/v1/requests/{id}/messages`).
abstract interface class ChatRepository {
  /// Oldest first.
  Future<List<ChatMessage>> messages(String requestId);

  /// [clientId] is an idempotency key, so a retried send isn't duplicated.
  Future<ChatMessage> send({
    required String requestId,
    required String text,
    required String clientId,
  });
}
