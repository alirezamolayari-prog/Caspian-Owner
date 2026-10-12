import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:caspian_owner/core/storage/cached_fetch.dart';
import 'package:caspian_owner/features/warehouse_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modules compiled into the app. The server decides which are active.
final moduleRegistryProvider = Provider<ModuleRegistry>(
  (ref) => const ModuleRegistry([WarehouseModule()]),
);

/// Feature flags and modules for this owner (`/v1/config`), cached.
/// Offline without a cached copy, the warehouse module stays on.
final appConfigProvider = FutureProvider<AppConfig>((ref) async {
  try {
    final fetched = await cachedFetch(
      cache: ref.read(cacheStoreProvider),
      key: 'config',
      fetch: () => ref.read(configRepositoryProvider).config(),
      toJson: (c) => c.toJson(),
      fromJson: (json) => AppConfig.fromJson(json! as Map<String, Object?>),
    );
    return fetched.value;
  } on Object {
    return const AppConfig(
      featureFlags: [],
      modules: ['warehouse'],
      minSupportedBuild: 0,
    );
  }
});
