import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/storage/cached_fetch.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/stock/application/stock_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:uuid/uuid.dart';

/// All surprise counts, newest first (same cache key as Home).
final countsControllerProvider =
    AsyncNotifierProvider<CountsController, Fetched<List<SurpriseCount>>>(
      CountsController.new,
    );

class CountsController extends AsyncNotifier<Fetched<List<SurpriseCount>>> {
  @override
  Future<Fetched<List<SurpriseCount>>> build() => cachedFetch(
    cache: ref.read(cacheStoreProvider),
    key: 'counts:all',
    fetch: () => ref.read(countRepositoryProvider).list(),
    toJson: (list) => [for (final c in list) c.toJson()],
    fromJson: (json) => [
      for (final c in json! as List<Object?>)
        SurpriseCount.fromJson(c! as Map<String, Object?>),
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

  /// Starts a count now. Throws `ApiException` (e.g. `ConflictException`
  /// when an item is already being counted).
  Future<SurpriseCount> start(List<String> itemCodes) async {
    final count = await ref
        .read(countRepositoryProvider)
        .start(itemCodes: itemCodes, idempotencyKey: const Uuid().v4());
    ref
      ..invalidateSelf()
      ..invalidate(stockControllerProvider)
      ..invalidate(homeControllerProvider);
    return count;
  }
}

/// One count, with results once staff have counted.
final FutureProviderFamily<Fetched<SurpriseCount>, String> countDetailProvider =
    FutureProvider.family(
      (ref, id) => cachedFetch(
        cache: ref.read(cacheStoreProvider),
        key: 'count:$id',
        fetch: () => ref.read(countRepositoryProvider).get(id),
        toJson: (c) => c.toJson(),
        fromJson: (json) =>
            SurpriseCount.fromJson(json! as Map<String, Object?>),
      ),
    );

/// Items picked on the count start screen.
final NotifierProvider<CountSelection, Set<String>> countSelectionProvider =
    NotifierProvider.autoDispose<CountSelection, Set<String>>(
      CountSelection.new,
    );

class CountSelection extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void toggle(String code) => state = state.contains(code)
      ? ({...state}..remove(code))
      : {...state, code};
}
