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
  /// Reports what the server sent that this app version doesn't know (an
  /// unknown request status). Set by bootstrap to write the app log.
  static void Function(String message)? warn;

  static GoodsRequest request(Map<String, Object?> json) {
    final status = _status(json['status'], json['id']);
    final decidedAt = time(json['decided_at']);
    final decided =
        status == RequestStatus.approved ||
        status == RequestStatus.issued ||
        status == RequestStatus.rejected;
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
      status: status,
      escalated: true,
      note: _nonEmpty(json['note'] as String?),
      // Privacy: the server never says which owner decided, only whether
      // it was the viewer.
      decidedBy: decided && decidedAt != null
          ? DecidedBy(
              kind: json['decided_by_me'] == true
                  ? DeciderKind.me
                  : DeciderKind.anotherOwner,
              nameFa: '',
            )
          : null,
      decidedAt: decidedAt,
      decisionReason: _nonEmpty(json['rejection_reason'] as String?),
      issueNumber: _nonEmpty(json['issue_number'] as String?),
      issuedAt: time(json['issued_at']),
    );
  }

  /// Never a silent default: an unknown status is [RequestStatus.unknown]
  /// (not decidable, not counted) and is logged.
  static RequestStatus _status(Object? value, Object? id) {
    switch (value) {
      case 'pending':
        return RequestStatus.pending;
      case 'approved':
        return RequestStatus.approved;
      case 'rejected':
        return RequestStatus.rejected;
      case 'issued':
        return RequestStatus.issued;
    }
    warn?.call('Request $id: unknown status "$value"');
    return RequestStatus.unknown;
  }

  /// [myId] is the logged-in user's id. Warehouse messages keep the
  /// server's name (e.g. «انبار کاسپین»); owners are never named: «شما» for
  /// my own messages, «مالک» for other owners'.
  static ChatMessage message(Map<String, Object?> json, {String? myId}) {
    final staff = json['sender_role'] == 'warehouse';
    final isMe =
        myId != null &&
        json['sender_id'] != null &&
        '${json['sender_id']}' == myId;
    return ChatMessage(
      id: '${json['id']}',
      requestId: '${json['request_id']}',
      author: ChatAuthor(
        kind: staff ? ChatAuthorKind.staff : ChatAuthorKind.owner,
        nameFa: switch ((staff, isMe)) {
          (true, _) => json['sender_name']! as String,
          (false, true) => 'شما',
          (false, false) => 'مالک',
        },
        isMe: isMe,
      ),
      text: json['text']! as String,
      sentAt: time(json['created_at'])!,
    );
  }

  /// An ISO time from the server (UTC), in the phone's time zone.
  static DateTime? time(Object? value) =>
      value is String ? DateTime.parse(value).toLocal() : null;

  /// [RequestLine.itemCode] is the warehouse's item code (`item_code`), not
  /// the row id; empty when the server has none (the UI hides it then).
  static RequestLine _line(Map<String, Object?> json) => RequestLine(
    itemCode: (json['item_code'] as String?)?.trim() ?? '',
    itemNameFa: json['name']! as String,
    qty: (json['quantity']! as num).toDouble(),
    unitFa: json['unit']! as String,
    stockNow: null,
    usedLast30d: 0,
  );

  static String? _nonEmpty(String? text) =>
      text == null || text.trim().isEmpty ? null : text;
}
