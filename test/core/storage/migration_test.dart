import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:caspian_owner/core/storage/pending_decision_queue.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Phones updated from v0.1.0 have a version-1 database. Opening it with
/// v0.2.0 must add the payload column and keep queued decisions.
void main() {
  test('v1 → v2 keeps queued decisions and stores send-back lines', () async {
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(
          setup: (raw) {
            // The v0.1.0 schema, with one decision waiting offline.
            raw
              ..execute(
                'CREATE TABLE cache_entries (key TEXT NOT NULL PRIMARY KEY, '
                'json TEXT NOT NULL, updated_at TEXT NOT NULL)',
              )
              ..execute(
                'CREATE TABLE pending_decisions ( '
                'request_id TEXT NOT NULL PRIMARY KEY, '
                'action TEXT NOT NULL, reason TEXT NULL, '
                'idempotency_key TEXT NOT NULL UNIQUE, '
                'created_at TEXT NOT NULL, '
                'attempts INTEGER NOT NULL DEFAULT 0, last_error TEXT NULL)',
              )
              ..execute(
                'INSERT INTO pending_decisions '
                '(request_id, action, idempotency_key, created_at) '
                "VALUES ('r-124', 'approve', 'k-old', "
                "'2026-10-17T10:00:00.000Z')",
              )
              ..execute('PRAGMA user_version = 1');
          },
        ),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    final queue = PendingDecisionQueue(db);

    final before = await queue.pending();
    expect(before.single.requestId, 'r-124');
    expect(before.single.idempotencyKey, 'k-old');

    await queue.enqueue(
      requestId: 'r-119',
      action: DecisionAction.returnForEdit,
      lines: const [DecisionLine(itemCode: 'I-1011', qty: 12)],
      note: 'نصف کافی است',
    );
    final sendBack = (await queue.pending()).last;
    expect(sendBack.action, DecisionAction.returnForEdit);
    expect(sendBack.lines!.single.qty, 12);
    expect(sendBack.note, 'نصف کافی است');
  });
}
