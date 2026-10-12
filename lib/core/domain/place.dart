import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// A floor of building Phase 2 (contract: `Floor`).
@freezed
abstract class Floor with _$Floor {
  const factory({
    required String code,
    required String nameFa,

    /// Building order, bottom to top: P4 = 0 … ROOF = 9.
    required int sortOrder,
  }) = _Floor;

  factory fromJson(Map<String, Object?> json) => _$FloorFromJson(json);
}

/// The floors of Phase 2 in building order (P4 → بام).
/// Display names follow the UI spec («همکف», «طبقه دوم»).
abstract final class Floors {
  static const all = <Floor>[
    Floor(code: 'P4', nameFa: 'پارکینگ P4', sortOrder: 0),
    Floor(code: 'P3', nameFa: 'پارکینگ P3', sortOrder: 1),
    Floor(code: 'P2', nameFa: 'پارکینگ P2', sortOrder: 2),
    Floor(code: 'P1', nameFa: 'پارکینگ P1', sortOrder: 3),
    Floor(code: 'B', nameFa: 'زیرهمکف', sortOrder: 4),
    Floor(code: 'G', nameFa: 'همکف', sortOrder: 5),
    Floor(code: 'F1', nameFa: 'طبقه اول', sortOrder: 6),
    Floor(code: 'F2', nameFa: 'طبقه دوم', sortOrder: 7),
    Floor(code: 'F3', nameFa: 'طبقه سوم', sortOrder: 8),
    Floor(code: 'ROOF', nameFa: 'بام', sortOrder: 9),
  ];

  static Floor? byCode(String code) {
    for (final floor in all) {
      if (floor.code == code) return floor;
    }
    return null;
  }
}

@JsonEnum(fieldRename: FieldRename.snake)
enum LocationType {
  /// A shop plate («پلاک ۶۸»), fixed floor.
  plate,

  /// A named place (café, office), fixed floor.
  named,

  /// Stairs and elevators spanning floors; the floor must be picked.
  vertical,

  /// Common areas of a floor; the floor must be picked.
  general,

  /// A whole floor used as a place (parking levels, roof).
  floorPlace,
}

/// A consumption location (contract: `Location`).
@freezed
abstract class Location with _$Location {
  const factory({
    required String code,
    required String nameFa,
    required LocationType type,
    required bool needsFloor,
    required bool isActive,
    String? floorCode,
    @Default(<String>[]) List<String> aliases,
    @Default(<String>[]) List<String> mergedWith,
  }) = _Location;

  factory fromJson(Map<String, Object?> json) => _$LocationFromJson(json);
}

/// Floors and locations as one versioned snapshot (contract).
@freezed
abstract class LocationsSnapshot with _$LocationsSnapshot {
  const factory({
    required String version,
    required List<Floor> floors,
    required List<Location> locations,
  }) = _LocationsSnapshot;

  factory fromJson(Map<String, Object?> json) =>
      _$LocationsSnapshotFromJson(json);
}

/// Where goods are used: always a location code plus a floor code,
/// never internal ids (contract: `ConsumptionPlace`).
@freezed
abstract class ConsumptionPlace with _$ConsumptionPlace {
  const factory({
    required String locationCode,
    required String floorCode,
    String? usageNote,
  }) = _ConsumptionPlace;

  factory fromJson(Map<String, Object?> json) =>
      _$ConsumptionPlaceFromJson(json);
}
