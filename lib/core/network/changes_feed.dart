import 'package:caspian_owner/core/network/api_client.dart';

/// One answer of `GET /changes`: requests changed and messages written
/// after `since`, as raw server JSON.
class ServerChanges {
  const new({
    required this.requests,
    required this.messages,
    required this.nextSince,
  });

  final List<Map<String, Object?>> requests;
  final List<Map<String, Object?>> messages;

  /// Send this as `since` next time (UTC). It overlaps the previous answer
  /// by 2 seconds on purpose, so a row may come twice: always update by id.
  final DateTime nextSince;

  bool get isEmpty => requests.isEmpty && messages.isEmpty;
}

/// «What changed since …?» on Caspian Server. Used by the open app every
/// few seconds (`LiveSyncController`) and by the background notification
/// check.
class ChangesFeed {
  const new(this._client);

  final ApiClient _client;

  /// The server's clock (`GET /health`), the safe first `since`: the
  /// phone's clock may be wrong.
  Future<DateTime> serverNow() async {
    final json = ApiClient.asMap(await _client.get('/health'));
    return DateTime.parse(json['server_time']! as String).toUtc();
  }

  Future<ServerChanges> since(DateTime since) async {
    final json = ApiClient.asMap(
      await _client.get(
        '/changes',
        // UTC with a «Z»: no «+» that would need URL escaping.
        query: {'since': since.toUtc().toIso8601String()},
      ),
    );
    return ServerChanges(
      requests: [
        for (final r in ApiClient.asList(json['requests'])) ApiClient.asMap(r),
      ],
      messages: [
        for (final m in ApiClient.asList(json['messages'])) ApiClient.asMap(m),
      ],
      nextSince: DateTime.parse(json['next_since']! as String).toUtc(),
    );
  }
}
