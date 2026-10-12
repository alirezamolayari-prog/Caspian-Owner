import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/domain/requests_repository.dart';

class MockRequestsRepository implements RequestsRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<List<GoodsRequest>> list({
    RequestStatus? status,
    bool escalatedOnly = false,
  }) => _backend.call(() {
    if (_backend.isEmpty) return const <GoodsRequest>[];
    return [
      for (final r in _backend.requests)
        if ((status == null || r.status == status) &&
            (!escalatedOnly || r.escalated))
          r,
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  });

  @override
  Future<GoodsRequest> get(String id) => _backend.call(() {
    final request = _backend.requestById(id);
    return request.copyWith(locationHistory: _backend.locationHistory(request));
  });

  @override
  Future<GoodsRequest> decide(Decision decision) =>
      _backend.call(() => _backend.decide(decision));
}
