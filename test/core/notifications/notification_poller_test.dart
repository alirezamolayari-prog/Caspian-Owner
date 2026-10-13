import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/notifications/notification_poller.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';

class _Recorder implements LocalNotifier {
  final shown = <NotificationEvent>[];

  @override
  Future<void> show(NotificationEvent event) async => shown.add(event);
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

  test('a finished count produces a result notification', () async {
    await withClock(Clock.fixed(testNow), poller().run);
    withClock(Clock.fixed(testNow.add(const Duration(minutes: 1))), () {
      backend.completeCount('c-7');
    });
    await withClock(
      Clock.fixed(testNow.add(const Duration(minutes: 15))),
      poller().run,
    );
    final result = notifier.shown.last;
    expect(result.kind, NotificationEventKind.countResult);
    expect(result.target, '/counts/c-7');
  });

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
}
