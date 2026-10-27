import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/presentation/login_screen.dart';
import 'package:caspian_owner/features/hub/presentation/hub_screen.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:caspian_owner/features/settings/presentation/server_url_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_server.dart';
import '../helpers/mock_setup.dart';
import '../helpers/test_app.dart';

/// The whole app against a fake Caspian Server (no mock backend).
void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  late FakeServer server;
  setUp(() {
    server = FakeServer()
      ..on(
        'GET',
        '/health',
        FakeServer.json({
          'status': 'ok',
          'server_time': '2026-10-21T09:00:00Z',
        }),
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
      ..on(
        'GET',
        '/requests',
        FakeServer.json([
          serverRequest(
            status: 'rejected',
            decidedById: 4,
            decidedByName: 'مالک ۲',
            rejectionReason: 'زیاد است',
          ),
        ]),
      )
      ..on(
        'GET',
        '/requests/5',
        FakeServer.json(
          serverRequest(
            status: 'rejected',
            decidedById: 4,
            decidedByName: 'مالک ۲',
            rejectionReason: 'زیاد است',
          ),
        ),
      )
      ..on('GET', '/requests/5/messages', FakeServer.json(<Object>[]));
  });

  Future<TestHarness> pumpApp(
    WidgetTester tester, {
    bool signedIn = false,
  }) async {
    final harness = TestHarness.create(
      fixtures,
      signedIn: signedIn,
      server: server,
    );
    addTearDown(harness.database.close);
    await tester.pumpWidget(
      harness.app(
        extra: [serverProbeProvider.overrideWithValue((url) async {})],
      ),
    );
    await tester.pumpAndSettle();
    // Stops live sync's timer when the test ends.
    addTearDown(() => tester.pumpWidget(const SizedBox()));
    return harness;
  }

  Future<void> login(WidgetTester tester, String password) async {
    await tester.enterText(find.byType(TextField).at(0), 'owner1');
    await tester.enterText(find.byType(TextField).at(1), password);
    await tester.tap(find.text('ورود'));
    await tester.pumpAndSettle();
  }

  testWidgets('login screen shows the server and explains each failure', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.byType(LoginScreen), findsOneWidget);
    // Debug builds show the server under the form.
    await tester.scrollUntilVisible(
      find.text('تغییر آدرس سرور'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('سرور: https://api.caspianmoblserver.ir'), findsOneWidget);
    expect(find.text('نسخه آزمایشی: رمز ۱۱۱۱۱'), findsNothing);

    // Server off.
    await login(tester, 'owner123');
    expect(
      find.text('سرور کاسپین جواب نداد. کمی بعد دوباره امتحان کنید.'),
      findsOneWidget,
    );

    // Wrong password.
    server.on(
      'POST',
      '/auth/login',
      FakeServer.fail(401, 'invalid_credentials'),
    );
    await login(tester, 'bad');
    expect(find.text('شماره موبایل یا رمز عبور اشتباه است.'), findsOneWidget);

    // The warehouse account.
    server.on(
      'POST',
      '/auth/login',
      FakeServer.json({'access_token': 'w', 'role': 'warehouse'}),
    );
    await login(tester, 'warehouse123');
    expect(find.text('این حساب برای اپ مالکان نیست.'), findsOneWidget);
  });

  testWidgets('an owner logs in, the token is kept securely', (tester) async {
    final harness = await pumpApp(tester);
    server
      ..on(
        'POST',
        '/auth/login',
        FakeServer.json({
          'access_token': fakeJwt(DateTime.utc(2030)),
          'role': 'owner',
        }),
      )
      ..on(
        'GET',
        '/auth/me',
        FakeServer.json({
          'id': 3,
          'username': 'owner1',
          'full_name': 'مالک ۱',
          'role': 'owner',
        }),
      );

    await login(tester, 'owner123');
    await tester.tap(find.text('بله، فعال شود'));
    await tester.pumpAndSettle();

    expect(find.byType(HubScreen), findsOneWidget);
    expect(find.text('سلام مالک ۱'), findsOneWidget);
    expect(harness.store.values[SecureKeys.session], contains('access_token'));
  });

  testWidgets('a 401 later signs out and says so', (tester) async {
    await pumpApp(tester, signedIn: true);
    server.on('GET', '/requests', FakeServer.error(401));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(HubScreen)),
    );
    container.read(routerProvider).go('/requests');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('نشست شما تمام شد. دوباره وارد شوید.'), findsOneWidget);
  });

  testWidgets('detail: no stock row and no «ویرایش و برگرداندن» on the '
      'server', (tester) async {
    await pumpApp(tester, signedIn: true);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HubScreen)),
    );
    container.read(routerProvider).go('/requests/5');
    await tester.pumpAndSettle();

    expect(find.byType(RequestDetailScreen), findsOneWidget);
    expect(find.textContaining('کیسه زباله'), findsWidgets);
    expect(find.text('سرویس بهداشتی طبقه ۲'), findsOneWidget);
    expect(find.textContaining('مالک ۲'), findsWidgets);
    expect(find.text('موجودی فعلی'), findsNothing);
    expect(find.text('مصرف قبلی همین محل'), findsNothing);
    expect(find.text('ویرایش و برگرداندن'), findsNothing);
  });

  testWidgets('stock and assistant tabs say «not connected yet»', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: true);
    await tester.tap(find.text('انبار'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('موجودی'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'این بخش هنوز به سرور کاسپین وصل نشده است و به‌زودی اضافه می‌شود.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('دستیار'));
    await tester.pumpAndSettle();
    expect(find.text('دستیار کاسپین'), findsOneWidget);
    expect(
      find.text(
        'این بخش هنوز به سرور کاسپین وصل نشده است و به‌زودی اضافه می‌شود.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('the server address can be changed from the login screen', (
    tester,
  ) async {
    final harness = await pumpApp(tester);
    await tester.scrollUntilVisible(
      find.text('تغییر آدرس سرور'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('تغییر آدرس سرور'));
    await tester.pumpAndSettle();

    final field = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'http://caspian.example.ir');
    await tester.tap(find.text('ذخیره'));
    await tester.pumpAndSettle();
    expect(
      find.text('برای آدرس‌های اینترنتی فقط https مجاز است.'),
      findsOneWidget,
    );

    await tester.enterText(field, 'http://192.168.1.20:8000/');
    await tester.tap(find.text('آزمایش اتصال'));
    await tester.pumpAndSettle();
    expect(find.text('اتصال برقرار است.'), findsOneWidget);

    await tester.tap(find.text('ذخیره'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('سرور: http://192.168.1.20:8000'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('سرور: http://192.168.1.20:8000'), findsOneWidget);
    expect(
      harness.store.values[SecureKeys.settings],
      contains('http://192.168.1.20:8000'),
    );
  });
}
