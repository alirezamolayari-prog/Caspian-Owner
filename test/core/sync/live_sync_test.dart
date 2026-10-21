import 'package:caspian_owner/core/sync/live_sync.dart';
import 'package:caspian_owner/features/chat/application/chat_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';
import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late FakeServer server;
  late ProviderContainer container;
  var changesAnswer = <String, Object?>{};

  setUp(() async {
    server = FakeServer()
      ..on(
        'GET',
        '/health',
        FakeServer.json({
          'status': 'ok',
          'server_time': '2026-10-21T09:00:00+00:00',
        }),
      )
      ..on('GET', '/changes', (r) => FakeServer.json(changesAnswer)(r))
      ..on('GET', '/requests/5/messages', FakeServer.json([serverMessage()]));
    changesAnswer = {
      'server_time': '2026-10-21T09:00:05Z',
      'next_since': '2026-10-21T09:00:03Z',
      'requests': <Object>[],
      'messages': <Object>[],
    };
    final harness = TestHarness.create(
      await loadTestFixtures(),
      signedIn: true,
      server: server,
    );
    addTearDown(harness.database.close);
    container = harness.container();
    addTearDown(container.dispose);
  });

  LiveSyncController live() => container.read(liveSyncProvider.notifier);

  test('starts at the server clock, then follows next_since', () async {
    await live().pollOnce();
    await live().pollOnce();

    final since = [
      for (final r in server.calls('GET', '/changes'))
        r.queryParameters['since'],
    ];
    expect(since, ['2026-10-21T09:00:00.000Z', '2026-10-21T09:00:03.000Z']);
    expect(server.calls('GET', '/health'), hasLength(1));
    expect(
      container.read(liveSyncProvider),
      DateTime.utc(2026, 10, 21, 9, 0, 3),
    );
  });

  test('a new message reaches an open chat once', () async {
    final chat = chatControllerProvider('5');
    await container.read(chat.future);
    changesAnswer = {
      ...changesAnswer,
      'messages': [
        serverMessage(
          id: 2,
          text: 'پیام تازه',
          createdAt: '2026-10-21T09:00:01Z',
        ),
      ],
    };

    await live().pollOnce();
    await live().pollOnce(); // the 2-second overlap sends it again

    final texts = [
      for (final e in container.read(chat).requireValue.entries) e.message.text,
    ];
    expect(texts, ['سلام', 'پیام تازه']);
  });

  test('offline: no crash, tries again with the same since', () async {
    await live().pollOnce();
    server.routes.remove('GET /changes');
    await live().pollOnce(); // server unreachable
    expect(
      container.read(liveSyncProvider),
      DateTime.utc(2026, 10, 21, 9, 0, 3),
    );
  });

  test('stop(reset) forgets since: the next owner starts fresh', () async {
    await live().pollOnce();
    live().stop(reset: true);
    expect(container.read(liveSyncProvider), isNull);
    await live().pollOnce();
    expect(server.calls('GET', '/health'), hasLength(2));
  });
}
