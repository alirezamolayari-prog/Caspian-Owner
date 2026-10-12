import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/config_repository.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';

class MockConfigRepository implements ConfigRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<AppConfig> config() => _backend.call(() => _backend.fixtures.config);

  @override
  Future<LocationsSnapshot> locations() =>
      _backend.call(() => _backend.fixtures.locations);
}
