import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Last data received from the server, as contract JSON, so screens can
/// show it offline with «آخرین به‌روزرسانی: …».
class CacheEntries extends Table {
  TextColumn get key => text()();
  TextColumn get json => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Decisions not yet confirmed by the server («در صف ارسال»).
/// At most one per request: a newer decision replaces an unsent one.
class PendingDecisions extends Table {
  TextColumn get requestId => text()();
  TextColumn get action => text()();
  TextColumn get reason => text().nullable()();
  TextColumn get idempotencyKey => text().unique()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {requestId};
}

@DriftDatabase(tables: [CacheEntries, PendingDecisions])
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device database, or uses [executor] (tests).
  new([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'caspian_owner'));

  @override
  int get schemaVersion => 1;

  /// Deletes all local data (logout).
  Future<void> wipe() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });
}
