import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/storage/cached_fetch.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;

/// Every stock item (cached for offline use). Search and the «کم‌موجود»
/// filter run on the phone, so they are instant and work offline.
final stockControllerProvider =
    AsyncNotifierProvider<StockController, Fetched<List<StockItem>>>(
      StockController.new,
    );

class StockController extends AsyncNotifier<Fetched<List<StockItem>>> {
  @override
  Future<Fetched<List<StockItem>>> build() => cachedFetch(
    cache: ref.read(cacheStoreProvider),
    key: 'stock:all',
    fetch: () => ref.read(stockRepositoryProvider).list(),
    toJson: (items) => [for (final i in items) i.toJson()],
    fromJson: (json) => [
      for (final i in json! as List<Object?>)
        StockItem.fromJson(i! as Map<String, Object?>),
    ],
  );

  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // Shown by the screen from `state`.
    }
  }
}

/// The search box text.
final stockQueryProvider = NotifierProvider<StockQuery, String>(StockQuery.new);

class StockQuery extends Notifier<String> {
  @override
  String build() => '';

  String get query => state;
  set query(String value) => state = value;
}

/// «همه» (false) or «کم‌موجود» (true).
final stockLowOnlyProvider = NotifierProvider<StockLowOnly, bool>(
  StockLowOnly.new,
);

class StockLowOnly extends Notifier<bool> {
  @override
  bool build() => false;

  bool get lowOnly => state;
  set lowOnly(bool value) => state = value;
}

/// Matches name or code, with Persian or Latin digits.
List<StockItem> filterStock(
  List<StockItem> items, {
  required String query,
  required bool lowOnly,
}) {
  final q = toLatinDigits(query.trim()).toLowerCase();
  return [
    for (final item in items)
      if ((!lowOnly || item.low) &&
          (q.isEmpty ||
              toLatinDigits(item.nameFa).toLowerCase().contains(q) ||
              item.code.toLowerCase().contains(q)))
        item,
  ];
}

/// Recent in/out movements of one item, newest first.
final FutureProviderFamily<Fetched<List<StockMovement>>, String>
stockMovementsProvider = FutureProvider.family(
  (ref, code) => cachedFetch(
    cache: ref.read(cacheStoreProvider),
    key: 'movements:$code',
    fetch: () => ref.read(stockRepositoryProvider).movements(code),
    toJson: (list) => [for (final m in list) m.toJson()],
    fromJson: (json) => [
      for (final m in json! as List<Object?>)
        StockMovement.fromJson(m! as Map<String, Object?>),
    ],
  ),
);
