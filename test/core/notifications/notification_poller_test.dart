import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/notifications/notification_poller.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';

class _Recorder implements LocalNotifier {
  final shown = <NotificationEvent>[];

  @override
  Future<void> show(NotificationEvent event) async => shown.add(event);
}

/// A server that always answers with [events].
class _Fixed implements NotificationSource {
  new(this.events);

  final List<NotificationEvent> events;

  @override
  Future<NotificationBatch> poll({required DateTime since}) async =>
      NotificationBatch(events: events, serverTime: testNow);

  @override
  Future<List<NotificationEvent>> recent({int limit = 50}) async => events;
}

void main() {
  late MockBackend backend;
  late MemorySecureStore store;
  late _Recorder notifier;

  setUp(() async {
    backend = await testBackend();
    store = MemorySecureStore();
    notifier = _Recorder();
  });

  NotificationPoller poller() => NotificationPoller(
    source: MockNotificationSource(backend),
    store: store,
    notifier: notifier,
  );

  test('first run shows what happened in the last hour', () async {
    final count = await withClock(Clock.fixed(testNow), poller().run);
    final kinds = notifier.shown.map((e) => e.kind).toSet();
    expect(count, notifier.shown.length);
    expect(kinds, contains(NotificationEventKind.requestEscalated));
    expect(kinds, contains(NotificationEventKind.chatMessage));
    // Newest escalated request links to its detail screen.
    expect(
      notifier.shown.firstWhere((e) => e.id == 'n-r-125').target,
      '/requests/r-125',
    );
  });

  test('the same event is never shown twice', () async {
    await withClock(Clock.fixed(testNow), poller().run);
    final first = notifier.shown.length;
    // Even if the next poll looks back over the same period.
    await store.delete(NotificationPoller.sinceKey);
    final second = await withClock(Clock.fixed(testNow), poller().run);
    expect(second, 0);
    expect(notifier.shown.length, first);
  });

  test(
    'count results (removed in v0.2.0) are parsed but never shown',
    () async {
      final countResult = NotificationEvent.fromJson({
        'id': 'n-c-7',
        'kind': 'count_result',
        'at': testNow.toIso8601String(),
        'title_fa': 'نتیجه شمارش',
        'body_fa': '-',
        'target': '/counts/c-7',
      });
      final shown = await NotificationPoller(
        source: _Fixed([countResult]),
        store: store,
        notifier: notifier,
      ).run();
      expect(shown, 0);
      expect(notifier.shown, isEmpty);
    },
  );
  test('remembers when it last checked', () async {
    await withClock(Clock.fixed(testNow), poller().run);
    expect(DateTime.parse(store.values[NotificationPoller.sinceKey]!), testNow);
  });

  test('offline: nothing shown and the next run tries again', () async {
    backend.scenario = MockScenario.offline;
    await expectLater(poller().run(), throwsA(anything));
    expect(notifier.shown, isEmpty);
    expect(store.values[NotificationPoller.sinceKey], isNull);
  });

  test('an event the open app already showed is not shown again', () async {
    final event = NotificationEvent(
      id: 'n-m9',
      kind: NotificationEventKind.chatMessage,
      at: testNow,
      titleFa: 'پیام از انبار پاساژ',
      bodyFa: 'سلام',
      target: '/requests/5',
    );
    final first = await NotificationPoller.showNew(
      store: store,
      notifier: notifier,
      events: [event],
      serverTime: testNow,
    );
    final second = await NotificationPoller(
      source: _Fixed([event]),
      store: store,
      notifier: notifier,
    ).run();

    expect(first, 1);
    expect(second, 0);
    expect(notifier.shown, [event]);
  });
}
