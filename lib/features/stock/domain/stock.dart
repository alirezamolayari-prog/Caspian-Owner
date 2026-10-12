import 'package:caspian_owner/core/domain/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';
part 'stock.g.dart';

/// A warehouse item and its quantity (contract: `StockItem`).
@freezed
abstract class StockItem with _$StockItem {
  const factory({
    required String code,
    required String nameFa,
    required String unitFa,

    /// Null while hidden by a running surprise count. Always sent: the
    /// contract requires the key even when the value is null.
    @JsonKey(includeIfNull: true) required double? qty,
    required bool low,
    required bool lockedByCount,
    String? shelfFa,
  }) = _StockItem;

  factory fromJson(Map<String, Object?> json) => _$StockItemFromJson(json);
}

enum StockMovementKind {
  @JsonValue('in')
  incoming,
  @JsonValue('out')
  outgoing,
  @JsonValue('adjustment')
  adjustment,
}

/// One in/out movement of an item (contract: `StockMovement`).
@freezed
abstract class StockMovement with _$StockMovement {
  const factory({
    required DateTime date,
    required StockMovementKind kind,
    required double qty,
    required String documentNo,
    ConsumptionPlace? place,
  }) = _StockMovement;

  factory fromJson(Map<String, Object?> json) => _$StockMovementFromJson(json);
}
