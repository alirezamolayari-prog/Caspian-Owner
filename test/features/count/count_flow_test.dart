import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:caspian_owner/features/count/presentation/count_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<TestHarness> pumpAt(WidgetTester tester, String location) async {
    tester.view
      ..physicalSize = const Size(1080, 4800)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(routerProvider)
        .go(location);
    await tester.pumpAndSettle();
    return harness;
  }

  testWidgets('pick items, confirm, the count starts and hides stock', (
    tester,
  ) async {
    final h = await pumpAt(tester, '/counts/new');
    expect(find.text('انتخاب اقلام برای شمارش'), findsOneWidget);

    // Items already being counted can't be picked.
    final cement = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'سیمان سفید'),
    );
    expect(cement.onChanged, isNull);

    await tester.tap(find.text('لامپ LED ۱۸ وات'));
    await tester.tap(find.text('دستکش کار'));
    await tester.pump();
    await tester.tap(find.text('ادامه (۲ قلم)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('قفل و موجودی‌شان مخفی می‌شود'), findsOneWidget);

    await tester.tap(find.text('شروع شمارش'));
    await tester.pumpAndSettle();

    expect(find.byType(CountDetailScreen), findsOneWidget);
    expect(find.text('شمارش در حال انجام است'), findsOneWidget);
    final started = h.backend.counts.first;
    expect(started.status, CountStatus.running);
    expect(started.items.map((i) => i.itemCode), ['I-1001', 'I-1006']);
    expect(h.backend.lockedItemCodes, containsAll(['I-1001', 'I-1006']));
  });

  testWidgets('cancel on the confirm sheet starts nothing', (tester) async {
    final h = await pumpAt(tester, '/counts/new');
    await tester.tap(find.text('لامپ LED ۱۸ وات'));
    await tester.pump();
    await tester.tap(find.text('ادامه (۱ قلم)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('انصراف'));
    await tester.pumpAndSettle();
    expect(h.backend.counts, hasLength(2));
  });

  testWidgets('results: system vs counted, difference in words, entries', (
    tester,
  ) async {
    await pumpAt(tester, '/counts/c-6');
    expect(find.text('نتیجه شمارش'), findsOneWidget);
    // Paint: 7 in the system, 5 counted.
    expect(find.text('۷ گالن'), findsOneWidget);
    expect(find.text('۵ گالن'), findsOneWidget);
    expect(find.text('۲ گالن کمتر'), findsOneWidget);
    // Filter matches.
    expect(find.text('درست است'), findsOneWidget);
    // Every entered number, including a correction.
    expect(find.textContaining('۴ – سعید مرادی'), findsOneWidget);
    expect(find.textContaining('۳ – سعید مرادی'), findsOneWidget);
    expect(find.textContaining('به‌طور خودکار اصلاح نمی‌شود'), findsOneWidget);
  });

  testWidgets('a running count explains that stock is hidden', (tester) async {
    await pumpAt(tester, '/counts/c-7');
    expect(find.text('شمارش در حال انجام است'), findsOneWidget);
    expect(find.textContaining('حسین کاظمی'), findsOneWidget);
    expect(find.text('• سیمان سفید'), findsOneWidget);
  });

  testWidgets('history lists counts with status and discrepancies', (
    tester,
  ) async {
    await pumpAt(tester, '/counts');
    expect(find.text('تاریخچه شمارش‌ها'), findsOneWidget);
    expect(find.text('در حال انجام'), findsOneWidget);
    expect(find.text('تمام شد'), findsOneWidget);
    expect(find.textContaining('۲ مغایرت'), findsOneWidget);

    await tester.tap(find.text('تمام شد'));
    await tester.pumpAndSettle();
    expect(find.text('نتیجه شمارش'), findsOneWidget);
  });

  testWidgets('largest font scale: no overflow on the results', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpAt(tester, '/counts/c-6');
    expect(tester.takeException(), isNull);
  });
}
