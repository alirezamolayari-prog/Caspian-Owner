import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';

/// Looks up locations and floors and builds display labels such as
/// «پلاک ۶۸ · همکف» or «آسانسور باری اسدنژاد · طبقه دوم».
class LocationDirectory {
  new(LocationsSnapshot snapshot)
    : _locations = {for (final l in snapshot.locations) l.code: l},
      _floors = {for (final f in snapshot.floors) f.code: f},
      floors = [...snapshot.floors]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  final Map<String, Location> _locations;
  final Map<String, Floor> _floors;

  /// Floors in building order (P4 → بام).
  final List<Floor> floors;

  Location? location(String code) => _locations[code];

  Floor? floor(String code) => _floors[code] ?? Floors.byCode(code);

  /// Display label of a place. A whole-floor place (parking, roof) shows
  /// only its name; everything else shows «name · floor». Unknown codes
  /// fall back to the raw code so nothing is hidden.
  String label(ConsumptionPlace place) {
    final location = _locations[place.locationCode];
    final floorName = floor(place.floorCode)?.nameFa ?? place.floorCode;
    final name = location?.nameFa ?? place.locationCode;
    if (location?.type == LocationType.floorPlace) {
      return toPersianDigits(name);
    }
    return toPersianDigits('$name · $floorName');
  }

  /// Sort key for building order; unknown floors go last.
  int floorOrder(String floorCode) => floor(floorCode)?.sortOrder ?? 1 << 20;
}
