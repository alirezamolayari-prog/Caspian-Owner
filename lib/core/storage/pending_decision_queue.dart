import 'dart:convert';

import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/domain/requests_repository.dart';
import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// A queued decision the server refused for good (e.g. `422`: a reject
/// without a reason). It was dropped from the queue; [error] says why.
class FailedDecision {
  const new({required this.decision, required this.error});

  final Decision decision;
  final ApiException error;
}

/// What one [PendingDecisionQueue.flush] achieved.
class FlushResult {
  const new({
    this.applied = const [],
    this.conflicts = const [],
    this.failed = const [],
    this.remaining = 0,
  });

  /// Requests the server accepted our decision for.
  final List<GoodsRequest> applied;

  /// Requests someone else decided first (`409`); each carries the winner.
  final List<GoodsRequest> conflicts;

  /// Decisions the server refused for good; dropped from the queue.
  final List<FailedDecision> failed;

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
    List<DecisionLine>? lines,
    String? note,
  }) async {
    final decision = Decision(
      requestId: requestId,
      action: action,
      reason: reason,
      lines: lines,
      note: note,
      idempotencyKey: _uuid.v4(),
    );
    await _db
        .into(_db.pendingDecisions)
        .insertOnConflictUpdate(
          PendingDecisionsCompanion.insert(
            requestId: requestId,
            action: action.name,
            reason: Value(reason),
            payload: Value(
              lines == null && note == null
                  ? null
                  : jsonEncode({
                      'lines': [
                        for (final l in lines ?? const <DecisionLine>[])
                          l.toJson(),
                      ],
                      'note': note,
                    }),
            ),
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
  /// - offline or signed out (`401`): kept; stops, the rest would fail too
  /// - `408`, `429`, `5xx`: kept with the error (sent again later)
  /// - any other refusal (`400`, `403`, `404`, `422`, …): it will never be
  ///   accepted, so it is removed and returned in `failed`
  Future<FlushResult> flush(RequestsRepository repository) async {
    final applied = <GoodsRequest>[];
    final conflicts = <GoodsRequest>[];
    final failed = <FailedDecision>[];
    for (final decision in await pending()) {
      try {
        applied.add(await repository.decide(decision));
        await remove(decision.requestId);
      } on AlreadyDecidedException catch (e) {
        conflicts.add(e.request);
        await remove(decision.requestId);
      } on ApiException catch (e) {
        if (e is NetworkException || e is UnauthorizedException) {
          await _recordFailure(decision.requestId, e.toString());
          break;
        }
        if (isTemporary(e)) {
          await _recordFailure(decision.requestId, e.toString());
        } else {
          failed.add(FailedDecision(decision: decision, error: e));
          await remove(decision.requestId);
        }
      }
    }
    return FlushResult(
      applied: applied,
      conflicts: conflicts,
      failed: failed,
      remaining: (await pending()).length,
    );
  }

  /// Worth sending again later: no connection, the server busy or broken.
  static bool isTemporary(ApiException e) => switch (e) {
    NetworkException() || UnauthorizedException() => true,
    ServerException(statusCode: final int status) =>
      status == 408 || status == 429 || status >= 500,
    // No status: an answer the app couldn't read; try again.
    ServerException(code: 'bad_response') => true,
    _ => false,
  };

  /// Drops queued decisions that can no longer matter: the request was
  /// decided (by anyone) or issued meanwhile, or doesn't exist any more.
  /// Run once at start, before the first [flush]. Returns the dropped
  /// request ids; offline, nothing is dropped.
  Future<List<String>> reconcile(RequestsRepository repository) async {
    final dropped = <String>[];
    for (final decision in await pending()) {
      bool stale;
      try {
        final current = await repository.get(decision.requestId);
        stale = current.status != RequestStatus.pending;
      } on NotFoundException {
        stale = true;
      } on ApiException {
        break; // offline or the server is busy: decide later
      }
      if (stale) {
        await remove(decision.requestId);
        dropped.add(decision.requestId);
      }
    }
    return dropped;
  }

  Future<void> _recordFailure(String requestId, String error) =>
      _db.customUpdate(
        'UPDATE pending_decisions SET attempts = attempts + 1, '
        'last_error = ? WHERE request_id = ?',
        variables: [Variable(error), Variable(requestId)],
        updates: {_db.pendingDecisions},
      );

  Decision _toDecision(PendingDecision row) {
    final payload = row.payload == null
        ? null
        : jsonDecode(row.payload!) as Map<String, Object?>;
    return Decision(
      requestId: row.requestId,
      action: DecisionAction.values.byName(row.action),
      reason: row.reason,
      idempotencyKey: row.idempotencyKey,
      lines: switch (payload?['lines']) {
        final List<Object?> lines => [
          for (final l in lines)
            DecisionLine.fromJson(l! as Map<String, Object?>),
        ],
        _ => null,
      },
      note: payload?['note'] as String?,
    );
  }
}
