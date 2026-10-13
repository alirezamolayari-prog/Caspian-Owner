import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/core/domain/place_label.dart';
import 'package:caspian_owner/core/storage/cached_fetch.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;

/// All requests, newest first (same cache key as Home, so both agree).
final requestsControllerProvider =
    AsyncNotifierProvider<RequestsController, Fetched<List<GoodsRequest>>>(
      RequestsController.new,
    );

class RequestsController extends AsyncNotifier<Fetched<List<GoodsRequest>>> {
  @override
  Future<Fetched<List<GoodsRequest>>> build() => cachedFetch(
    cache: ref.read(cacheStoreProvider),
    key: 'requests:all',
    fetch: () => ref.read(requestsRepositoryProvider).list(),
    toJson: (list) => [for (final r in list) r.toJson()],
    fromJson: (json) => [
      for (final r in json! as List<Object?>)
        GoodsRequest.fromJson(r! as Map<String, Object?>),
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

/// One request with its place history.
final FutureProviderFamily<Fetched<GoodsRequest>, String>
requestDetailProvider = FutureProvider.family(
  (ref, id) => cachedFetch(
    cache: ref.read(cacheStoreProvider),
    key: 'request:$id',
    fetch: () => ref.read(requestsRepositoryProvider).get(id),
    toJson: (r) => r.toJson(),
    fromJson: (json) => GoodsRequest.fromJson(json! as Map<String, Object?>),
  ),
);

/// Floors and locations, for labels such as «پلاک ۶۸ – همکف».
final locationDirectoryProvider = FutureProvider<LocationDirectory>((
  ref,
) async {
  final snapshot = await cachedFetch(
    cache: ref.read(cacheStoreProvider),
    key: 'locations',
    fetch: () => ref.read(configRepositoryProvider).locations(),
    toJson: (s) => s.toJson(),
    fromJson: (json) =>
        LocationsSnapshot.fromJson(json! as Map<String, Object?>),
  );
  return LocationDirectory(snapshot.value);
});

/// Request ids with a decision waiting in the offline queue.
final queuedRequestIdsProvider = StreamProvider<Set<String>>(
  (ref) => ref
      .watch(pendingDecisionQueueProvider)
      .watch()
      .map((decisions) => {for (final d in decisions) d.requestId}),
);
