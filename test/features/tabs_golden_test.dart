import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/core/storage/cached_fetch.dart';
import 'package:caspian_owner/features/assistant/application/assistant_controller.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:caspian_owner/features/assistant/presentation/assistant_screen.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/presentation/requests_screen.dart';
import 'package:caspian_owner/features/stock/application/stock_providers.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:caspian_owner/features/stock/presentation/stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../helpers/test_app.dart';

// Fixed data, with times relative to now (+30 s so «۱۰ دقیقه پیش» doesn't
// round down while rendering), so the goldens never depend on the date.

DateTime _ago(Duration d) =>
    DateTime.now().subtract(d + const Duration(seconds: 30));

GoodsRequest _request(
  int n,
  String item,
  double qty,
  String unit,
  String sender,
  Duration ago,
  RequestStatus status, {
  bool escalated = true,
  DecidedBy? by,
}) => GoodsRequest(
  id: 'r-$n',
  number: n,
  createdAt: _ago(ago),
  requester: Person(code: 'p', nameFa: sender),
  place: const ConsumptionPlace(locationCode: '68', floorCode: 'G'),
  lines: [
    RequestLine(
      itemCode: 'i',
      itemNameFa: item,
      qty: qty,
      unitFa: unit,
      stockNow: 10,
      usedLast30d: 5,
    ),
  ],
  status: status,
  escalated: escalated,
  decidedBy: by,
);

final List<GoodsRequest> _requests = [
  _request(
    124,
    'لامپ LED ۱۸ وات',
    24,
    'عدد',
    'امیر رحیمی',
    const Duration(minutes: 10),
    RequestStatus.pending,
  ),
  _request(
    123,
    'کابل برق افشان ۲٫۵',
    30,
    'متر',
    'جواد صالحی',
    const Duration(hours: 1),
    RequestStatus.pending,
  ),
  _request(
    122,
    'مایع شوینده کف',
    6,
    'گالن',
    'مهسا یزدانی',
    const Duration(hours: 2),
    RequestStatus.pending,
  ),
];

class _FixedRequests extends RequestsController {
  @override
  Future<Fetched<List<GoodsRequest>>> build() async => Fetched(_requests);
}

const _stock = [
  StockItem(
    code: 'I-1',
    nameFa: 'لامپ LED ۱۸ وات',
    unitFa: 'عدد',
    qty: 42,
    shelfFa: 'قفسه ۱ – ردیف ۲',
    low: false,
    lockedByCount: false,
  ),
  StockItem(
    code: 'I-2',
    nameFa: 'رنگ پلاستیک سفید',
    unitFa: 'گالن',
    qty: 3,
    shelfFa: 'قفسه ۵ – ردیف ۱',
    low: true,
    lockedByCount: false,
  ),
  StockItem(
    code: 'I-3',
    nameFa: 'سیمان سفید',
    unitFa: 'کیسه',
    qty: null,
    shelfFa: 'انبار پشتی',
    low: false,
    lockedByCount: true,
  ),
  StockItem(
    code: 'I-4',
    nameFa: 'دستکش کار',
    unitFa: 'جفت',
    qty: 60,
    shelfFa: 'قفسه ۶ – ردیف ۲',
    low: false,
    lockedByCount: false,
  ),
];

class _FixedStock extends StockController {
  @override
  Future<Fetched<List<StockItem>>> build() async => const Fetched(_stock);
}

class _FixedAssistant extends AssistantController {
  @override
  Future<AssistantState> build() async => AssistantState(
    messages: [
      AssistantMessage(
        id: '1',
        role: AssistantRole.user,
        text: 'خلاصه امروز',
        at: _ago(const Duration(minutes: 5)),
      ),
      AssistantMessage(
        id: '2',
        role: AssistantRole.assistant,
        text: '۳ درخواست منتظر تأیید شماست و ۴ قلم کالا کم‌موجود است.',
        at: _ago(const Duration(minutes: 5)),
      ),
    ],
  );
}

final List<Override> _overrides = [
  initialSessionProvider.overrideWithValue(testSession()),
  requestsControllerProvider.overrideWith(_FixedRequests.new),
  queuedRequestIdsProvider.overrideWith((ref) => Stream.value(<String>{})),
  stockControllerProvider.overrideWith(_FixedStock.new),
  assistantControllerProvider.overrideWith(_FixedAssistant.new),
];

Widget _screen(Widget screen, ThemeMode mode) => SizedBox(
  width: 400,
  height: 760,
  child: ProviderScope(
    overrides: _overrides,
    child: themedApp(screen, themeMode: mode),
  ),
);

void main() {
  for (final (name, screen) in [
    ('requests', const RequestsScreen()),
    ('stock', const StockScreen()),
    ('assistant', const AssistantScreen()),
  ]) {
    unawaited(
      goldenTest(
        '$name tab in light and dark',
        fileName: '${name}_tab',
        builder: () => GoldenTestGroup(
          children: [
            GoldenTestScenario(
              name: 'light',
              child: _screen(screen, ThemeMode.light),
            ),
            GoldenTestScenario(
              name: 'dark',
              child: _screen(screen, ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }
}
