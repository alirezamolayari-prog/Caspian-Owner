import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/home/presentation/home_screen.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/test_app.dart';

/// Home with fixed data, so the golden never depends on the date.
class _FixedHome extends HomeController {
  new(this._data);

  final HomeData _data;

  @override
  Future<HomeData> build() async => _data;
}

GoodsRequest _request(
  int number,
  String item,
  double qty,
  String unit,
  String sender,
  Duration ago,
  RequestStatus status,
) => GoodsRequest(
  id: 'r-$number',
  number: number,
  // +30 s so «۱۰ دقیقه پیش» doesn't round down to ۹ by the time it renders.
  createdAt: DateTime.now().subtract(ago + const Duration(seconds: 30)),
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
  escalated: true,
);

HomeData _data() => HomeData(
  pendingCount: 3,
  latest: [
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
      const Duration(hours: 2),
      RequestStatus.approved,
    ),
    _request(
      122,
      'مایع شوینده کف',
      6,
      'گالن',
      'مهسا یزدانی',
      const Duration(hours: 5),
      RequestStatus.rejected,
    ),
  ],
);

Widget _home(ThemeMode mode, {HomeData? data}) => SizedBox(
  width: 400,
  height: 820,
  child: ProviderScope(
    overrides: [
      initialSessionProvider.overrideWithValue(testSession()),
      homeControllerProvider.overrideWith(() => _FixedHome(data ?? _data())),
    ],
    child: themedApp(const HomeScreen(), themeMode: mode),
  ),
);

void main() {
  unawaited(
    goldenTest(
      'home in light and dark, with and without pending requests',
      fileName: 'home',
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(name: 'light', child: _home(ThemeMode.light)),
          GoldenTestScenario(name: 'dark', child: _home(ThemeMode.dark)),
          GoldenTestScenario(
            name: 'nothing pending',
            child: _home(
              ThemeMode.light,
              data: const HomeData(pendingCount: 0, latest: []),
            ),
          ),
        ],
      ),
    ),
  );
}
