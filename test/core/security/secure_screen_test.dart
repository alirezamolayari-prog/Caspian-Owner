import 'dart:async';

import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/secure_screen_scope.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

/// FLAG_SECURE is one switch for the whole window: on while at least one
/// protected screen is really shown and the setting is on.
void main() {
  group('controller', () {
    test('secure only while a scope is visible and the setting is on', () {
      final screen = FakeSecureScreen();
      final c = SecureScreenController(screen, enabled: true);
      final a = Object();
      final b = Object();

      c.update(a, visible: true);
      expect(screen.secure, isTrue);
      c
        ..update(b, visible: true)
        ..remove(b);
      expect(screen.secure, isTrue, reason: 'a is still shown');
      c.update(a, visible: false);
      expect(screen.secure, isFalse, reason: 'a is hidden');
      c
        ..update(a, visible: true)
        ..enabled = false;
      expect(screen.secure, isFalse, reason: 'the owner turned it off');
      c.enabled = true;
      expect(screen.secure, isTrue);
      c.remove(a);
      expect(screen.secure, isFalse);
    });
  });

  group('in the app', () {
    late MockFixtures fixtures;
    setUpAll(() async => fixtures = await loadTestFixtures());

    Future<(TestHarness, GoRouter)> pumpApp(WidgetTester tester) async {
      tester.view
        ..physicalSize = const Size(1080, 2400)
        ..devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      final harness = TestHarness.create(fixtures, signedIn: true);
      addTearDown(harness.database.close);
      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      final router = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      ).read(routerProvider);
      return (harness, router);
    }

    testWidgets('Home is not protected; Stock is', (tester) async {
      final (h, router) = await pumpApp(tester);
      expect(h.secureScreen.secure, isNot(isTrue));
      router.go('/stock');
      await tester.pumpAndSettle();
      expect(h.secureScreen.secure, isTrue);
    });

    testWidgets('a hidden tab does not protect the shown one', (tester) async {
      final (h, router) = await pumpApp(tester);
      router.go('/stock');
      await tester.pumpAndSettle();
      // Stock stays alive in its branch, but Home is shown now.
      router.go('/');
      await tester.pumpAndSettle();
      expect(h.secureScreen.secure, isFalse);
    });

    testWidgets('Settings over the Stock tab is not black', (tester) async {
      final (h, router) = await pumpApp(tester);
      router.go('/stock');
      await tester.pumpAndSettle();
      expect(h.secureScreen.secure, isTrue);
      // push() completes only when the page closes.
      unawaited(router.push<void>('/settings'));
      await tester.pumpAndSettle();
      expect(h.secureScreen.secure, isFalse);
    });

    testWidgets('closing a request keeps the requests list protected', (
      tester,
    ) async {
      final (h, router) = await pumpApp(tester);
      router.go('/requests');
      await tester.pumpAndSettle();
      unawaited(router.push<void>('/requests/r-124'));
      await tester.pumpAndSettle();
      expect(h.secureScreen.secure, isTrue);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('درخواست ۱۲۴'), findsNothing, reason: 'detail closed');
      expect(h.secureScreen.secure, isTrue);
    });

    testWidgets('turning the setting off releases the screen at once', (
      tester,
    ) async {
      final (h, router) = await pumpApp(tester);
      router.go('/stock');
      await tester.pumpAndSettle();
      ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
          .read(settingsControllerProvider.notifier)
          .setSecureScreens(enabled: false);
      await tester.pumpAndSettle();
      expect(h.secureScreen.secure, isFalse);
    });
  });
}
