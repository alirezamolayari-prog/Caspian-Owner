import 'package:caspian_owner/core/network/changes_feed.dart';
import 'package:caspian_owner/core/network/not_connected.dart';
import 'package:caspian_owner/core/network/server_mappers.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// Background notifications from Caspian Server's `/changes`:
/// - a new or resubmitted pending request → «منتظر تأیید شماست»;
/// - a request decided by someone else → «تأیید/رد شد توسط …»;
/// - a chat message from someone else.
///
/// The server sends data, not notification texts, so the texts are made
/// here (same wording as the mock).
class ApiNotificationSource implements NotificationSource {
  const new(this._feed, {required this.myId});

  final ChangesFeed _feed;
  final String? Function() myId;

  @override
  Future<NotificationBatch> poll({required DateTime since}) async {
    final changes = await _feed.since(since);
    return NotificationBatch(
      events: eventsFrom(changes, since: since, me: myId()),
      serverTime: changes.nextSince,
    );
  }

  /// The notifications in one `/changes` answer asked with [since], for
  /// the owner [me], oldest first. Also used by the open app
  /// (`LiveSyncController`) on the answers it already has.
  static List<NotificationEvent> eventsFrom(
    ServerChanges changes, {
    required DateTime since,
    required String? me,
  }) => <NotificationEvent>[
    for (final json in changes.requests) ?_requestEvent(json, since),
    for (final json in changes.messages)
      if ('${json['sender_id']}' != me) _messageEvent(json),
  ]..sort((a, b) => a.at.compareTo(b.at));

  /// The bell's list needs `/notifications`, which the server doesn't have
  /// yet (the screen shows «به‌زودی»).
  @override
  Future<List<NotificationEvent>> recent({int limit = 50}) =>
      Future.error(notConnected);

  static NotificationEvent? _requestEvent(
    Map<String, Object?> json,
    DateTime since,
  ) {
    final request = ServerMappers.request(json);
    final number = request.number;
    final updatedAt = ServerMappers.time(json['updated_at'])!;
    final id = 'n-r${request.id}-${updatedAt.toUtc().toIso8601String()}';
    final target = '/requests/${request.id}';
    final body =
        '${request.lines.first.itemNameFa} – ${request.requester.nameFa}';

    if (request.canDecide) {
      final isNew = request.createdAt.isAfter(since);
      return NotificationEvent(
        id: id,
        kind: NotificationEventKind.requestEscalated,
        at: updatedAt,
        titleFa: toPersianDigits(
          isNew
              ? 'درخواست $number منتظر تأیید شماست'
              : 'درخواست $number اصلاح شد و دوباره منتظر تأیید شماست',
        ),
        bodyFa: body,
        target: target,
      );
    }
    // Only another owner's approve / reject; never my own decision, and not
    // the warehouse issuing the goods. The server never names that owner.
    final decidedByAnotherOwner =
        (request.status == RequestStatus.approved ||
            request.status == RequestStatus.rejected) &&
        json['decided_by_me'] == false;
    if (!decidedByAnotherOwner) return null;
    const name = 'یکی از مالکان';
    return NotificationEvent(
      id: id,
      kind: NotificationEventKind.requestDecided,
      at: updatedAt,
      titleFa: toPersianDigits(
        request.status == RequestStatus.approved
            ? 'درخواست $number تأیید شد توسط $name'
            : 'درخواست $number رد شد توسط $name',
      ),
      bodyFa: body,
      target: target,
    );
  }

  static NotificationEvent _messageEvent(Map<String, Object?> json) {
    final message = ServerMappers.message(json);
    return NotificationEvent(
      id: 'n-m${message.id}',
      kind: NotificationEventKind.chatMessage,
      at: message.sentAt,
      titleFa: 'پیام از ${message.author.nameFa}',
      bodyFa: message.text,
      target: '/requests/${message.requestId}',
    );
  }
}
