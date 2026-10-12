import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/storage/cache_store.dart';

/// A value and, when it came from the cache, when it was received.
class Fetched<T> {
  const new(this.value, {this.cachedAt});

  final T value;

  /// Non-null when offline and showing saved data
  /// («آخرین به‌روزرسانی: …»).
  final DateTime? cachedAt;

  bool get isStale => cachedAt != null;
}

/// Fetches fresh data and saves it; when offline, falls back to the last
/// saved copy. Without a saved copy the [NetworkException] is rethrown so
/// the screen can show its error state.
Future<Fetched<T>> cachedFetch<T>({
  required CacheStore cache,
  required String key,
  required Future<T> Function() fetch,
  required Object? Function(T value) toJson,
  required T Function(Object? json) fromJson,
}) async {
  try {
    final value = await fetch();
    await cache.put(key, toJson(value));
    return Fetched(value);
  } on NetworkException {
    final cached = await cache.get(key, fromJson);
    if (cached == null) rethrow;
    return Fetched(cached.value, cachedAt: cached.updatedAt);
  }
}
