import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:clock/clock.dart';

/// Derives what `/v1/notifications/poll` would return from the mock data.
/// Texts are server-provided (`*_fa`), as the real server will send them.
class MockNotificationSource implements NotificationSource {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<NotificationBatch> poll({required DateTime since}) =>
      _backend.call(() {
        final events = <NotificationEvent>[
          for (final r in _backend.requests)
            if (r.canDecide && r.createdAt.isAfter(since))
              NotificationEvent(
                id: 'n-${r.id}',
                kind: NotificationEventKind.requestEscalated,
                at: r.createdAt,
                titleFa: toPersianDigits(
                  'درخواست ${r.number} '
                  'منتظر تأیید شماست',
                ),
                bodyFa: '${r.lines.first.itemNameFa} – ${r.requester.nameFa}',
                target: '/requests/${r.id}',
              ),
          for (final c in _backend.counts)
            if (c.status == CountStatus.done &&
                (c.finishedAt?.isAfter(since) ?? false))
              NotificationEvent(
                id: 'n-${c.id}',
                kind: NotificationEventKind.countResult,
                at: c.finishedAt!,
                titleFa: 'نتیجه شمارش غافلگیرانه آماده است',
                bodyFa: c.items.map((i) => i.itemNameFa).join('، '),
                target: '/counts/${c.id}',
              ),
          for (final m in _backend.chats)
            if (!m.author.isMe && m.sentAt.isAfter(since))
              NotificationEvent(
                id: 'n-${m.id}',
                kind: NotificationEventKind.chatMessage,
                at: m.sentAt,
                titleFa: 'پیام از ${m.author.nameFa}',
                bodyFa: m.text,
                target: '/requests/${m.requestId}',
              ),
        ]..sort((a, b) => a.at.compareTo(b.at));
        return NotificationBatch(events: events, serverTime: clock.now());
      });

  @override
  Future<List<NotificationEvent>> recent({int limit = 50}) async {
    final batch = await poll(
      since: clock.now().subtract(const Duration(days: 30)),
    );
    return batch.events.reversed.take(limit).toList();
  }
}
