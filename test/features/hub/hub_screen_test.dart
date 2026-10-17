import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/notifications/notification_providers.dart';
import 'package:caspian_owner/features/home/presentation/home_screen.dart';
import 'package:caspian_owner/features/hub/presentation/hub_screen.dart';
import 'package:caspian_owner/features/hub/presentation/module_placeholder_screen.dart';
import 'package:caspian_owner/features/more/presentation/more_screen.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:caspian_owner/features/requests/presentation/requests_screen.dart';
import 'package:caspian_owner/features/stock/presentation/stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<void> pumpApp(
    WidgetTester tester, {
    List<Override> extra = const [],
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app(extra: extra));
    await tester.pumpAndSettle();
  }

  testWidgets('the app opens on the hub with four modules', (tester) async {
    await pumpApp(tester);
    expect(find.byType(HubScreen), findsOneWidget);
    for (final title in ['انبار', 'پارکینگ', 'CRM', 'خدمات کاسپین']) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    // Warehouse: pending requests on its tile; the rest are coming soon.
    expect(find.text('۴ منتظر'), findsOneWidget);
    expect(find.text('به‌زودی'), findsNWidgets(3));
  });

  testWidgets('«انبار» opens the warehouse with its own four tabs', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('انبار'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    // The app bar names the module and leads back to the hub.
    expect(find.text('انبار'), findsOneWidget);
    await tester.tap(find.byTooltip('همه بخش‌های کاسپین'));
    await tester.pumpAndSettle();
    expect(find.byType(HubScreen), findsOneWidget);
  });

  testWidgets('Android Back: other tab → first tab → hub', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('انبار'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('موجودی'));
    await tester.pumpAndSettle();
    expect(find.byType(StockScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(HubScreen), findsOneWidget);
  });

  testWidgets('a coming-soon module opens a simple placeholder', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('پارکینگ'));
    await tester.pumpAndSettle();
    expect(find.byType(ModulePlaceholderScreen), findsOneWidget);
    expect(find.text('پارکینگ به‌زودی'), findsOneWidget);
    expect(find.textContaining('تأییدها، گزارش کلی و گفتگو'), findsOneWidget);
  });

  testWidgets('the avatar opens More from the hub', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('حساب و گزینه‌های بیشتر'));
    await tester.pumpAndSettle();
    expect(find.byType(MoreScreen), findsOneWidget);
  });

  testWidgets('a notification opens its request inside the warehouse; back '
      'goes to the requests tab', (tester) async {
    await pumpApp(
      tester,
      extra: [
        launchNotificationTargetProvider.overrideWithValue('/requests/r-124'),
      ],
    );
    expect(find.byType(RequestDetailScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(RequestsScreen), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
  });
}
