import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// Turns Caspian Server JSON (v1, see the server's `/docs`) into the app's
/// models. The server is simpler than `api/openapi.yaml`, so some fields
/// get fixed values here:
///
/// - `id` is both the request id (as text) and its number;
/// - the place is free text (`consumption_location`), with no floor code;
/// - every request is «escalated» (owners decide all of them);
/// - stock, 30-day use and same-place history aren't sent (hidden in the
///   UI, see `serverCapabilitiesProvider`).
///
/// Times arrive in UTC and are shown in the phone's time zone.
abstract final class ServerMappers {
  static GoodsRequest request(Map<String, Object?> json) {
    final decidedById = json['decided_by_id'] as int?;
    return GoodsRequest(
      id: '${json['id']}',
      number: json['id']! as int,
      createdAt: time(json['created_at'])!,
      requester: Person(
        code: 'u${json['created_by_id']}',
        nameFa: json['requester_name']! as String,
      ),
      place: ConsumptionPlace(
        locationCode: json['consumption_location']! as String,
        floorCode: '',
      ),
      lines: [
        for (final item in json['items']! as List<Object?>)
          _line(item! as Map<String, Object?>),
      ],
      status: switch (json['status']) {
        'approved' => RequestStatus.approved,
        'rejected' => RequestStatus.rejected,
        _ => RequestStatus.pending,
      },
      escalated: true,
      note: _nonEmpty(json['note'] as String?),
      decidedBy: decidedById == null
          ? null
          : DecidedBy(
              kind: DeciderKind.owner,
              nameFa: json['decided_by_name'] as String? ?? '',
            ),
      decidedAt: time(json['decided_at']),
      decisionReason: json['rejection_reason'] as String?,
    );
  }

  /// [myId] is the logged-in user's id, so their own messages show as mine.
  static ChatMessage message(Map<String, Object?> json, {String? myId}) =>
      ChatMessage(
        id: '${json['id']}',
        requestId: '${json['request_id']}',
        author: ChatAuthor(
          kind: json['sender_role'] == 'warehouse'
              ? ChatAuthorKind.staff
              : ChatAuthorKind.owner,
          nameFa: json['sender_name']! as String,
          isMe: myId != null && '${json['sender_id']}' == myId,
        ),
        text: json['text']! as String,
        sentAt: time(json['created_at'])!,
      );

  /// An ISO time from the server (UTC), in the phone's time zone.
  static DateTime? time(Object? value) =>
      value is String ? DateTime.parse(value).toLocal() : null;

  static RequestLine _line(Map<String, Object?> json) => RequestLine(
    itemCode: '${json['id']}',
    itemNameFa: json['name']! as String,
    qty: (json['quantity']! as num).toDouble(),
    unitFa: json['unit']! as String,
    stockNow: null,
    usedLast30d: 0,
  );

  static String? _nonEmpty(String? text) =>
      text == null || text.trim().isEmpty ? null : text;
}
