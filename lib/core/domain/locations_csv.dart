import 'package:caspian_owner/core/domain/place.dart';
import 'package:csv/csv.dart';

/// Parses `caspian_locations.csv` from the Caspian Warehouse repo.
///
/// Columns: code, name, type, floor, floor_code, needs_floor, aliases,
/// merged_with, note. `aliases` is `;`-separated; `merged_with` is
/// `,`-separated inside quotes. Delimiter auto-detection is off because the
/// `;` in aliases could fool it.
List<Location> parseLocationsCsv(String input) {
  final rows = Csv(autoDetect: false).decode(input);
  if (rows.isEmpty) return const [];

  final header = rows.first.map((cell) => '$cell'.trim()).toList();
  int col(String name) {
    final index = header.indexOf(name);
    if (index < 0) {
      throw FormatException('Missing column "$name" in locations CSV');
    }
    return index;
  }

  final code = col('code');
  final name = col('name');
  final type = col('type');
  final floorCode = col('floor_code');
  final needsFloor = col('needs_floor');
  final aliases = col('aliases');
  final mergedWith = col('merged_with');

  List<String> split(String value, String separator) => value
      .split(separator)
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();

  return [
    for (final row in rows.skip(1))
      if (row.length >= header.length && '${row[code]}'.trim().isNotEmpty)
        Location(
          code: '${row[code]}'.trim(),
          nameFa: '${row[name]}'.trim(),
          type: _type('${row[type]}'.trim()),
          floorCode: '${row[floorCode]}'.trim().isEmpty
              ? null
              : '${row[floorCode]}'.trim(),
          needsFloor: '${row[needsFloor]}'.trim() == 'yes',
          aliases: split('${row[aliases]}', ';'),
          mergedWith: split('${row[mergedWith]}', ','),
          isActive: true,
        ),
  ];
}

LocationType _type(String value) => switch (value) {
  'plate' => LocationType.plate,
  'named' => LocationType.named,
  'vertical' => LocationType.vertical,
  'general' => LocationType.general,
  'floor_place' => LocationType.floorPlace,
  _ => throw FormatException('Unknown location type "$value"'),
};
