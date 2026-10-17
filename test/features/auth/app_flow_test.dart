import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/presentation/lock_screen.dart';
import 'package:caspian_owner/features/auth/presentation/login_screen.dart';
import 'package:caspian_owner/features/home/presentation/home_screen.dart';
import 'package:caspian_owner/features/hub/presentation/hub_screen.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:caspian_owner/features/stock/presentation/stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  // Real file I/O never completes inside testWidgets, so load once here.
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<TestHarness> pumpApp(
    WidgetTester tester, {
    bool signedIn = false,
  }) async {
    final harness = TestHarness.create(fixtures, signedIn: signedIn);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    return harness;
  }

  testWidgets('login with phone and test code leads to the hub', (
    tester,
  ) async {
    final harness = await pumpApp(tester);
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField), '۰۹۱۲۱۲۳۴۵۶۷');
    await tester.tap(find.text('دریافت کد'));
    await tester.pumpAndSettle();
    expect(find.textContaining('کد ۵ رقمی'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '۱۱۱۱۱');
    await tester.tap(find.text('ورود'));
    await tester.pumpAndSettle();

    expect(find.byType(HubScreen), findsOneWidget);
    expect(find.text('سلام علیرضا'), findsOneWidget);
    // Signing in with a code doesn't ask for the fingerprint again.
    expect(find.byType(LockScreen), findsNothing);
    expect(harness.store.values[SecureKeys.session], isNotNull);
  });

  testWidgets('a wrong code shows the server message', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byType(TextField), '09121234567');
    await tester.tap(find.text('دریافت کد'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '22222');
    await tester.tap(find.text('ورود'));
    await tester.pumpAndSettle();

    expect(find.text('کد واردشده درست نیست.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('an invalid phone number is explained', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byType(TextField), '0912');
    await tester.tap(find.text('دریافت کد'));
    await tester.pumpAndSettle();
    expect(
      find.text('شماره موبایل باید ۱۱ رقم باشد و با ۰۹ شروع شود.'),
      findsOneWidget,
    );
  });

  testWidgets('cold start: the fingerprint prompt opens by itself', (
    tester,
  ) async {
    final harness = await pumpApp(tester, signedIn: true);
    expect(harness.authenticator.prompts, 1);
    expect(find.byType(HubScreen), findsOneWidget);
  });

  testWidgets('a deep link while locked opens after unlocking', (tester) async {
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    harness.authenticator.succeeds = false;
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.byType(LockScreen), findsOneWidget);
    expect(find.text('برنامه قفل است'), findsOneWidget);

    // Open a notification link while locked.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LockScreen)),
    );
    container.read(routerProvider).go('/requests/r-124');
    await tester.pumpAndSettle();
    expect(find.byType(LockScreen), findsOneWidget);

    harness.authenticator.succeeds = true;
    await tester.tap(find.text('باز کردن با اثر انگشت'));
    await tester.pumpAndSettle();

    final detail = tester.widget<RequestDetailScreen>(
      find.byType(RequestDetailScreen),
    );
    expect(detail.requestId, 'r-124');
  });

  testWidgets('tabs switch and the bottom bar has four entries', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: true);
    await tester.tap(find.text('انبار'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(4));

    await tester.tap(find.text('موجودی'));
    await tester.pumpAndSettle();
    expect(find.byType(StockScreen), findsOneWidget);
    expect(find.text('موجودی انبار'), findsOneWidget);
  });

  testWidgets('logout asks first, then returns to login', (tester) async {
    final harness = await pumpApp(tester, signedIn: true);
    await tester.tap(find.byTooltip('حساب و گزینه‌های بیشتر'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('خروج'));
    await tester.pumpAndSettle();
    expect(find.text('از حساب خارج می‌شوید؟'), findsOneWidget);

    await tester.tap(find.text('خروج').last);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(harness.store.values[SecureKeys.session], isNull);
  });
}
