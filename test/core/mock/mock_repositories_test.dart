import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/features/assistant/data/mock_assistant_repository.dart';
import 'package:caspian_owner/features/auth/data/mock_auth_repository.dart';
import 'package:caspian_owner/features/chat/data/mock_chat_repository.dart';
import 'package:caspian_owner/features/chat/domain/chat_repository.dart';
import 'package:caspian_owner/features/reports/data/mock_reports_repository.dart';
import 'package:caspian_owner/features/reports/domain/consumption_report.dart';
import 'package:caspian_owner/features/requests/data/mock_requests_repository.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/stock/data/mock_stock_repository.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';

Decision _decision(
  String id, {
  DecisionAction action = DecisionAction.approve,
  String key = 'k-1',
}) => Decision(requestId: id, action: action, idempotencyKey: key);

void main() {
  late MockBackend backend;
  setUp(() async => backend = await testBackend());

  T at<T>(T Function() body) => withClock(Clock.fixed(testNow), body);

  group('requests', () {
    test('newest first, filtered by status', () async {
      final repo = MockRequestsRepository(backend);
      final all = await repo.list();
      expect(all.first.number, 125);
      expect(
        all.map((r) => r.number),
        orderedEquals([125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115]),
      );
      final pending = await repo.list(status: RequestStatus.pending);
      expect(pending.map((r) => r.number), [125, 124, 123, 122]);
      expect(pending.every((r) => r.canDecide), isTrue);
    });

    test('escalatedOnly hides routine requests', () async {
      final repo = MockRequestsRepository(backend);
      final escalated = await repo.list(escalatedOnly: true);
      expect(escalated.any((r) => !r.escalated), isFalse);
      expect(escalated.map((r) => r.number), isNot(contains(120)));
    });

    test('detail includes the usage history of the same place', () async {
      final request = await MockRequestsRepository(backend).get('r-124');
      final history = request.locationHistory!;
      // Earlier issues to پلاک ۶۸ – همکف, newest first.
      expect(history.map((u) => u.documentNo), ['ح-۸۸۴', 'ح-۸۶۹', 'ح-۸۶۱']);
    });

    test('approve records the owner as decider', () async {
      final updated = await at(
        () => MockRequestsRepository(backend).decide(_decision('r-124')),
      );
      expect(updated.status, RequestStatus.approved);
      expect(
        updated.decidedBy,
        const DecidedBy(kind: DeciderKind.owner, nameFa: 'علیرضا'),
      );
      expect(updated.decidedAt, testNow);
    });

    test('same idempotency key is applied once (no 409 on retry)', () async {
      final repo = MockRequestsRepository(backend);
      final first = await repo.decide(_decision('r-124'));
      final retry = await repo.decide(_decision('r-124'));
      expect(retry, first);
    });

    test('first decision wins: a second decision gets 409', () async {
      final repo = MockRequestsRepository(backend);
      await repo.decide(_decision('r-124'));
      await expectLater(
        repo.decide(
          _decision('r-124', action: DecisionAction.reject, key: 'k-2'),
        ),
        throwsA(
          isA<AlreadyDecidedException>().having(
            (e) => e.request.status,
            'winning status',
            RequestStatus.approved,
          ),
        ),
      );
    });

    test('routine (non-escalated) requests cannot be decided', () async {
      await expectLater(
        MockRequestsRepository(backend).decide(_decision('r-120')),
        throwsA(isA<AlreadyDecidedException>()),
      );
    });

    test('conflict scenario: another owner decided first', () async {
      backend.scenario = MockScenario.conflict;
      await expectLater(
        MockRequestsRepository(backend).decide(_decision('r-124')),
        throwsA(
          isA<AlreadyDecidedException>().having(
            (e) => e.request.decidedBy!.nameFa,
            'decided by',
            isNot('علیرضا'),
          ),
        ),
      );
    });
  });

  group('scenarios', () {
    test('server error fails every call', () async {
      backend.scenario = MockScenario.serverError;
      await expectLater(
        MockStockRepository(backend).list(),
        throwsA(isA<ServerException>()),
      );
    });

    test('empty returns no data', () async {
      backend.scenario = MockScenario.empty;
      expect(await MockRequestsRepository(backend).list(), isEmpty);
      expect(await MockStockRepository(backend).list(), isEmpty);
    });
  });

  group('stock', () {
    test('items the warehouse is counting are hidden', () async {
      final stock = await MockStockRepository(backend).list();
      final locked = stock.where((s) => s.lockedByCount).toList();
      expect(locked.map((s) => s.code), ['I-1012', 'I-1013']);
      expect(locked.every((s) => s.qty == null), isTrue);
      expect(await MockStockRepository(backend).movements('I-1012'), isEmpty);
    });

    test(
      'search by name with Persian or Latin digits, and low filter',
      () async {
        final repo = MockStockRepository(backend);
        expect((await repo.list(query: 'لامپ')).length, 2);
        // «۱۸» alone also matches code I-1018, so search a name fragment.
        expect((await repo.list(query: 'LED ۱۸')).single.code, 'I-1001');
        expect((await repo.list(query: 'LED 18')).single.code, 'I-1001');
        expect((await repo.list(query: '۱۸')).map((s) => s.code), [
          'I-1001',
          'I-1018',
        ]);
        final low = await repo.list(lowOnly: true);
        expect(low.map((s) => s.code), [
          'I-1003',
          'I-1005',
          'I-1008',
          'I-1015',
        ]);
      },
    );

    test('movements newest first', () async {
      final moves = await MockStockRepository(backend).movements('I-1001');
      expect(moves.first.documentNo, 'ح-۸۸۴');
      expect(moves.last.documentNo, 'ر-۲۱۲');
    });
  });

  group('reports', () {
    test('by floor: every floor in building order P4 → ROOF', () async {
      final report = await MockReportsRepository(backend).consumption(
        groupBy: ReportGrouping.floor,
        from: DateTime(2026, 9),
        to: DateTime(2026, 10, 31),
      );
      expect(report.rows.map((r) => r.code), [
        'P4',
        'P3',
        'P2',
        'P1',
        'B',
        'G',
        'F1',
        'F2',
        'F3',
        'ROOF',
      ]);
      expect(report.rows.firstWhere((r) => r.code == 'ROOF').total, 1);
    });

    test('by location: busiest first, with Persian names', () async {
      final report = await MockReportsRepository(backend).consumption(
        groupBy: ReportGrouping.location,
        from: DateTime(2026, 9),
        to: DateTime(2026, 10, 31),
      );
      expect(
        report.rows.first.total,
        greaterThanOrEqualTo(report.rows.last.total),
      );
      expect(report.rows.map((r) => r.nameFa), contains('پلاک ۶۸'));
    });
  });

  group('auth', () {
    test('only 11111 (in either digit set) signs in', () async {
      final auth = MockAuthRepository(backend);
      final session = await auth.verify(
        phone: '09120000000',
        deviceId: 'd',
        code: '۱۱۱۱۱',
      );
      expect(session.owner.isAdmin, isTrue);

      await expectLater(
        auth.verify(phone: '09120000000', deviceId: 'd', code: '22222'),
        throwsA(isA<ServerException>()),
      );
    });

    test('rejects malformed phone numbers', () async {
      await expectLater(
        MockAuthRepository(backend).registerDevice(
          phone: '12345',
          deviceId: 'd',
          deviceModel: 'm',
          appVersion: '0.1.0+1',
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('chat and assistant', () {
    test('sent message is mine and appears once', () async {
      final repo = MockChatRepository(backend);
      await repo.send(requestId: 'r-123', text: 'سلام', clientId: 'c1');
      await repo.send(requestId: 'r-123', text: 'سلام', clientId: 'c1');
      final messages = await repo.messages('r-123');
      expect(messages.where((m) => m.text == 'سلام'), hasLength(1));
      expect(messages.last.author.isMe, isTrue);
    });

    test('long chats come in pages, oldest first in each page', () async {
      final repo = MockChatRepository(backend);
      final newest = await repo.messages('r-121');
      expect(newest, hasLength(ChatRepository.pageSize));
      final older = await repo.messages('r-121', before: newest.first.id);
      expect(older.last.sentAt.isBefore(newest.first.sentAt), isTrue);
      final oldest = await repo.messages('r-121', before: older.first.id);
      expect(oldest.length, lessThan(ChatRepository.pageSize));
    });

    test('assistant answers suggestion chips from canned answers', () async {
      final repo = MockAssistantRepository(backend);
      final reply = await repo.ask('خلاصه امروز');
      expect(reply.text, startsWith('خلاصه امروز'));
      expect((await repo.history()).length, 4);
    });
  });

  test(
    'notification poll returns new escalations, results and chats',
    () async {
      final batch = await at(
        () =>
            MockNotificationSource(backend)
                .poll(since: testNow.subtract(const Duration(minutes: 30))),
      );
      final kinds = batch.events.map((e) => e.kind).toSet();
      expect(kinds, contains(NotificationEventKind.requestEscalated));
      expect(kinds, contains(NotificationEventKind.chatMessage));
      expect(
        batch.events.firstWhere((e) => e.id == 'n-r-124').target,
        '/requests/r-124',
      );
      expect(batch.serverTime, testNow);
    },
  );
}
