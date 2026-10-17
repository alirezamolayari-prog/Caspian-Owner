import 'dart:convert';

import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/locations_csv.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:flutter/services.dart';

/// A stock movement with the item it belongs to (fixture-only shape).
class MockMovement {
  const new({required this.itemCode, required this.movement});

  final String itemCode;
  final StockMovement movement;
}

/// A canned assistant answer, picked when all [keywords] appear.
class MockAnswer {
  const new({required this.keywords, required this.text});

  final List<String> keywords;
  final String text;
}

/// All mock data, parsed through the contract models (so fixtures that
/// don't match `api/openapi.yaml` fail to load).
class MockFixtures {
  const new({
    required this.me,
    required this.owners,
    required this.persons,
    required this.config,
    required this.locations,
    required this.stock,
    required this.requests,
    required this.movements,
    required this.chats,
    required this.assistantHistory,
    required this.assistantAnswers,
    required this.assistantFallback,
  });

  /// All fixture timestamps are written relative to this moment and are
  /// shifted to "now" on load, so «۱۰ دقیقه پیش» stays true.
  static final DateTime anchor = DateTime.parse('2026-10-12T12:00:00+03:30');

  /// Seed commit of `caspian_locations.csv` in the Warehouse repo.
  static const locationsVersion = 'seed-2f26c614';

  final Owner me;
  final List<Owner> owners;
  final List<Person> persons;
  final AppConfig config;
  final LocationsSnapshot locations;
  final List<StockItem> stock;
  final List<GoodsRequest> requests;
  final List<MockMovement> movements;
  final List<ChatMessage> chats;
  final List<AssistantMessage> assistantHistory;
  final List<MockAnswer> assistantAnswers;
  final String assistantFallback;

  static Future<MockFixtures> load(
    AssetBundle bundle, {
    required DateTime now,
  }) {
    Future<Object?> json(String name) async => _shiftDates(
      jsonDecode(await bundle.loadString('assets/mock/$name')),
      now.difference(anchor),
    );
    return _build(
      json,
      () => bundle.loadString('assets/mock/caspian_locations.csv'),
    );
  }

  static Future<MockFixtures> _build(
    Future<Object?> Function(String name) json,
    Future<String> Function() csv,
  ) async {
    List<Map<String, Object?>> list(Object? value) =>
        (value! as List<Object?>).cast<Map<String, Object?>>();

    final people = (await json('people.json'))! as Map<String, Object?>;
    final owners = list(people['owners']).map(Owner.fromJson).toList();
    final assistant = (await json('assistant.json'))! as Map<String, Object?>;

    return MockFixtures(
      me: owners.firstWhere((o) => o.id == people['me']),
      owners: owners,
      persons: list(people['persons']).map(Person.fromJson).toList(),
      config: AppConfig.fromJson(
        (await json('config.json'))! as Map<String, Object?>,
      ),
      locations: LocationsSnapshot(
        version: locationsVersion,
        floors: Floors.all,
        locations: parseLocationsCsv(await csv()),
      ),
      stock: list(await json('stock.json')).map(StockItem.fromJson).toList(),
      requests: list(await json('requests.json'))
          .map(GoodsRequest.fromJson)
          .toList(),
      movements: [
        for (final m in list(await json('movements.json')))
          MockMovement(
            itemCode: m['item_code']! as String,
            movement: StockMovement.fromJson(m),
          ),
      ],
      chats: list(await json('chats.json')).map(ChatMessage.fromJson).toList(),
      assistantHistory: list(assistant['history'])
          .map(AssistantMessage.fromJson)
          .toList(),
      assistantAnswers: [
        for (final a in list(assistant['answers']))
          MockAnswer(
            keywords: (a['keywords']! as List<Object?>).cast<String>(),
            text: a['text']! as String,
          ),
      ],
      assistantFallback: assistant['fallback']! as String,
    );
  }

  static final _dateTime = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}');

  /// Moves every date-time string in decoded JSON by [shift].
  static Object? _shiftDates(Object? value, Duration shift) => switch (value) {
    final String s when _dateTime.hasMatch(s) => DateTime.parse(
      s,
    ).add(shift).toUtc().toIso8601String(),
    final Map<String, Object?> map => {
      for (final MapEntry(:key, :value) in map.entries)
        key: _shiftDates(value, shift),
    },
    final List<Object?> items => [for (final v in items) _shiftDates(v, shift)],
    _ => value,
  };
}
