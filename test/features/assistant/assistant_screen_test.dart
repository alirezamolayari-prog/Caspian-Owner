import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<TestHarness> pumpAssistant(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(routerProvider)
        .go('/assistant');
    await tester.pumpAndSettle();
    return harness;
  }

  testWidgets('shows history, the demo note and two suggestions', (
    tester,
  ) async {
    await pumpAssistant(tester);
    expect(find.text('دستیار کاسپین'), findsOneWidget);
    expect(find.textContaining('نسخه آزمایشی'), findsOneWidget);
    expect(find.text('این هفته چند درخواست رد شد؟'), findsOneWidget);
    for (final chip in ['خلاصه امروز', 'درخواست‌های این ماه']) {
      expect(find.widgetWithText(ActionChip, chip), findsOneWidget);
    }
    // Surprise counts were removed in v0.2.0.
    expect(find.byType(ActionChip), findsNWidgets(2));
  });

  testWidgets('a suggestion chip asks and the answer appears', (tester) async {
    await pumpAssistant(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'درخواست‌های این ماه'));
    await tester.pumpAndSettle();
    expect(find.textContaining('این ماه ۱۱ درخواست ثبت شده'), findsOneWidget);
  });

  testWidgets('typed questions get the sample fallback answer', (tester) async {
    await pumpAssistant(tester);
    await tester.enterText(find.byType(TextField), 'قیمت مبل چند است؟');
    await tester.tap(find.byTooltip('فرستادن'));
    await tester.pumpAndSettle();
    expect(find.text('قیمت مبل چند است؟'), findsOneWidget);
    expect(find.textContaining('این نسخه آزمایشی است'), findsOneWidget);
  });

  testWidgets('a failed answer can be asked again', (tester) async {
    final h = await pumpAssistant(tester);
    h.backend.scenario = MockScenario.serverError;
    await tester.tap(find.widgetWithText(ActionChip, 'خلاصه امروز'));
    await tester.pumpAndSettle();
    expect(find.text('پاسخ دریافت نشد؛ دوباره بپرسید'), findsOneWidget);

    h.backend.scenario = MockScenario.normal;
    await tester.tap(find.text('پاسخ دریافت نشد؛ دوباره بپرسید'));
    await tester.pumpAndSettle();
    expect(find.textContaining('خلاصه امروز: ۴ درخواست'), findsOneWidget);
    // The retried question appears once, not twice.
    expect(find.text('خلاصه امروز'), findsNWidgets(2), reason: 'chip + bubble');
  });

  testWidgets('history sheet re-asks a previous question', (tester) async {
    await pumpAssistant(tester);
    await tester.tap(find.byTooltip('گفتگوهای قبلی'));
    await tester.pumpAndSettle();
    expect(find.text('گفتگوهای قبلی'), findsWidgets);
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('این هفته چند درخواست رد شد؟'), findsNWidgets(2));
  });

  testWidgets('largest font scale: no overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpAssistant(tester);
    expect(tester.takeException(), isNull);
  });
}
