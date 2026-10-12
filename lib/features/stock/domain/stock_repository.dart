import 'package:caspian_owner/features/stock/domain/stock.dart';

/// Warehouse stock (contract: `/v1/stock`).
abstract interface class StockRepository {
  /// Items matching [query] (name or code). Quantities are null while a
  /// surprise count hides them.
  Future<List<StockItem>> list({String? query, bool lowOnly = false});

  /// Recent movements, newest first. Empty while the item is hidden.
  Future<List<StockMovement>> movements(String itemCode);
}
