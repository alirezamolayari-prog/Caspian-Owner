import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/storage/cached_fetch.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// What Home shows.
class HomeData {
  const new({
    required this.pendingCount,
    required this.latest,
    this.lastCount,
    this.cachedAt,
  });

  /// Escalated requests waiting for an owner.
  final int pendingCount;

  /// The 3 newest requests (escalated or routine).
  final List<GoodsRequest> latest;

  /// The newest surprise count, running or done.
  final SurpriseCount? lastCount;

  /// Set when offline and showing saved data.
  final DateTime? cachedAt;
}

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeData>(
  HomeController.new,
);

class HomeController extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() => _load();

  /// Pull-to-refresh and «تلاش دوباره». Keeps the old data on screen while
  /// loading.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // The error is in `state`; the screen shows it with «تلاش دوباره».
    }
  }

  Future<HomeData> _load() async {
    final cache = ref.read(cacheStoreProvider);
    final requests = await cachedFetch(
      cache: cache,
      key: 'requests:all',
      fetch: () => ref.read(requestsRepositoryProvider).list(),
      toJson: (list) => [for (final r in list) r.toJson()],
      fromJson: (json) => [
        for (final r in json! as List<Object?>)
          GoodsRequest.fromJson(r! as Map<String, Object?>),
      ],
    );
    final counts = await cachedFetch(
      cache: cache,
      key: 'counts:all',
      fetch: () => ref.read(countRepositoryProvider).list(),
      toJson: (list) => [for (final c in list) c.toJson()],
      fromJson: (json) => [
        for (final c in json! as List<Object?>)
          SurpriseCount.fromJson(c! as Map<String, Object?>),
      ],
    );

    return HomeData(
      pendingCount: requests.value.where((r) => r.canDecide).length,
      latest: requests.value.take(3).toList(),
      lastCount: counts.value.firstOrNull,
      cachedAt: requests.cachedAt ?? counts.cachedAt,
    );
  }
}
