import 'package:caspian_owner/features/chat/domain/chat_message.dart';

/// Chat about one request (contract: `/v1/requests/{id}/messages`).
abstract interface class ChatRepository {
  /// One page, oldest first: the newest [limit] messages, or with [before]
  /// (a message id) the [limit] messages just older than it. A page shorter
  /// than [limit] means there is nothing older.
  Future<List<ChatMessage>> messages(
    String requestId, {
    String? before,
    int limit = pageSize,
  });

  /// [clientId] is an idempotency key, so a retried send isn't duplicated.
  Future<ChatMessage> send({
    required String requestId,
    required String text,
    required String clientId,
  });

  static const pageSize = 30;
}
