import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/features/requests/application/decision_controller.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_tile.dart';
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
    MockScenario scenario = MockScenario.normal,
    double height = 2400,
  }) async {
    tester.view
      ..physicalSize = Size(1080, height)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true);
    harness.backend.scenario = scenario;
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(routerProvider)
        .go(location);
    await tester.pumpAndSettle();
    return harness;
  }

  GoodsRequest backendRequest(TestHarness h, String id) =>
      h.backend.requests.firstWhere((r) => r.id == id);

  group('requests list', () {
    testWidgets('«منتظر (۴)» is the default filter', (tester) async {
      await pumpAt(tester, '/requests');
      expect(find.text('منتظر (۴)'), findsOneWidget);
      expect(find.byType(RequestTile), findsNWidgets(4));
    });

    testWidgets('«بررسی‌شده» shows decisions, including the manager ones', (
      tester,
    ) async {
      // Tall screen: the list is lazy and builds only the visible tiles.
      await pumpAt(tester, '/requests', height: 6000);
      await tester.tap(find.text('بررسی‌شده'));
      await tester.pumpAndSettle();
      // 121, 120, 119, 118, 117, 116 are approved or rejected.
      expect(find.byType(RequestTile), findsNWidgets(6));
      expect(find.textContaining('مدیر انبار'), findsWidgets);
    });

    testWidgets('«همه» shows every request', (tester) async {
      await pumpAt(tester, '/requests', height: 6000);
      await tester.tap(find.text('همه'));
      await tester.pumpAndSettle();
      expect(find.byType(RequestTile), findsNWidgets(11));
    });

    testWidgets('empty pending list says so', (tester) async {
      await pumpAt(tester, '/requests', scenario: MockScenario.empty);
      expect(find.text('درخواستی منتظر تأیید شما نیست.'), findsOneWidget);
    });
  });

  group('request detail', () {
    testWidgets('shows item, stock, place, note, history and chat', (
      tester,
    ) async {
      await pumpAt(tester, '/requests/r-124');
      expect(find.text('درخواست ۱۲۴'), findsOneWidget);
      expect(find.text('لامپ LED ۱۸ وات – ۲۴ عدد'), findsOneWidget);
      expect(find.text('۴۲ عدد'), findsOneWidget, reason: 'موجودی فعلی');
      expect(find.text('۳۶ عدد'), findsOneWidget, reason: 'مصرف ماه قبل');
      expect(find.text('پلاک ۶۸ – همکف'), findsOneWidget);
      expect(
        find.text('برای تعویض لامپ‌های راهروی همکف کنار پلاک ۶۸'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('مصرف قبلی همین محل'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('حواله ح-۸۸۴'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('حتماً. ممنون.'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('گفتگو درباره این درخواست'), findsOneWidget);
    });

    testWidgets('approve: one fingerprint, then sent after the undo window', (
      tester,
    ) async {
      final h = await pumpAt(tester, '/requests/r-124');
      await tester.tap(find.text('تأیید'));
      await tester.pump();
      expect(h.authenticator.prompts, 2, reason: 'unlock + approve');
      await tester.pump();
      expect(find.text('تأیید شد و به انبار خبر داده شد'), findsWidgets);
      expect(find.text('بازگرداندن'), findsOneWidget);
      expect(find.text('رد کردن'), findsNothing, reason: 'bar is hidden');
      expect(backendRequest(h, 'r-124').status, RequestStatus.pending);

      await tester.pump(DecisionController.undoWindow);
      await tester.pumpAndSettle();
      expect(backendRequest(h, 'r-124').status, RequestStatus.approved);
      expect(find.textContaining('تأیید شد توسط علیرضا'), findsOneWidget);
    });

    testWidgets('undo brings the buttons back and sends nothing', (
      tester,
    ) async {
      final h = await pumpAt(tester, '/requests/r-124');
      await tester.tap(find.text('تأیید'));
      await tester.pump();
      // Let the snackbar finish sliding in before tapping its action.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('بازگرداندن'));
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      expect(find.text('تأیید'), findsOneWidget);
      expect(backendRequest(h, 'r-124').status, RequestStatus.pending);
    });

    testWidgets('reject asks for an optional reason', (tester) async {
      final h = await pumpAt(tester, '/requests/r-124');
      await tester.tap(find.text('رد کردن'));
      await tester.pumpAndSettle();
      expect(find.text('رد کردن درخواست ۱۲۴'), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, 'زیاد است');
      await tester.tap(find.widgetWithText(FilledButton, 'رد کردن'));
      await tester.pump();
      await tester.pump(DecisionController.undoWindow);
      await tester.pumpAndSettle();
      final decided = backendRequest(h, 'r-124');
      expect(decided.status, RequestStatus.rejected);
      expect(decided.decisionReason, 'زیاد است');
    });

    testWidgets('409: a dialog says who decided first', (tester) async {
      final h = await pumpAt(tester, '/requests/r-124');
      h.backend.scenario = MockScenario.conflict;
      await tester.tap(find.text('تأیید'));
      await tester.pump();
      await tester.pump(DecisionController.undoWindow);
      await tester.pumpAndSettle();
      expect(find.text('این درخواست قبلاً بررسی شده است'), findsOneWidget);
      expect(find.textContaining('حسین کاظمی'), findsWidgets);
      await tester.tap(find.text('باشه'));
      await tester.pumpAndSettle();
      expect(find.text('این درخواست قبلاً بررسی شده است'), findsNothing);
    });

    testWidgets('offline: «در صف ارسال», sent on the next refresh', (
      tester,
    ) async {
      final h = await pumpAt(tester, '/requests/r-124');
      h.backend.scenario = MockScenario.offline;
      await tester.tap(find.text('تأیید'));
      await tester.pump();
      await tester.pump(DecisionController.undoWindow);
      await tester.pumpAndSettle();
      expect(find.text('در صف ارسال'), findsOneWidget);
      expect(find.textContaining('در صف ارسال است'), findsOneWidget);

      h.backend.scenario = MockScenario.normal;
      await tester.fling(
        find.byType(RequestDetailScreen),
        const Offset(0, 500),
        1000,
      );
      await tester.pumpAndSettle();
      expect(backendRequest(h, 'r-124').status, RequestStatus.approved);
      expect(find.text('در صف ارسال'), findsNothing);
    });

    testWidgets('routine requests show the manager decision, no buttons', (
      tester,
    ) async {
      await pumpAt(tester, '/requests/r-120');
      expect(find.textContaining('ناصر کریمی (مدیر انبار)'), findsOneWidget);
      expect(find.text('تأیید'), findsNothing);
      expect(find.text('رد کردن'), findsNothing);
    });

    testWidgets('an item hidden by a count says «در حال شمارش»', (
      tester,
    ) async {
      await pumpAt(tester, '/requests/r-123');
      expect(find.text('در حال شمارش'), findsOneWidget);
      expect(find.text('آسانسور باری اسدنژاد – طبقه دوم'), findsOneWidget);
    });

    testWidgets('sending a chat message shows it at once', (tester) async {
      await pumpAt(tester, '/requests/r-123');
      await tester.scrollUntilVisible(
        find.byTooltip('فرستادن'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byType(TextField).last, 'کی آماده می‌شود؟');
      await tester.tap(find.byTooltip('فرستادن'));
      await tester.pumpAndSettle();
      expect(find.text('کی آماده می‌شود؟'), findsOneWidget);
    });
  });
}
