import 'dart:convert';

import 'package:caspian_owner/core/storage/app_database.dart';
import 'package:clock/clock.dart';

/// A cached value and when it was received.
class Cached<T> {
  const new(this.value, this.updatedAt);

  final T value;
  final DateTime updatedAt;
}

/// Key-value cache of contract JSON in the local database.
class CacheStore {
  const new(this._db);

  final AppDatabase _db;

  Future<void> put(String key, Object? json) => _db
      .into(_db.cacheEntries)
      .insertOnConflictUpdate(
        CacheEntriesCompanion.insert(
          key: key,
          json: jsonEncode(json),
          updatedAt: clock.now(),
        ),
      );

  /// The cached value for [key], decoded with [decode], or null.
  Future<Cached<T>?> get<T>(String key, T Function(Object? json) decode) async {
    final row = await (_db.select(
      _db.cacheEntries,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    return Cached(decode(jsonDecode(row.json)), row.updatedAt);
  }
}
