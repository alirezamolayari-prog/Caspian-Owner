import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// Goods requests (contract: `/v1/requests`).
abstract interface class RequestsRepository {
  /// Newest first. [status] filters by status; [escalatedOnly] hides
  /// routine requests decided in the Warehouse app.
  Future<List<GoodsRequest>> list({
    RequestStatus? status,
    bool escalatedOnly = false,
  });

  /// One request, including the usage history of the same place.
  Future<GoodsRequest> get(String id);

  /// Sends an owner decision. Returns the updated request.
  ///
  /// Throws `AlreadyDecidedException` (`409`) when someone decided first,
  /// and `NetworkException` when offline (the caller queues the decision).
  Future<GoodsRequest> decide(Decision decision);
}
