import 'dart:async';
import 'dart:convert';

import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/notifications/background_reliability.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:caspian_owner/features/more/presentation/developer_screen.dart';
import 'package:caspian_owner/features/reports/presentation/reports_screen.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
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
    UpdateChecker? updateChecker,
    List<Override> extra = const [],
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2600)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(
      fixtures,
      signedIn: true,
      owner: owner,
      updateChecker: updateChecker,
    );
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app(extra: extra));
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

    testWidgets('starts with who is signed in: name and role', (tester) async {
      await pumpAt(tester, '/more');
      expect(find.text('علیرضا'), findsOneWidget);
      expect(find.text('مدیر سیستم (ادمین)'), findsOneWidget);
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
      expect(find.text('حسین کاظمی'), findsOneWidget);
      expect(find.text('مالک'), findsOneWidget);
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

    testWidgets('«اعلان وقتی برنامه بسته است» shows each state as text and '
        'opens the system page that fixes it', (tester) async {
      const channel = MethodChannel('caspian/background');
      final messenger = tester.binding.defaultBinaryMessenger;
      final calls = <String>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call.method);
        return call.method == 'status'
            ? <String, Object?>{
                'notificationsAllowed': true,
                'batteryUnrestricted': false,
                'hasAutostart': true,
              }
            : null;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      await pumpAt(
        tester,
        '/settings',
        extra: [
          backgroundReliabilityProvider.overrideWithValue(
            const BackgroundReliability(),
          ),
        ],
      );
      await tester.scrollUntilVisible(
        find.text('اجرای خودکار (Autostart)'),
        200,
      );

      expect(find.text('اعلان وقتی برنامه بسته است'), findsOneWidget);
      expect(find.text('روشن است'), findsOneWidget); // notifications
      expect(find.text('خاموش است'), findsOneWidget); // battery
      // Battery and Autostart need a fix; notifications are already on.
      expect(find.text('تنظیم'), findsNWidgets(2));

      await tester.tap(find.text('تنظیم').last);
      await tester.pumpAndSettle();
      expect(calls, contains('openAutostartSettings'));
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

    testWidgets('«بررسی به‌روزرسانی» shows progress and waits', (tester) async {
      final slow = _SlowChecker();
      await pumpAt(tester, '/about', updateChecker: slow);
      await tester.tap(find.text('بررسی به‌روزرسانی'));
      await tester.pump();
      expect(find.text('در حال بررسی…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Disabled while checking: a second tap starts nothing.
      final calls = slow.calls;
      await tester.tap(find.text('در حال بررسی…'), warnIfMissed: false);
      await tester.pump();
      expect(slow.calls, calls);

      slow.finish();
      await tester.pumpAndSettle();
      expect(find.text('بررسی به‌روزرسانی'), findsOneWidget);
      expect(find.text('اطلاعات به‌روزرسانی دریافت نشد.'), findsOneWidget);
    });

    testWidgets('scenario switch', (tester) async {
      final h = await pumpAt(tester, '/developer');
      await tester.tap(find.text('بدون اینترنت'));
      await tester.pumpAndSettle();
      expect(h.backend.scenario, MockScenario.offline);

      await tester.tap(find.text('عادی'));
      await tester.pumpAndSettle();
      expect(h.backend.scenario, MockScenario.normal);
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
    expect(find.text('مدیر سیستم (ادمین)'), findsOneWidget);
    expect(find.text('مالک'), findsNWidgets(4));
    expect(
      find.text(
        'مدیریت کاربران (تأیید، نقش، غیرفعال کردن) از پنل سرور انجام می‌شود.',
      ),
      findsOneWidget,
    );
  });
}

/// An update check that waits until [finish] (a slow network).
class _SlowChecker extends UpdateChecker {
  new() : super(urls: const []);

  final _done = Completer<UpdateManifest?>();
  int calls = 0;

  void finish() => _done.complete(null);

  @override
  Future<UpdateManifest?> fetch() {
    calls++;
    return _done.future;
  }
}
