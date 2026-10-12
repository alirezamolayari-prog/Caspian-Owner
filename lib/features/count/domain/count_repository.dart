import 'package:caspian_owner/features/count/domain/surprise_count.dart';

/// Surprise counts (contract: `/v1/counts`).
abstract interface class CountRepository {
  /// Newest first.
  Future<List<SurpriseCount>> list();

  Future<SurpriseCount> get(String id);

  /// Starts a count now: the Warehouse locks the items and hides their
  /// stock from everyone until staff enter the counted numbers.
  ///
  /// Throws `ConflictException` when an item is already being counted.
  Future<SurpriseCount> start({
    required List<String> itemCodes,
    required String idempotencyKey,
  });
}
