import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/features/auth/application/account_flow.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/mock_setup.dart';
import '../helpers/test_app.dart';

/// Flutter's accessibility guidelines (tap targets, labels, contrast) on the
/// main screens, plus the largest system font on the busiest screen.
void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<void> pumpAt(
    WidgetTester tester,
    String location, {
    double textScale = 1,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(routerProvider)
        .go(location);
    await tester.pumpAndSettle();
  }

  for (final location in [
    '/',
    '/warehouse',
    '/m/parking',
    '/requests',
    '/requests/r-124',
    '/requests/r-119',
    '/requests/r-121/chat',
    '/stock',
    '/assistant',
    '/more',
    '/notifications',
    '/settings',
    '/about',
    '/users',
  ]) {
    testWidgets('$location meets the accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpAt(tester, location);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }

  /// Account pages, signed out. Flow steps get a flow started first.
  Future<void> pumpSignedOut(
    WidgetTester tester,
    String location, {
    double textScale = 1,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final harness = TestHarness.create(fixtures);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    if (location == '/otp' || location == '/new-password') {
      final flow = container.read(accountFlowProvider.notifier);
      await tester.runAsync(
        () => flow.start(purpose: OtpPurpose.register, mobile: '09123456789'),
      );
      if (location == '/new-password') {
        await tester.runAsync(() => flow.verify('123456'));
      }
    }
    container.read(routerProvider).go(location);
    // Short of pumpAndSettle: the code page's countdown keeps ticking.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  for (final location in [
    '/login',
    '/register',
    '/forgot-password',
    '/otp',
    '/new-password',
    '/registered',
    '/account/pending',
    '/account/rejected',
    '/account/disabled',
  ]) {
    testWidgets('$location meets the accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpSignedOut(tester, location);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });

    testWidgets('$location works at the largest font size', (tester) async {
      await pumpSignedOut(tester, location, textScale: 2);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the fingerprint offer meets the accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpSignedOut(tester, '/login');
    await tester.enterText(find.byType(TextField).at(0), 'owner1');
    await tester.enterText(find.byType(TextField).at(1), '11111');
    await tester.tap(find.text('ورود'));
    await tester.pumpAndSettle();
    expect(find.text('بله، فعال شود'), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });

  testWidgets('the send-back sheet meets the accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpAt(tester, '/requests/r-119');
    await tester.tap(find.text('ویرایش و برگرداندن'));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });

  testWidgets('the chat page and send-back sheet work at the largest font', (
    tester,
  ) async {
    await pumpAt(tester, '/requests/r-121/chat', textScale: 2);
    expect(tester.takeException(), isNull);
    await pumpAt(tester, '/requests/r-119', textScale: 2);
    await tester.tap(find.text('ویرایش و برگرداندن'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('ارسال برای اصلاح'), findsOneWidget);
  });

  testWidgets('request detail works at the largest font size', (tester) async {
    await pumpAt(tester, '/requests/r-124', textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('تأیید'), findsOneWidget);
    expect(find.text('رد کردن'), findsOneWidget);
  });
}
