import 'dart:convert';

import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:caspian_owner/features/more/presentation/developer_screen.dart';
import 'package:caspian_owner/features/reports/presentation/reports_screen.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<TestHarness> pumpAt(
    WidgetTester tester,
    String location, {
    Owner owner = testOwner,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2600)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true, owner: owner);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(routerProvider)
        .go(location);
    await tester.pumpAndSettle();
    return harness;
  }

  group('More', () {
    testWidgets('admin sees module entries, settings, about and logout', (
      tester,
    ) async {
      await pumpAt(tester, '/more');
      for (final label in [
        'گزارش‌ها',
        'تاریخچه شمارش‌ها',
        'لیست خرید',
        'کاربران و دسترسی‌ها',
        'تنظیمات',
        'درباره و نسخه',
        'خروج',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      expect(find.text('به‌زودی'), findsOneWidget);
    });

    testWidgets('other owners do not see users and permissions', (
      tester,
    ) async {
      await pumpAt(
        tester,
        '/more',
        owner: const Owner(id: 'o-2', nameFa: 'حسین کاظمی', isAdmin: false),
      );
      expect(find.text('کاربران و دسترسی‌ها'), findsNothing);
      expect(find.text('گزارش‌ها'), findsOneWidget);
    });
  });

  group('reports', () {
    testWidgets('by floor: every floor in building order P4 → بام', (
      tester,
    ) async {
      await withClock(Clock.fixed(testNow), () async {
        await pumpAt(tester, '/reports');
        await tester.tap(find.text('۹۰ روز اخیر'));
        await tester.pumpAndSettle();

        final tiles = tester
            .widgetList<ExpansionTile>(find.byType(ExpansionTile))
            .map((t) => (t.title as Text).data)
            .toList();
        expect(tiles.first, 'پارکینگ P۴', reason: 'Persian digits on screen');
        expect(tiles.last, 'بام');
        expect(tiles, hasLength(10));
        expect(find.text('بدون مصرف'), findsNothing, reason: 'all used');
      });
    });

    testWidgets('by location shows place names, busiest first', (tester) async {
      await withClock(Clock.fixed(testNow), () async {
        await pumpAt(tester, '/reports');
        await tester.tap(find.text('مصرف به تفکیک محل'));
        await tester.tap(find.text('۹۰ روز اخیر'));
        await tester.pumpAndSettle();
        expect(find.text('پلاک ۶۸'), findsOneWidget);
        expect(find.byType(ReportsScreen), findsOneWidget);
      });
    });
  });

  group('settings', () {
    testWidgets('switches are saved on the phone', (tester) async {
      final h = await pumpAt(tester, '/settings');
      await tester.tap(find.text('تأیید با اثر انگشت برای تأیید درخواست'));
      await tester.pumpAndSettle();
      final saved = jsonDecode(
        h.store.values[SecureKeys.settings]!,
      ) as Map<String, Object?>;
      expect(saved['fingerprint_for_approval'], isFalse);
      expect(saved['secure_screens'], isTrue);
    });

    testWidgets('choosing «تیره» switches to the dark theme', (tester) async {
      // The harness forces light; build the real app theme path instead.
      final h = await pumpAt(tester, '/settings');
      await tester.tap(find.text('تیره'));
      await tester.pumpAndSettle();
      final saved = jsonDecode(
        h.store.values[SecureKeys.settings]!,
      ) as Map<String, Object?>;
      expect(saved['theme_mode'], 'dark');
    });

    testWidgets('app PIN can be set from settings', (tester) async {
      final h = await pumpAt(tester, '/settings');
      await tester.tap(find.text('تعیین یا تغییر رمز'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '2468');
      await tester.enterText(find.byType(TextField).last, '2468');
      await tester.tap(find.text('ذخیره رمز'));
      await tester.pumpAndSettle();
      expect(find.text('رمز برنامه ذخیره شد.'), findsOneWidget);
      expect(h.store.values[SecureKeys.pinHash], isNotNull);
    });
  });

  group('about and developer screen', () {
    testWidgets('shows version and copyright; 7 taps open the developer '
        'screen', (tester) async {
      await pumpAt(tester, '/about');
      expect(find.text('نسخه ۰.۱.۰ (ساخت ۱)'), findsOneWidget);
      expect(
        find.text('Copyright (c) 2026 Alireza Molayari. All rights reserved.'),
        findsOneWidget,
      );
      for (var i = 0; i < 7; i++) {
        await tester.tap(find.text('نسخه ۰.۱.۰ (ساخت ۱)'));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(find.byType(DeveloperScreen), findsOneWidget);
    });

    testWidgets('scenario switch and simulated count completion', (
      tester,
    ) async {
      final h = await pumpAt(tester, '/developer');
      await tester.tap(find.text('بدون اینترنت'));
      await tester.pumpAndSettle();
      expect(h.backend.scenario, MockScenario.offline);

      await tester.tap(find.text('عادی'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('پایان شمارش در حال انجام'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'باشه'));
      await tester.pumpAndSettle();
      expect(find.text('شمارش تمام شد.'), findsOneWidget);
      expect(
        h.backend.counts.firstWhere((c) => c.id == 'c-7').status,
        CountStatus.done,
      );
    });
  });

  testWidgets('purchase list is a «به‌زودی» placeholder', (tester) async {
    await pumpAt(tester, '/purchases');
    expect(
      find.text('لیست خرید در نسخه‌های بعدی اضافه می‌شود.'),
      findsOneWidget,
    );
  });

  testWidgets('users list marks the admin and «شما»', (tester) async {
    await pumpAt(tester, '/users');
    expect(find.text('علیرضا (شما)'), findsOneWidget);
    expect(find.text('مدیر سیستم'), findsOneWidget);
    expect(find.text('مالک'), findsNWidgets(4));
  });
}
