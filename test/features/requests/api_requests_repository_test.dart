import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/requests/data/api_requests_repository.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  late FakeServer server;
  late ApiRequestsRepository repository;

  setUp(() {
    server = FakeServer();
    repository = ApiRequestsRepository(server.client(), myId: () => '3');
  });

  Decision decision(DecisionAction action, {String? reason}) => Decision(
    requestId: '5',
    action: action,
    idempotencyKey: 'k',
    reason: reason,
  );

  test('a server request becomes an app request (Persian intact)', () async {
    server.on('GET', '/requests', FakeServer.json([serverRequest()]));

    final request = (await repository.list()).single;

    expect(request.id, '5');
    expect(request.number, 5);
    expect(request.status, RequestStatus.pending);
    expect(request.canDecide, isTrue, reason: 'owners decide every request');
    expect(request.requester.nameFa, 'علی رضایی');
    expect(request.place.locationCode, 'سرویس بهداشتی طبقه ۲');
    expect(request.note, 'فوری');
    expect(request.lines.map((l) => l.itemNameFa), [
      'کیسه زباله',
      'مایع دستشویی',
    ]);
    expect(request.lines[1].qty, 2.5);
    expect(
      request.createdAt.isAtSameMomentAs(DateTime.utc(2026, 10, 21, 8)),
      isTrue,
    );
    expect(request.createdAt.isUtc, isFalse, reason: 'shown in local time');
  });

  test('status filter is passed to the server', () async {
    server.on('GET', '/requests', FakeServer.json(<Object>[]));
    await repository.list(status: RequestStatus.pending);
    expect(server.requests.single.queryParameters, {'status': 'pending'});

    // Statuses the server doesn't have: nothing to ask.
    expect(await repository.list(status: RequestStatus.returned), isEmpty);
    expect(server.requests, hasLength(1));
  });

  test('detail includes the chat summary', () async {
    server
      ..on('GET', '/requests/5', FakeServer.json(serverRequest()))
      ..on(
        'GET',
        '/requests/5/messages',
        FakeServer.json([
          serverMessage(),
          serverMessage(id: 2, senderId: 3, senderRole: 'owner', text: 'باشه'),
        ]),
      );

    final request = await repository.get('5');

    expect(request.chatSummary?.count, 2);
    expect(request.chatSummary?.last?.text, 'باشه');
    expect(request.chatSummary?.last?.author.isMe, isTrue);
  });

  test('approve and reject call the right endpoints', () async {
    server
      ..on(
        'POST',
        '/requests/5/approve',
        FakeServer.json(serverRequest(status: 'approved', decidedByMe: true)),
      )
      ..on(
        'POST',
        '/requests/5/reject',
        FakeServer.json(
          serverRequest(
            status: 'rejected',
            decidedByMe: true,
            rejectionReason: 'زیاد است',
          ),
        ),
      );

    final approved = await repository.decide(decision(DecisionAction.approve));
    expect(approved.status, RequestStatus.approved);
    expect(approved.decidedBy?.kind, DeciderKind.me);

    final rejected = await repository.decide(
      decision(DecisionAction.reject, reason: 'زیاد است'),
    );
    expect(rejected.decisionReason, 'زیاد است');
    expect(server.calls('POST', '/requests/5/reject').single.data, {
      'reason': 'زیاد است',
    });
  });

  test('409 when another owner decided first → AlreadyDecided', () async {
    server
      ..on('POST', '/requests/5/approve', FakeServer.error(409))
      ..on(
        'GET',
        '/requests/5',
        FakeServer.json(serverRequest(status: 'rejected', decidedByMe: false)),
      );

    await expectLater(
      repository.decide(decision(DecisionAction.approve)),
      throwsA(
        isA<AlreadyDecidedException>().having(
          (e) => e.request.decidedBy?.kind,
          'winner',
          DeciderKind.anotherOwner,
        ),
      ),
    );
  });

  test('409 after a retry of our own decision counts as done', () async {
    server
      ..on('POST', '/requests/5/approve', FakeServer.error(409))
      ..on(
        'GET',
        '/requests/5',
        FakeServer.json(serverRequest(status: 'approved', decidedByMe: true)),
      );

    final request = await repository.decide(decision(DecisionAction.approve));
    expect(request.status, RequestStatus.approved);
  });

  test('ids that are not numbers can not exist', () async {
    await expectLater(
      repository.get('r-124'),
      throwsA(isA<NotFoundException>()),
    );
    expect(server.requests, isEmpty);
  });

  test('return for edit is not on this server', () async {
    await expectLater(
      repository.decide(decision(DecisionAction.returnForEdit)),
      throwsA(isA<ServerException>()),
    );
  });
}
