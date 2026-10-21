import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:caspian_owner/features/requests/presentation/requests_screen.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_tile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<TestHarness> pumpHome(
    WidgetTester tester, {
    MockScenario scenario = MockScenario.normal,
  }) async {
    final harness = TestHarness.create(fixtures, signedIn: true);
    harness.backend.scenario = scenario;
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    // The app opens on the hub; Home is the warehouse module's first tab.
    await tester.tap(find.text('انبار'));
    await tester.pumpAndSettle();
    return harness;
  }

  testWidgets('shows pending count, latest requests and the count card', (
    tester,
  ) async {
    await pumpHome(tester);
    expect(find.text('منتظر تأیید شما'), findsOneWidget);
    expect(find.text('۴ درخواست'), findsOneWidget);
    expect(find.text('بررسی درخواست‌ها'), findsOneWidget);
    expect(find.text('آخرین درخواست‌ها'), findsOneWidget);
    expect(find.byType(RequestTile), findsNWidgets(3));
    expect(
      find.text('لوله پی‌وی‌سی ۲ اینچ – ۸ شاخه'),
      findsOneWidget,
      reason: 'newest request (۱۲۵) first',
    );
    // Surprise counts were removed in v0.2.0.
    expect(find.textContaining('شمارش'), findsNothing);
  });

  testWidgets('nothing pending: calm empty state', (tester) async {
    await pumpHome(tester, scenario: MockScenario.empty);
    expect(find.text('همه درخواست‌ها بررسی شده‌اند'), findsOneWidget);
    expect(find.text('بررسی درخواست‌ها'), findsNothing);
    expect(find.text('هنوز درخواستی ثبت نشده است.'), findsOneWidget);
  });

  testWidgets('server error shows «تلاش دوباره», which recovers', (
    tester,
  ) async {
    final harness = await pumpHome(tester, scenario: MockScenario.serverError);
    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text('خطای سرور. کمی بعد دوباره تلاش کنید.'), findsOneWidget);

    harness.backend.scenario = MockScenario.normal;
    await tester.tap(find.text('تلاش دوباره'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorState), findsNothing);
    expect(find.text('۴ درخواست'), findsOneWidget);
  });

  testWidgets('offline after a good load shows saved data with its time', (
    tester,
  ) async {
    final harness = await pumpHome(tester);
    expect(find.byType(StaleNotice), findsNothing);

    harness.backend.scenario = MockScenario.offline;
    await tester.fling(
      find.text('آخرین درخواست‌ها'),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(find.byType(StaleNotice), findsOneWidget);
    expect(find.textContaining('آخرین به‌روزرسانی'), findsOneWidget);
    expect(find.text('۴ درخواست'), findsOneWidget);
  });

  testWidgets('offline with nothing saved shows the network error', (
    tester,
  ) async {
    await pumpHome(tester, scenario: MockScenario.offline);
    expect(
      find.text('به سرور وصل نشد. وای‌فای و آدرس سرور را بررسی کنید.'),
      findsOneWidget,
    );
  });

  testWidgets('hero button opens the Requests tab', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.text('بررسی درخواست‌ها'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestsScreen), findsOneWidget);
  });

  testWidgets('tapping a latest request opens its detail', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byType(RequestTile).first);
    await tester.pumpAndSettle();
    final detail = tester.widget<RequestDetailScreen>(
      find.byType(RequestDetailScreen),
    );
    expect(detail.requestId, 'r-125');
  });

  testWidgets('largest font scale: no overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpHome(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('۴ درخواست'), findsOneWidget);
  });

  testWidgets('meets tap target and label guidelines', (tester) async {
    await pumpHome(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });
}
