import 'package:caspian_owner/core/network/changes_feed.dart';
import 'package:caspian_owner/core/notifications/api_notification_source.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  test('new, resubmitted and decided requests and messages become '
      'notifications; my own actions do not', () async {
    final since = DateTime.utc(2026, 10, 21, 8, 30);
    final server = FakeServer()
      ..on(
        'GET',
        '/changes',
        FakeServer.json({
          'server_time': '2026-10-21T09:10:00Z',
          'next_since': '2026-10-21T09:09:58Z',
          'requests': [
            // New pending request.
            serverRequest(id: 7, createdAt: '2026-10-21T09:00:00Z'),
            // Old request, edited and resubmitted by the warehouse.
            serverRequest(
              id: 6,
              createdAt: '2026-10-20T10:00:00Z',
              updatedAt: '2026-10-21T09:01:00Z',
            ),
            // Decided by another owner.
            serverRequest(
              status: 'approved',
              decidedByMe: false,
              updatedAt: '2026-10-21T09:02:00Z',
            ),
            // Decided by me: no notification.
            serverRequest(id: 8, status: 'rejected', decidedByMe: true),
            // Issued by the warehouse: not an owner's decision.
            serverRequest(id: 9, status: 'issued', decidedByMe: false),
          ],
          'messages': [
            serverMessage(text: 'سؤال دارم', createdAt: '2026-10-21T09:03:00Z'),
            serverMessage(id: 2, senderId: 3, senderRole: 'owner'),
          ],
        }),
      );
    final source = ApiNotificationSource(
      ChangesFeed(server.client(token: 't')),
      myId: () => '3',
    );

    final batch = await source.poll(since: since);

    expect(batch.serverTime, DateTime.utc(2026, 10, 21, 9, 9, 58));
    expect(batch.events.map((e) => e.titleFa), [
      'درخواست ۷ منتظر تأیید شماست',
      'درخواست ۶ اصلاح شد و دوباره منتظر تأیید شماست',
      'درخواست ۵ تأیید شد توسط یکی از مالکان',
      'پیام از انبار پاساژ',
    ]);
    expect(batch.events.last.kind, NotificationEventKind.chatMessage);
    expect(batch.events.first.target, '/requests/7');
  });
}
