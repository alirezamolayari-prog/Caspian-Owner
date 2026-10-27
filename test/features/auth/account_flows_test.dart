import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/presentation/account_status_screen.dart';
import 'package:caspian_owner/features/auth/presentation/login_screen.dart';
import 'package:caspian_owner/features/auth/presentation/new_password_screen.dart';
import 'package:caspian_owner/features/auth/presentation/otp_screen.dart';
import 'package:caspian_owner/features/auth/presentation/register_screen.dart';
import 'package:caspian_owner/features/auth/presentation/unlock_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';
import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

/// Registration, forgotten password and the login answers, against a fake
/// Caspian Server that answers like docs/owner-auth-api.md.
void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  late FakeServer server;
  setUp(() {
    server = FakeServer()
      ..on(
        'POST',
        '/auth/otp/request',
        FakeServer.json({'expires_in': 120, 'resend_after': 90}),
      )
      ..on(
        'POST',
        '/auth/otp/verify',
        FakeServer.json({'verified_token': 'vt-1', 'expires_in': 300}),
      )
      ..on(
        'POST',
        '/auth/otp/register',
        FakeServer.json({'status': 'pending'}, status: 201),
      )
      ..on(
        'POST',
        '/auth/otp/reset-password',
        FakeServer.json({'status': 'ok'}),
      );
  });

  Future<TestHarness> pumpApp(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, server: server);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    return harness;
  }

  Finder field(String label) => find.widgetWithText(TextField, label);

  /// Lets a request answer and the page change finish, in under a second
  /// (pumpAndSettle would also run the 90 s resend countdown).
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> sendRegisterCode(WidgetTester tester) async {
    await tapText(tester, 'ثبت‌نام مالک جدید');
    expect(find.byType(RegisterScreen), findsOneWidget);
    await tester.enterText(field('نام'), ' مهدي ');
    await tester.enterText(field('نام خانوادگی'), 'كریمی');
    await tester.enterText(field('شماره موبایل'), '۰۹۱۲ ۳۴۵ ۶۷۸۹');
    await tester.tap(find.text('ارسال کد'));
    await settle(tester);
  }

  Future<void> choosePassword(WidgetTester tester, String submit) async {
    await tester.enterText(field('رمز عبور تازه'), 'my-own-strong-pass');
    await tester.enterText(field('تکرار رمز عبور'), 'my-own-strong-pass');
    await tapText(tester, submit);
  }

  group('registration', () {
    testWidgets('names + mobile → code → password → waiting for approval', (
      tester,
    ) async {
      await pumpApp(tester);
      await sendRegisterCode(tester);

      expect(find.byType(OtpScreen), findsOneWidget);
      expect(find.text('کد ۶ رقمی به شماره ۰۹۱۲ ۳۴۵ ۶۷۸۹ پیامک شد.'), findsOne);
      expect(find.text('ارسال دوباره کد تا ۱:۳۰ دیگر'), findsOneWidget);
      expect(server.calls('POST', '/auth/otp/request').single.data, {
        'mobile': '09123456789',
        'purpose': 'register',
      });

      // Typing the 6th digit checks the code by itself.
      await tester.enterText(field('کد ۶ رقمی'), '۴۸۲۹۱۳');
      await tester.pumpAndSettle();
      expect(server.calls('POST', '/auth/otp/verify').single.data, {
        'mobile': '09123456789',
        'code': '482913',
        'purpose': 'register',
      });

      expect(find.byType(NewPasswordScreen), findsOneWidget);
      expect(find.text('مرحله ۳ از ۳'), findsOneWidget);
      await choosePassword(tester, 'ثبت‌نام');

      expect(server.calls('POST', '/auth/otp/register').single.data, {
        'verified_token': 'vt-1',
        'first_name': 'مهدی',
        'last_name': 'کریمی',
        'password': 'my-own-strong-pass',
      });
      expect(find.text('درخواست شما ثبت شد'), findsOneWidget);

      // Back on the login page, the mobile is already filled in.
      await tapText(tester, 'بازگشت به صفحه ورود');
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.textContaining('بعد از تأیید مدیر'), findsOneWidget);
      expect(find.text('09123456789'), findsOneWidget);
    });

    testWidgets('names in Latin letters and a wrong mobile are explained '
        'before anything is sent', (tester) async {
      await pumpApp(tester);
      await tapText(tester, 'ثبت‌نام مالک جدید');
      await tester.enterText(field('نام'), 'Mehdi');
      await tester.enterText(field('نام خانوادگی'), 'کریمی');
      await tester.enterText(field('شماره موبایل'), '0212345678');
      await tapText(tester, 'ارسال کد');

      expect(find.text('با حروف فارسی بنویسید (۲ تا ۵۰ حرف).'), findsOne);
      expect(
        find.text('شماره موبایل درست نیست. ۱۱ رقم است و با ۰۹ شروع می‌شود.'),
        findsOneWidget,
      );
      expect(server.calls('POST', '/auth/otp/request'), isEmpty);
    });

    testWidgets('a weak or mismatched password is explained', (tester) async {
      await pumpApp(tester);
      await sendRegisterCode(tester);
      await tester.enterText(field('کد ۶ رقمی'), '482913');
      await tester.pumpAndSettle();

      await tester.enterText(field('رمز عبور تازه'), '12345');
      await tapText(tester, 'ثبت‌نام');
      expect(find.text('دست‌کم ۱۰ حرف یا عدد'), findsNWidgets(2));

      await tester.enterText(field('رمز عبور تازه'), 'password123');
      await tapText(tester, 'ثبت‌نام');
      expect(
        find.text('این رمز خیلی ساده و رایج است. رمز دیگری بسازید.'),
        findsOneWidget,
      );

      await tester.enterText(field('رمز عبور تازه'), 'my-own-strong-pass');
      await tester.enterText(field('تکرار رمز عبور'), 'my-own-strong-pas');
      await tapText(tester, 'ثبت‌نام');
      expect(find.text('دو رمز یکی نیستند.'), findsOneWidget);
      expect(server.calls('POST', '/auth/otp/register'), isEmpty);
    });

    testWidgets('the server refusing the password names the field', (
      tester,
    ) async {
      server.on(
        'POST',
        '/auth/otp/register',
        FakeServer.invalidField('password', 'این رمز در فهرست رمزهای رایج است'),
      );
      await pumpApp(tester);
      await sendRegisterCode(tester);
      await tester.enterText(field('کد ۶ رقمی'), '482913');
      await tester.pumpAndSettle();
      await choosePassword(tester, 'ثبت‌نام');

      expect(find.text('این رمز در فهرست رمزهای رایج است'), findsOneWidget);
    });

    testWidgets('an expired verification starts over', (tester) async {
      server.on(
        'POST',
        '/auth/otp/register',
        FakeServer.fail(401, 'verification_invalid', detail: 'از اول'),
      );
      await pumpApp(tester);
      await sendRegisterCode(tester);
      await tester.enterText(field('کد ۶ رقمی'), '482913');
      await tester.pumpAndSettle();
      await choosePassword(tester, 'ثبت‌نام');

      expect(find.text('از اول'), findsOneWidget);
      await tapText(tester, 'از اول شروع کنید');
      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });

  group('the SMS code', () {
    testWidgets('Android fills it in once the owner allows it', (tester) async {
      final harness = await pumpApp(tester);
      await sendRegisterCode(tester);
      expect(harness.sms.waiting, isTrue);

      harness.sms.deliver('کاسپین\nکد تأیید شما: ۴۸۲۹۱۳');
      await tester.pumpAndSettle();

      expect(server.calls('POST', '/auth/otp/verify').single.data, {
        'mobile': '09123456789',
        'code': '482913',
        'purpose': 'register',
      });
      expect(find.byType(NewPasswordScreen), findsOneWidget);
    });

    testWidgets('declined: typing the code still works', (tester) async {
      final harness = await pumpApp(tester);
      await sendRegisterCode(tester);
      harness.sms.decline();
      await tester.pump();
      expect(find.byType(OtpScreen), findsOneWidget);
      expect(server.calls('POST', '/auth/otp/verify'), isEmpty);

      await tester.enterText(field('کد ۶ رقمی'), '482913');
      await tester.pumpAndSettle();
      expect(find.byType(NewPasswordScreen), findsOneWidget);
    });

    testWidgets('a wrong code shows the tries left and clears the box', (
      tester,
    ) async {
      server.on(
        'POST',
        '/auth/otp/verify',
        FakeServer.fail(
          400,
          'code_wrong',
          detail: 'کد درست نیست. ۴ بار دیگر می‌توانید امتحان کنید.',
        ),
      );
      await pumpApp(tester);
      await sendRegisterCode(tester);
      await tester.enterText(field('کد ۶ رقمی'), '111111');
      await settle(tester);

      expect(
        find.text('کد درست نیست. ۴ بار دیگر می‌توانید امتحان کنید.'),
        findsOneWidget,
      );
      final box = tester.widget<TextField>(field('کد ۶ رقمی'));
      expect(box.controller!.text, isEmpty);
      expect(find.byType(OtpScreen), findsOneWidget);
    });

    testWidgets('resend waits for the server, then honours Retry-After', (
      tester,
    ) async {
      await pumpApp(tester);
      await sendRegisterCode(tester);
      expect(find.text('ارسال دوباره کد'), findsNothing);

      await tester.pump(const Duration(seconds: 91));
      await tester.pump();
      expect(find.text('ارسال دوباره کد'), findsOneWidget);
      // No SMS for a number that already has an account: suggest a reset.
      await tester.scrollUntilVisible(
        find.textContaining('اگر قبلاً با این شماره'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      server.on(
        'POST',
        '/auth/otp/request',
        FakeServer.fail(
          429,
          'otp_rate_limited',
          detail: 'تعداد درخواست کد زیاد است.',
          retryAfter: 30,
        ),
      );
      await tester.ensureVisible(find.text('ارسال دوباره کد'));
      await tester.tap(find.text('ارسال دوباره کد'));
      await settle(tester);

      expect(find.text('تعداد درخواست کد زیاد است.'), findsOneWidget);
      expect(find.text('ارسال دوباره کد تا ۰:۳۰ دیگر'), findsOneWidget);
      await tester.pump(const Duration(seconds: 31));
      await tester.pump();
      expect(find.text('ارسال دوباره کد'), findsOneWidget);
    });
  });

  group('forgotten password', () {
    testWidgets('mobile → code → new password → back to login', (tester) async {
      await pumpApp(tester);
      await tapText(tester, 'رمز را فراموش کرده‌ام');
      await tester.enterText(field('شماره موبایل'), '+98 912 345 6789');
      await tester.tap(find.text('ارسال کد'));
      await settle(tester);
      expect(server.calls('POST', '/auth/otp/request').single.data, {
        'mobile': '09123456789',
        'purpose': 'reset_password',
      });

      await tester.enterText(field('کد ۶ رقمی'), '482913');
      await tester.pumpAndSettle();
      expect(find.text('رمز عبور تازه بسازید'), findsOneWidget);
      await choosePassword(tester, 'ذخیره رمز تازه');

      expect(server.calls('POST', '/auth/otp/reset-password').single.data, {
        'verified_token': 'vt-1',
        'new_password': 'my-own-strong-pass',
      });
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(
        find.text('رمز تازه ذخیره شد. با رمز تازه وارد شوید.'),
        findsOneWidget,
      );
      expect(find.text('09123456789'), findsOneWidget);
    });
  });

  group('login answers', () {
    Future<void> login(WidgetTester tester) async {
      await tester.enterText(field('شماره موبایل'), '09123456789');
      await tester.enterText(field('رمز عبور'), 'my-own-strong-pass');
      await tester.tap(find.text('ورود'));
      await tester.pumpAndSettle();
    }

    for (final (code, title) in [
      ('account_pending', 'حساب شما منتظر تأیید است'),
      ('account_rejected', 'درخواست ثبت‌نام تأیید نشد'),
      ('account_disabled', 'حساب شما غیرفعال است'),
    ]) {
      testWidgets('$code has its own page', (tester) async {
        server.on('POST', '/auth/login', FakeServer.fail(403, code));
        await pumpApp(tester);
        await login(tester);

        expect(find.byType(AccountStatusScreen), findsOneWidget);
        expect(find.text(title), findsOneWidget);
        expect(server.requests.last.data, {
          'username': '09123456789',
          'password': 'my-own-strong-pass',
        });
        await tapText(tester, 'بازگشت به صفحه ورود');
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    }

    testWidgets('too many tries: the server message and a waiting button', (
      tester,
    ) async {
      server.on(
        'POST',
        '/auth/login',
        FakeServer.fail(
          429,
          'login_rate_limited',
          detail: 'چند بار رمز اشتباه وارد شد. کمی بعد امتحان کنید.',
          retryAfter: 60,
        ),
      );
      await pumpApp(tester);
      await tester.enterText(field('شماره موبایل'), '09123456789');
      await tester.enterText(field('رمز عبور'), 'x');
      await tester.tap(find.text('ورود'));
      await settle(tester);

      expect(
        find.text('چند بار رمز اشتباه وارد شد. کمی بعد امتحان کنید.'),
        findsOneWidget,
      );
      expect(find.text('ورود (۱:۰۰)'), findsOneWidget);
      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('ورود (۱:۰۰)'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNull);

      await tester.pump(const Duration(seconds: 61));
      await tester.pump();
      expect(find.text('ورود'), findsOneWidget);
    });

    testWidgets('no internet and server not answering are told apart', (
      tester,
    ) async {
      server.on('POST', '/auth/login', FakeServer.noInternet());
      await pumpApp(tester);
      await login(tester);
      expect(
        find.text(
          'اینترنت گوشی وصل نیست. وای‌فای یا اینترنت همراه را روشن کنید.',
        ),
        findsOneWidget,
      );

      server.routes.remove('POST /auth/login');
      await tester.tap(find.text('ورود'));
      await tester.pumpAndSettle();
      expect(
        find.text('سرور کاسپین جواب نداد. کمی بعد دوباره امتحان کنید.'),
        findsOneWidget,
      );
    });

    testWidgets('a username (admin) is sent as typed', (tester) async {
      server.on('POST', '/auth/login', FakeServer.fail(401, 'x'));
      await pumpApp(tester);
      await tapText(tester, 'ورود با نام کاربری');
      await tester.enterText(field('نام کاربری'), ' admin ');
      await tester.enterText(field('رمز عبور'), 'secret-pass');
      await tester.tap(find.text('ورود'));
      await tester.pumpAndSettle();
      expect(server.requests.last.data, {
        'username': 'admin',
        'password': 'secret-pass',
      });
    });

    testWidgets('a first password from the admin is replaced, then the '
        'owner is in', (tester) async {
      final token = fakeJwt(DateTime.utc(2030));
      server
        ..on(
          'POST',
          '/auth/login',
          FakeServer.sequence(
            FakeServer.json({
              'access_token': 'first',
              'role': 'owner',
              'full_name': 'مالک ۱',
              'must_change_password': true,
            }),
            FakeServer.json({
              'access_token': token,
              'role': 'owner',
              'full_name': 'مالک ۱',
              'must_change_password': false,
            }),
          ),
        )
        ..on('POST', '/auth/change-password', FakeServer.json({}))
        ..on(
          'GET',
          '/auth/me',
          FakeServer.json({'id': 3, 'full_name': 'مالک ۱', 'role': 'owner'}),
        )
        ..on(
          'GET',
          '/changes',
          FakeServer.json({
            'server_time': '2026-10-21T09:00:05Z',
            'next_since': '2026-10-21T09:00:03Z',
            'requests': <Object>[],
            'messages': <Object>[],
          }),
        )
        ..on('GET', '/requests', FakeServer.json(<Object>[]));
      final harness = await pumpApp(tester);
      addTearDown(() => tester.pumpWidget(const SizedBox()));
      await login(tester);

      expect(find.text('رمز عبور خودتان را بسازید'), findsOneWidget);
      await tester.enterText(field('رمز عبور تازه'), 'brand-new-pass');
      await tester.enterText(field('تکرار رمز عبور'), 'brand-new-pass');
      await tapText(tester, 'ذخیره و ورود');

      final change = server.calls('POST', '/auth/change-password').single;
      expect(change.headers['Authorization'], 'Bearer first');
      expect(change.data, {
        'current_password': 'my-own-strong-pass',
        'new_password': 'brand-new-pass',
      });
      expect(server.calls('POST', '/auth/login').last.data, {
        'username': '09123456789',
        'password': 'brand-new-pass',
      });
      expect(find.byType(UnlockOfferScreen), findsOneWidget);
      expect(harness.store.values[SecureKeys.session], contains(token));
      // Passwords are never written to the phone.
      expect(
        harness.store.values.values.join(),
        isNot(contains('brand-new-pass')),
      );
    });
  });
}
