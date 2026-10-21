import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/network/server_mappers.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/chat/domain/chat_repository.dart';

/// Chat on Caspian Server: `GET` / `POST /requests/{id}/messages`.
class ApiChatRepository implements ChatRepository {
  const new(this._client, {required this.myId});

  final ApiClient _client;
  final String? Function() myId;

  /// The server sends the whole chat (oldest first); pages are cut here,
  /// the same way the mock does.
  @override
  Future<List<ChatMessage>> messages(
    String requestId, {
    String? before,
    int limit = ChatRepository.pageSize,
  }) async {
    final json = ApiClient.asList(await _client.get(_path(requestId)));
    final all = [
      for (final m in json)
        ServerMappers.message(ApiClient.asMap(m), myId: myId()),
    ];
    final end = before == null
        ? all.length
        : all.indexWhere((m) => m.id == before).clamp(0, all.length);
    final start = (end - limit).clamp(0, end);
    return all.sublist(start, end);
  }

  /// [clientId] isn't used: the server has no idempotency keys yet.
  @override
  Future<ChatMessage> send({
    required String requestId,
    required String text,
    required String clientId,
  }) async {
    final json = await _client.post(_path(requestId), json: {'text': text});
    return ServerMappers.message(ApiClient.asMap(json), myId: myId());
  }

  static String _path(String requestId) {
    if (int.tryParse(requestId) == null) throw const NotFoundException();
    return '/requests/$requestId/messages';
  }
}
