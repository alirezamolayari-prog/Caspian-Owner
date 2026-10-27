import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/presentation/lock_screen.dart';
import 'package:caspian_owner/features/auth/presentation/login_screen.dart';
import 'package:caspian_owner/features/auth/presentation/pin_setup_screen.dart';
import 'package:caspian_owner/features/auth/presentation/unlock_offer_screen.dart';
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

  Future<void> login(
    WidgetTester tester, {
    String username = 'owner1',
    String password = '۱۱۱۱۱',
  }) async {
    await tester.enterText(find.byType(TextField).at(0), username);
    await tester.enterText(find.byType(TextField).at(1), password);
    await tester.tap(find.text('ورود'));
    await tester.pumpAndSettle();
  }

  testWidgets('login with username and test password leads to the hub', (
    tester,
  ) async {
    final harness = await pumpApp(tester);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('نسخه آزمایشی: رمز ۱۱۱۱۱'), findsOneWidget);

    await login(tester);

    // First the fingerprint offer; one touch turns it on.
    expect(find.byType(UnlockOfferScreen), findsOneWidget);
    await tester.tap(find.text('بله، فعال شود'));
    await tester.pumpAndSettle();
    expect(harness.authenticator.prompts, 1);
    expect(harness.store.values[SecureKeys.deviceUnlock], 'on');

    expect(find.byType(HubScreen), findsOneWidget);
    expect(find.text('سلام علیرضا'), findsOneWidget);
    // Signing in with a password doesn't lock the app again.
    expect(find.byType(LockScreen), findsNothing);
    expect(harness.store.values[SecureKeys.session], isNotNull);
  });

  testWidgets('«not now» to the fingerprint leads to an app PIN', (
    tester,
  ) async {
    final harness = await pumpApp(tester);
    await login(tester);
    await tester.tap(find.text('فعلاً نه'));
    await tester.pumpAndSettle();

    expect(find.byType(PinSetupScreen), findsOneWidget);
    expect(harness.store.values[SecureKeys.deviceUnlock], 'off');
    expect(harness.authenticator.prompts, 0);
  });

  testWidgets('a failed touch keeps the offer open', (tester) async {
    final harness = await pumpApp(tester);
    await login(tester);
    harness.authenticator.succeeds = false;
    await tester.tap(find.text('بله، فعال شود'));
    await tester.pumpAndSettle();

    expect(find.byType(UnlockOfferScreen), findsOneWidget);
    expect(find.text('اثر انگشت تأیید نشد. دوباره امتحان کنید.'), findsOne);
  });

  testWidgets('phones without a fingerprint skip the offer', (tester) async {
    final harness = TestHarness.create(fixtures, deviceAuthAvailable: false);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await login(tester);

    expect(find.byType(UnlockOfferScreen), findsNothing);
    expect(find.byType(PinSetupScreen), findsOneWidget);
  });

  testWidgets('the lock screen offers the password instead', (tester) async {
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    harness.authenticator.succeeds = false;
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    expect(find.byType(LockScreen), findsOneWidget);

    await tester.tap(find.text('ورود با رمز عبور'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(harness.store.values[SecureKeys.session], isNull);
  });

  testWidgets('«not now» without a PIN yet: the fingerprint still guards '
      'the next start', (tester) async {
    // Closed after «فعلاً نه» but before making the PIN: nobody may make a
    // PIN of their own and walk in.
    final harness = TestHarness.create(
      fixtures,
      signedIn: true,
      useDevice: false,
    );
    addTearDown(harness.database.close);
    harness.authenticator.succeeds = false;
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.byType(LockScreen), findsOneWidget);
    expect(find.byType(PinSetupScreen), findsNothing);
    expect(harness.authenticator.prompts, 1);
  });

  testWidgets('a stored «no fingerprint» answer is kept at the next start', (
    tester,
  ) async {
    final harness = TestHarness.create(
      fixtures,
      signedIn: true,
      hasPin: true,
      useDevice: false,
    );
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    // Locked, but no automatic fingerprint prompt: the app PIN is asked.
    expect(find.byType(LockScreen), findsOneWidget);
    expect(harness.authenticator.prompts, 0);
    expect(find.text('باز کردن با اثر انگشت'), findsNothing);
    expect(find.text('ورود با رمز برنامه'), findsOneWidget);
  });

  testWidgets('a wrong password is explained in Persian', (tester) async {
    await pumpApp(tester);
    await login(tester, password: '22222');

    expect(find.text('شماره موبایل یا رمز عبور اشتباه است.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('empty fields are explained', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('ورود'));
    await tester.pumpAndSettle();
    expect(find.text('شماره موبایل و رمز عبور را وارد کنید.'), findsOneWidget);
  });

  testWidgets('a mistyped mobile number is explained', (tester) async {
    await pumpApp(tester);
    await login(tester, username: '۰۹۱۲۳');
    expect(
      find.text('شماره موبایل درست نیست. ۱۱ رقم است و با ۰۹ شروع می‌شود.'),
      findsOneWidget,
    );
  });

  testWidgets('the password can be shown and hidden', (tester) async {
    await pumpApp(tester);
    TextField password() =>
        tester.widget<TextField>(find.byType(TextField).at(1));
    expect(password().obscureText, isTrue);
    await tester.tap(find.byTooltip('نمایش رمز'));
    await tester.pump();
    expect(password().obscureText, isFalse);
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
