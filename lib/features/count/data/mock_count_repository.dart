import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/count/domain/count_repository.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';

class MockCountRepository implements CountRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<List<SurpriseCount>> list() => _backend.call(() {
    if (_backend.isEmpty) return const <SurpriseCount>[];
    return [..._backend.counts]
      ..sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
  });

  @override
  Future<SurpriseCount> get(String id) => _backend.call(
    () => _backend.counts.firstWhere(
      (c) => c.id == id,
      orElse: () => throw const NotFoundException(),
    ),
  );

  @override
  Future<SurpriseCount> start({
    required List<String> itemCodes,
    required String idempotencyKey,
  }) => _backend.call(() => _backend.startCount(itemCodes, idempotencyKey));
}
