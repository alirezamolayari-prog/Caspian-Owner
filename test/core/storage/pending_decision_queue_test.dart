import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/core/storage/cache_store.dart';
import 'package:caspian_owner/core/storage/pending_decision_queue.dart';
import 'package:caspian_owner/features/requests/data/mock_requests_repository.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/domain/requests_repository.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';

/// A repository that is offline until [online] is set.
class _FlakyRepository implements RequestsRepository {
  new(this._inner);

  final RequestsRepository _inner;
  bool online = false;
  final sentKeys = <String>[];

  @override
  Future<GoodsRequest> decide(Decision decision) {
    sentKeys.add(decision.idempotencyKey);
    if (!online) throw const NetworkException('offline');
    return _inner.decide(decision);
  }

  @override
  Future<GoodsRequest> get(String id) => _inner.get(id);

  @override
  Future<List<GoodsRequest>> list({
    RequestStatus? status,
    bool escalatedOnly = false,
  }) => _inner.list(status: status, escalatedOnly: escalatedOnly);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late PendingDecisionQueue queue;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queue = PendingDecisionQueue(db);
  });
  tearDown(() => db.close());

  test('enqueue gives each decision a unique idempotency key', () async {
    final a = await queue.enqueue(
      requestId: 'r-124',
      action: DecisionAction.approve,
    );
    final b = await queue.enqueue(
      requestId: 'r-123',
      action: DecisionAction.reject,
      reason: 'زیاد است',
    );
    expect(a.idempotencyKey, isNot(b.idempotencyKey));
    expect(await queue.pending(), [a, b]);
  });

  test('a newer decision replaces the unsent one', () async {
    await queue.enqueue(requestId: 'r-124', action: DecisionAction.approve);
    final latest = await queue.enqueue(
      requestId: 'r-124',
      action: DecisionAction.reject,
    );
    expect(await queue.pending(), [latest]);
  });

  test('flush sends, then empties the queue', () async {
    final repo = MockRequestsRepository(await testBackend());
    await queue.enqueue(requestId: 'r-124', action: DecisionAction.approve);
    final result = await queue.flush(repo);
    expect(result.applied.single.status, RequestStatus.approved);
    expect(result.remaining, 0);
    expect(await queue.pending(), isEmpty);
  });

  test('409 removes the entry and reports who decided first', () async {
    final backend = await testBackend();
    final repo = MockRequestsRepository(backend);
    await repo.decide(
      const Decision(
        requestId: 'r-124',
        action: DecisionAction.approve,
        idempotencyKey: 'other-owner',
      ),
    );
    await queue.enqueue(requestId: 'r-124', action: DecisionAction.reject);

    final result = await queue.flush(repo);
    expect(result.conflicts.single.status, RequestStatus.approved);
    expect(result.applied, isEmpty);
    expect(await queue.pending(), isEmpty);
  });

  test('offline keeps the decision and retries with the same key', () async {
    final flaky = _FlakyRepository(MockRequestsRepository(await testBackend()));
    final decision = await queue.enqueue(
      requestId: 'r-124',
      action: DecisionAction.approve,
    );

    final offline = await queue.flush(flaky);
    expect(offline.remaining, 1);
    expect(await queue.pending(), [decision]);

    flaky.online = true;
    final online = await queue.flush(flaky);
    expect(online.applied, hasLength(1));
    expect(online.remaining, 0);
    expect(flaky.sentKeys, [decision.idempotencyKey, decision.idempotencyKey]);
  });

  test('offline stops the flush instead of hammering the network', () async {
    final flaky = _FlakyRepository(MockRequestsRepository(await testBackend()));
    await queue.enqueue(requestId: 'r-124', action: DecisionAction.approve);
    await queue.enqueue(requestId: 'r-123', action: DecisionAction.approve);
    await queue.flush(flaky);
    expect(flaky.sentKeys, hasLength(1));
  });

  test('watch emits the queue as it changes', () async {
    final lengths = <int>[];
    final subscription = queue.watch().listen((l) => lengths.add(l.length));
    await pumpEventQueue();
    await queue.enqueue(requestId: 'r-124', action: DecisionAction.approve);
    await pumpEventQueue();
    await queue.remove('r-124');
    await pumpEventQueue();
    await subscription.cancel();
    expect(lengths, [0, 1, 0]);
  });

  test('wipe clears cache and queue (logout)', () async {
    final cache = CacheStore(db);
    await cache.put('requests', {'a': 1});
    await queue.enqueue(requestId: 'r-124', action: DecisionAction.approve);
    expect(await cache.get('requests', (j) => j), isNotNull);

    await db.wipe();
    expect(await cache.get('requests', (j) => j), isNull);
    expect(await queue.pending(), isEmpty);
  });
}
