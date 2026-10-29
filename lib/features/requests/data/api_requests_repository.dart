import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/network/server_mappers.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/domain/requests_repository.dart';

/// Goods requests on Caspian Server:
/// `GET /requests`, `GET /requests/{id}`, `POST /requests/{id}/approve`,
/// `POST /requests/{id}/reject`.
class ApiRequestsRepository implements RequestsRepository {
  /// [myId] returns the logged-in user's id (to recognise our own decision
  /// after a retry, see [decide]).
  const new(this._client, {required this.myId});

  final ApiClient _client;
  final String? Function() myId;

  @override
  Future<List<GoodsRequest>> list({
    RequestStatus? status,
    bool escalatedOnly = false,
  }) async {
    // The server knows pending / approved / rejected / issued; every
    // request counts as escalated, so [escalatedOnly] changes nothing.
    if (status != null && !_serverStatuses.contains(status)) return const [];
    final json = ApiClient.asList(
      await _client.get('/requests', query: {'status': ?status?.name}),
    );
    return [for (final r in json) ServerMappers.request(ApiClient.asMap(r))];
  }

  @override
  Future<GoodsRequest> get(String id) async {
    final path = _path(id);
    final request = ServerMappers.request(
      ApiClient.asMap(await _client.get(path)),
    );
    // The «گفتگو» tile needs the message count and the newest message.
    final messages = ApiClient.asList(await _client.get('$path/messages'));
    return request.copyWith(
      chatSummary: ChatSummary(
        count: messages.length,
        last: messages.isEmpty
            ? null
            : ServerMappers.message(
                ApiClient.asMap(messages.last),
                myId: myId(),
              ),
      ),
    );
  }

  /// Approve or reject. The server has no idempotency keys, so a decision
  /// retried after a lost answer comes back as `409`; if the request was
  /// decided by *us* the way we asked, that counts as success.
  @override
  Future<GoodsRequest> decide(Decision decision) async {
    final path = _path(decision.requestId);
    try {
      final json = switch (decision.action) {
        DecisionAction.approve => await _client.post('$path/approve'),
        DecisionAction.reject => await _client.post(
          '$path/reject',
          json: {'reason': decision.reason ?? ''},
        ),
        // Hidden in the UI: Caspian Server v1 has no «برگشت برای اصلاح».
        DecisionAction.returnForEdit => throw const ServerException(
          code: 'not_supported',
        ),
      };
      return ServerMappers.request(ApiClient.asMap(json));
    } on ConflictException {
      final current = ApiClient.asMap(await _client.get(path));
      final mapped = ServerMappers.request(current);
      final wanted = decision.action == DecisionAction.approve
          ? const {RequestStatus.approved, RequestStatus.issued}
          : const {RequestStatus.rejected};
      // The server never says who decided, only whether it was us.
      final mine = current['decided_by_me'] == true;
      if (mine && wanted.contains(mapped.status)) return mapped;
      throw AlreadyDecidedException(mapped);
    }
  }

  static const Set<RequestStatus> _serverStatuses = {
    RequestStatus.pending,
    RequestStatus.approved,
    RequestStatus.rejected,
    RequestStatus.issued,
  };

  /// Request ids are numbers on the server; anything else can't exist.
  static String _path(String id) {
    if (int.tryParse(id) == null) throw const NotFoundException();
    return '/requests/$id';
  }
}
