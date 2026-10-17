import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:caspian_owner/features/stock/domain/stock_repository.dart';

class MockStockRepository implements StockRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<List<StockItem>> list({String? query, bool lowOnly = false}) =>
      _backend.call(() {
        if (_backend.isEmpty) return const <StockItem>[];
        final q = toLatinDigits(query?.trim() ?? '');
        return [
          for (final item in _backend.stock)
            if ((!lowOnly || item.low) &&
                (q.isEmpty ||
                    toLatinDigits(item.nameFa).contains(q) ||
                    item.code.toLowerCase().contains(q.toLowerCase())))
              item,
        ];
      });

  @override
  Future<List<StockMovement>> movements(String itemCode) => _backend.call(() {
    if (_backend.lockedItemCodes.contains(itemCode)) {
      return const <StockMovement>[];
    }
    return [
      for (final m in _backend.movements)
        if (m.itemCode == itemCode) m.movement,
    ]..sort((a, b) => b.date.compareTo(a.date));
  });
}
