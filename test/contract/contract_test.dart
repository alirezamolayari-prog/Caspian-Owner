import 'dart:convert';
import 'dart:io';

import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/mock/mock_notification_source.dart';
import 'package:caspian_owner/features/reports/data/mock_reports_repository.dart';
import 'package:caspian_owner/features/reports/domain/consumption_report.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

import '../helpers/mock_setup.dart';

/// Checks that what the app sends and receives matches `api/openapi.yaml`:
/// no keys outside the schema, every required key present, and enum values
/// spelled exactly as in the contract.
void main() {
  final spec = loadYaml(File('api/openapi.yaml').readAsStringSync()) as YamlMap;
  final schemas = (spec['components'] as YamlMap)['schemas'] as YamlMap;

  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  /// Resolves `$ref`, `oneOf: [X, null]` and `type: [x, 'null']`.
  YamlMap? resolve(Object? schema) {
    if (schema is! YamlMap) return null;
    final ref = schema[r'$ref'];
    if (ref is String) return schemas[ref.split('/').last] as YamlMap;
    final oneOf = schema['oneOf'];
    if (oneOf is YamlList) {
      for (final option in oneOf) {
        final resolved = resolve(option);
        if (resolved != null && resolved['type'] != 'null') return resolved;
      }
    }
    return schema;
  }

  void validate(Object? json, YamlMap schema, String path) {
    if (json == null) return;
    final s = resolve(schema)!;
    final enumValues = s['enum'];
    if (enumValues is YamlList) {
      expect(enumValues, contains(json), reason: '$path: enum value');
    }
    final properties = s['properties'];
    if (json is Map<String, Object?> && properties is YamlMap) {
      for (final key in json.keys) {
        expect(properties.keys, contains(key), reason: '$path: unknown "$key"');
        final property = resolve(properties[key]);
        if (property != null) validate(json[key], property, '$path.$key');
      }
      final required = s['required'];
      if (required is YamlList) {
        for (final key in required) {
          expect(json.keys, contains(key), reason: '$path: missing "$key"');
        }
      }
    }
    final items = s['items'];
    if (json is List<Object?> && items != null) {
      for (final (i, item) in json.indexed) {
        validate(item, resolve(items)!, '$path[$i]');
      }
    }
  }

  void check(String schemaName, Object model, String label) {
    // Round-trip through real JSON text, like the network would.
    final json = jsonDecode(jsonEncode(model));
    validate(json, schemas[schemaName] as YamlMap, label);
  }

  test('owners and persons', () {
    for (final o in fixtures.owners) {
      check('Owner', o.toJson(), o.id);
    }
    for (final p in fixtures.persons) {
      check('Person', p.toJson(), p.code);
    }
  });

  test('config and locations snapshot', () {
    check('AppConfig', fixtures.config.toJson(), 'config');
    check('LocationsSnapshot', fixtures.locations.toJson(), 'locations');
  });

  test('requests', () {
    for (final r in fixtures.requests) {
      check('GoodsRequest', r.toJson(), r.id);
    }
  });

  test('stock items and movements', () {
    for (final s in fixtures.stock) {
      check('StockItem', s.toJson(), s.code);
    }
    for (final m in fixtures.movements) {
      check('StockMovement', m.movement.toJson(), m.itemCode);
    }
  });

  test('chats and assistant', () {
    for (final m in fixtures.chats) {
      check('ChatMessage', m.toJson(), m.id);
    }
    for (final a in fixtures.assistantHistory) {
      check('AssistantMessage', a.toJson(), a.id);
    }
  });

  test('outgoing decision', () {
    const decision = Decision(
      requestId: 'r-124',
      action: DecisionAction.approve,
      idempotencyKey: 'k-1',
      reason: 'ok',
    );
    check('Decision', decision.toJson(), 'decision');
  });

  test('reports and notifications produced by the mock', () async {
    final backend = MockBackend(fixtures, latency: Duration.zero);
    final report = await MockReportsRepository(backend).consumption(
      groupBy: ReportGrouping.floor,
      from: DateTime(2026, 9),
      to: DateTime(2026, 10, 31),
    );
    check('ConsumptionReport', report.toJson(), 'report');

    final batch = await MockNotificationSource(backend)
        .poll(since: DateTime(2026));
    expect(batch.events, isNotEmpty);
    for (final e in batch.events) {
      check('NotificationEvent', e.toJson(), e.id);
    }
  });

  test('fixtures cover the snake_case enum values', () {
    // Enum spellings are validated against the schema above; make sure the
    // multi-word ones are actually exercised.
    final json = jsonEncode([
      for (final r in fixtures.requests) r.toJson(),
      fixtures.locations.toJson(),
    ]);
    expect(json, contains('"important_item"'));
    expect(json, contains('"floor_place"'));
  });
}
