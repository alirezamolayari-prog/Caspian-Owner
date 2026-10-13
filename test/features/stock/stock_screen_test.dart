import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/features/count/presentation/count_start_screen.dart';
import 'package:caspian_owner/features/stock/presentation/stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<TestHarness> pumpStock(WidgetTester tester) async {
    // Tall enough to show all 18 items.
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
        .go('/stock');
    await tester.pumpAndSettle();
    return harness;
  }

  Finder rowsOf(String text) =>
      find.descendant(of: find.byType(StockScreen), matching: find.text(text));

  testWidgets('lists items with quantity, «کم» and hidden counts', (
    tester,
  ) async {
    await pumpStock(tester);
    expect(find.text('موجودی انبار'), findsOneWidget);
    expect(find.text('لامپ LED ۱۸ وات'), findsOneWidget);
    expect(find.text('۴۲ عدد'), findsOneWidget);
    expect(find.text('قفسه ۱ – ردیف ۲'), findsOneWidget);
    expect(rowsOf('کم'), findsNWidgets(4));
    expect(rowsOf('در حال شمارش'), findsNWidgets(2));
  });

  testWidgets('search by name, by Persian or Latin digits, and clear', (
    tester,
  ) async {
    await pumpStock(tester);
    await tester.enterText(find.byType(TextField), 'لامپ');
    await tester.pump();
    expect(find.text('لامپ LED ۱۸ وات'), findsOneWidget);
    expect(find.text('لامپ مهتابی ۳۶ وات'), findsOneWidget);
    expect(find.text('سیمان سفید'), findsNothing);

    await tester.enterText(find.byType(TextField), 'مهتابی ۳۶');
    await tester.pump();
    expect(find.text('لامپ مهتابی ۳۶ وات'), findsOneWidget);
    expect(find.text('لامپ LED ۱۸ وات'), findsNothing);

    await tester.enterText(find.byType(TextField), 'مهتابی 36');
    await tester.pump();
    expect(find.text('لامپ مهتابی ۳۶ وات'), findsOneWidget);

    await tester.tap(find.byTooltip('پاک کردن جستجو'));
    await tester.pump();
    expect(find.text('سیمان سفید'), findsOneWidget);
  });

  testWidgets('no match says so', (tester) async {
    await pumpStock(tester);
    await tester.enterText(find.byType(TextField), 'یخچال');
    await tester.pump();
    expect(find.text('کالایی با این نام پیدا نشد.'), findsOneWidget);
  });

  testWidgets('«کم‌موجود» shows only low items', (tester) async {
    await pumpStock(tester);
    await tester.tap(find.text('کم‌موجود'));
    await tester.pump();
    expect(rowsOf('کم'), findsNWidgets(4));
    expect(find.text('لامپ LED ۱۸ وات'), findsNothing);
    expect(find.text('رنگ پلاستیک سفید'), findsOneWidget);
  });

  testWidgets('tapping an item shows its in/out history', (tester) async {
    await pumpStock(tester);
    await tester.tap(find.text('رنگ پلاستیک سفید'));
    await tester.pumpAndSettle();
    expect(find.text('ورود و خروج اخیر'), findsOneWidget);
    expect(find.text('خروج – ۲ گالن'), findsNWidgets(2));
    expect(find.text('اصلاح موجودی (کم شد) – ۲ گالن'), findsOneWidget);
    expect(find.text('راهروی عمومی طبقه – طبقه اول'), findsNothing);
    expect(find.text('مشاعات عمومی طبقه – طبقه اول'), findsOneWidget);
  });

  testWidgets('a counted item explains why its history is hidden', (
    tester,
  ) async {
    await pumpStock(tester);
    await tester.tap(find.text('سیمان سفید'));
    await tester.pumpAndSettle();
    expect(
      find.text('تا پایان شمارش غافلگیرانه، موجودی و گردش این کالا مخفی است.'),
      findsOneWidget,
    );
  });

  testWidgets('offline after a good load shows saved stock', (tester) async {
    final h = await pumpStock(tester);
    h.backend.scenario = MockScenario.offline;
    await tester.fling(
      find.text('لامپ LED ۱۸ وات'),
      const Offset(0, 500),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.byType(StaleNotice), findsOneWidget);
    expect(find.text('۴۲ عدد'), findsOneWidget);
  });

  testWidgets('«شمارش غافلگیرانه» opens the count start', (tester) async {
    await pumpStock(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('شمارش غافلگیرانه'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CountStartScreen), findsOneWidget);
  });

  testWidgets('largest font scale: no overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpStock(tester);
    expect(tester.takeException(), isNull);
  });
}
