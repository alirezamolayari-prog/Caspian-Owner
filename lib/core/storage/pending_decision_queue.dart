import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/domain/requests_repository.dart';
import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// What one [PendingDecisionQueue.flush] achieved.
class FlushResult {
  const new({
    this.applied = const [],
    this.conflicts = const [],
    this.remaining = 0,
  });

  /// Requests the server accepted our decision for.
  final List<GoodsRequest> applied;

  /// Requests someone else decided first (`409`); each carries the winner.
  final List<GoodsRequest> conflicts;

  /// Decisions still waiting («در صف ارسال»).
  final int remaining;
}

/// Owner decisions waiting to reach the server. Every decision goes through
/// here: enqueue, then flush. Offline, it simply stays queued; each entry
/// keeps its idempotency key, so a retry is applied by the server only once.
class PendingDecisionQueue {
  new(this._db, {this._uuid = const Uuid()});

  final AppDatabase _db;
  final Uuid _uuid;

  /// Queues a decision for [requestId] with a fresh idempotency key.
  /// Replaces an unsent decision for the same request.
  Future<Decision> enqueue({
    required String requestId,
    required DecisionAction action,
    String? reason,
  }) async {
    final decision = Decision(
      requestId: requestId,
      action: action,
      reason: reason,
      idempotencyKey: _uuid.v4(),
    );
    await _db
        .into(_db.pendingDecisions)
        .insertOnConflictUpdate(
          PendingDecisionsCompanion.insert(
            requestId: requestId,
            action: action.name,
            reason: Value(reason),
            idempotencyKey: decision.idempotencyKey,
            createdAt: clock.now(),
          ),
        );
    return decision;
  }

  /// Oldest first.
  Future<List<Decision>> pending() async {
    final rows = await (_db.select(
      _db.pendingDecisions,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    return rows.map(_toDecision).toList();
  }

  /// Emits the queue whenever it changes (for «در صف ارسال» labels).
  Stream<List<Decision>> watch() =>
      (_db.select(_db.pendingDecisions)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(_toDecision).toList());

  Future<void> remove(String requestId) => (_db.delete(
    _db.pendingDecisions,
  )..where((t) => t.requestId.equals(requestId))).go();

  /// Sends queued decisions, oldest first.
  /// - accepted: removed, returned in `applied`
  /// - `409` already decided: removed, returned in `conflicts`
  /// - offline: kept; stops, since the rest would fail too
  /// - other errors: kept with the error, and the next one is tried
  Future<FlushResult> flush(RequestsRepository repository) async {
    final applied = <GoodsRequest>[];
    final conflicts = <GoodsRequest>[];
    for (final decision in await pending()) {
      try {
        applied.add(await repository.decide(decision));
        await remove(decision.requestId);
      } on AlreadyDecidedException catch (e) {
        conflicts.add(e.request);
        await remove(decision.requestId);
      } on NetworkException catch (e) {
        await _recordFailure(decision.requestId, e.toString());
        break;
      } on ApiException catch (e) {
        await _recordFailure(decision.requestId, e.toString());
      }
    }
    return FlushResult(
      applied: applied,
      conflicts: conflicts,
      remaining: (await pending()).length,
    );
  }

  Future<void> _recordFailure(String requestId, String error) =>
      _db.customUpdate(
        'UPDATE pending_decisions SET attempts = attempts + 1, '
        'last_error = ? WHERE request_id = ?',
        variables: [Variable(error), Variable(requestId)],
        updates: {_db.pendingDecisions},
      );

  Decision _toDecision(PendingDecision row) => Decision(
    requestId: row.requestId,
    action: DecisionAction.values.byName(row.action),
    reason: row.reason,
    idempotencyKey: row.idempotencyKey,
  );
}
