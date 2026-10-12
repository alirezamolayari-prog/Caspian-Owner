import 'package:caspian_owner/core/domain/person.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'surprise_count.freezed.dart';
part 'surprise_count.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum CountStatus { running, done }

@freezed
abstract class CountItem with _$CountItem {
  const factory({
    required String itemCode,
    required String itemNameFa,
    required String unitFa,
  }) = _CountItem;

  factory fromJson(Map<String, Object?> json) => _$CountItemFromJson(json);
}

/// One number entered by warehouse staff during a count.
@freezed
abstract class CountEntry with _$CountEntry {
  const factory({
    required double qty,
    required Person enteredBy,
    required DateTime enteredAt,
  }) = _CountEntry;

  factory fromJson(Map<String, Object?> json) => _$CountEntryFromJson(json);
}

@freezed
abstract class CountResult with _$CountResult {
  const factory({
    required String itemCode,
    required double systemQty,
    required double countedQty,

    /// Every number that was entered, in order.
    required List<CountEntry> entries,
    required List<Person> countedBy,
  }) = _CountResult;

  const new _();

  factory fromJson(Map<String, Object?> json) => _$CountResultFromJson(json);

  /// Counted minus system. Negative means items are missing.
  double get difference => countedQty - systemQty;

  bool get hasDiscrepancy => difference != 0;
}

/// A surprise count (شمارش غافلگیرانه) (contract: `SurpriseCount`).
/// Stock is never auto-adjusted from the results.
@freezed
abstract class SurpriseCount with _$SurpriseCount {
  const factory({
    required String id,
    required Owner orderedBy,
    required DateTime orderedAt,
    required List<CountItem> items,
    required CountStatus status,
    DateTime? finishedAt,
    List<CountResult>? results,
  }) = _SurpriseCount;

  factory fromJson(Map<String, Object?> json) => _$SurpriseCountFromJson(json);
}
