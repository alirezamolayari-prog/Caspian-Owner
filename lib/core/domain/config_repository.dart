import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/place.dart';

/// App configuration and the locations snapshot
/// (contract: `/v1/config`, `/v1/locations`).
abstract interface class ConfigRepository {
  Future<AppConfig> config();

  /// Floors and consumption locations.
  Future<LocationsSnapshot> locations();
}
