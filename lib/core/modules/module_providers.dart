import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:caspian_owner/core/storage/cached_fetch.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/features/warehouse_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modules compiled into the app. The server decides which are active.
final moduleRegistryProvider = Provider<ModuleRegistry>(
  (ref) => ModuleRegistry([
    const WarehouseModule(),
    // Other Caspian apps, announced on the hub until they are built.
    ComingSoonModule(
      id: 'parking',
      title: (c) => AppLocalizations.of(c).moduleParking,
      subtitle: (c) => AppLocalizations.of(c).moduleParkingSubtitle,
      icon: AppIcons.parking,
    ),
    ComingSoonModule(
      id: 'crm',
      title: (c) => AppLocalizations.of(c).moduleCrm,
      subtitle: (c) => AppLocalizations.of(c).moduleCrmSubtitle,
      icon: AppIcons.crm,
    ),
    ComingSoonModule(
      id: 'services',
      title: (c) => AppLocalizations.of(c).moduleServices,
      subtitle: (c) => AppLocalizations.of(c).moduleServicesSubtitle,
      icon: AppIcons.services,
    ),
  ]),
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
      upcomingModules: ['parking', 'crm', 'services'],
      minSupportedBuild: 0,
    );
  }
});
