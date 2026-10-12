import 'dart:io';

import 'package:caspian_owner/core/domain/locations_csv.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/core/domain/place_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final csv = File('assets/mock/caspian_locations.csv').readAsStringSync();
  final locations = parseLocationsCsv(csv);
  final directory = LocationDirectory(
    LocationsSnapshot(
      version: 'test',
      floors: Floors.all,
      locations: locations,
    ),
  );

  group('parseLocationsCsv (real seed file)', () {
    test('reads every row', () {
      expect(locations, hasLength(141));
    });

    test('maps types', () {
      int count(LocationType t) => locations.where((l) => l.type == t).length;
      expect(count(LocationType.plate), 122);
      expect(count(LocationType.named), 4);
      expect(count(LocationType.vertical), 9);
      expect(count(LocationType.general), 1);
      expect(count(LocationType.floorPlace), 5);
    });

    test('keeps quoted merged_with lists intact', () {
      expect(directory.location('35')!.mergedWith, ['35', '36']);
      expect(directory.location('118')!.mergedWith, [
        '118',
        '119',
        '120',
        '121',
      ]);
    });

    test('splits aliases on ;', () {
      expect(directory.location('OFFICE')!.aliases, ['دفتر', 'مدیریت']);
      expect(directory.location('126/1')!.aliases, ['126/1', '126-1']);
    });

    test('vertical and general places need a floor and have none', () {
      final elevator = directory.location('AB-ASD')!;
      expect(elevator.needsFloor, isTrue);
      expect(elevator.floorCode, isNull);
      expect(directory.location('GEN')!.needsFloor, isTrue);
    });

    test('every fixed floor code is a known floor', () {
      for (final l in locations.where((l) => l.floorCode != null)) {
        expect(Floors.byCode(l.floorCode!), isNotNull, reason: l.code);
      }
    });
  });

  group('floors', () {
    test('are in building order P4 → ROOF', () {
      expect(directory.floors.map((f) => f.code), [
        'P4',
        'P3',
        'P2',
        'P1',
        'B',
        'G',
        'F1',
        'F2',
        'F3',
        'ROOF',
      ]);
    });
  });

  group('place labels', () {
    test('plate with its floor', () {
      expect(
        directory.label(
          const ConsumptionPlace(locationCode: '68', floorCode: 'G'),
        ),
        'پلاک ۶۸ · همکف',
      );
    });

    test('elevator with the chosen floor', () {
      expect(
        directory.label(
          const ConsumptionPlace(locationCode: 'AB-ASD', floorCode: 'F2'),
        ),
        'آسانسور باری اسدنژاد · طبقه دوم',
      );
    });

    test('whole-floor place shows only its name', () {
      expect(
        directory.label(
          const ConsumptionPlace(locationCode: 'BAM', floorCode: 'ROOF'),
        ),
        'بام',
      );
    });

    test('unknown codes fall back to the raw code', () {
      expect(
        directory.label(
          const ConsumptionPlace(locationCode: 'X-9', floorCode: 'F1'),
        ),
        'X-۹ · طبقه اول',
      );
    });
  });
}
