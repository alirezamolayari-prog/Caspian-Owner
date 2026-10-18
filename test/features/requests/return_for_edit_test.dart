import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/features/requests/application/decision_controller.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

/// B5: an owner sends a rejected request back to the requester with
/// smaller quantities (1..asked, or a line dropped) and a note.
void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<TestHarness> pumpAt(
    WidgetTester tester,
    String location, {
    void Function(MockBackend backend)? setUp,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true);
    setUp?.call(harness.backend);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(routerProvider)
        .go(location);
    await tester.pumpAndSettle();
    return harness;
  }

  /// Request 122 (two lines) as if another owner had rejected it.
  void rejectTwoLines(MockBackend b) => b.replaceRequest(
    b
        .requestById('r-122')
        .copyWith(
          status: RequestStatus.rejected,
          decidedBy: const DecidedBy(
            kind: DeciderKind.owner,
            nameFa: 'حسین کاظمی',
          ),
          decidedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
  );

  GoodsRequest backendRequest(TestHarness h, String id) =>
      h.backend.requests.firstWhere((r) => r.id == id);

  IconButton button(WidgetTester tester, String tooltip) =>
      tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip(tooltip),
          matching: find.byType(IconButton),
        ),
      );

  Future<void> openSheet(WidgetTester tester) async {
    await tester.tap(find.text('ویرایش و برگرداندن'));
    await tester.pumpAndSettle();
  }

  testWidgets('a rejected request offers «ویرایش و برگرداندن», not approve', (
    tester,
  ) async {
    await pumpAt(tester, '/requests/r-119');
    expect(find.text('ویرایش و برگرداندن'), findsOneWidget);
    expect(find.text('تأیید'), findsNothing);
    expect(find.text('رد کردن'), findsNothing);
  });

  testWidgets('quantities stay between 1 and what was asked', (tester) async {
    // Request 116: 3 قفل کتابی, rejected by the warehouse manager.
    await pumpAt(tester, '/requests/r-116');
    await openSheet(tester);
    expect(button(tester, 'بیشتر – قفل کتابی').onPressed, isNull);
    // A frame between taps, as with a real finger.
    await tester.tap(find.byTooltip('کمتر – قفل کتابی'));
    await tester.pump();
    await tester.tap(find.byTooltip('کمتر – قفل کتابی'));
    await tester.pump();
    expect(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('۱ عدد'),
      ),
      findsOneWidget,
    );
    expect(button(tester, 'کمتر – قفل کتابی').onPressed, isNull);
    // A single line can't be dropped.
    expect(find.text('حذف قلم'), findsNothing);
  });

  testWidgets('send back: 5 s to undo, then «برگشت برای اصلاح» with the '
      'changes', (tester) async {
    final h = await pumpAt(tester, '/requests/r-119');
    await openSheet(tester);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byTooltip('کمتر – پریز برق دوقلو'));
      await tester.pump();
    }
    await tester.enterText(find.byType(TextField).last, 'فعلاً ۱۷ تا کافی است');
    await tester.tap(find.text('ارسال برای اصلاح'));
    await tester.pumpAndSettle();
    expect(
      find.text('برگرداندن برای اصلاح – ۵ ثانیه تا ارسال'),
      findsOneWidget,
    );
    expect(h.authenticator.prompts, 1, reason: 'unlock only, no fingerprint');
    expect(backendRequest(h, 'r-119').status, RequestStatus.rejected);

    await tester.pump(DecisionController.undoWindow);
    await tester.pumpAndSettle();
    final sent = backendRequest(h, 'r-119');
    expect(sent.status, RequestStatus.returned);
    expect(sent.returnedForEdit!.lines.single.newQty, 17);
    expect(sent.returnedForEdit!.note, 'فعلاً ۱۷ تا کافی است');
    expect(find.textContaining('برگشت برای اصلاح توسط علیرضا'), findsOneWidget);
    expect(find.textContaining('پریز برق دوقلو: ۲۰ ← ۱۷'), findsOneWidget);
    expect(
      find.textContaining('یادداشت: فعلاً ۱۷ تا کافی است'),
      findsOneWidget,
    );
    expect(find.text('ویرایش و برگرداندن'), findsNothing);
  });

  testWidgets('a line can be dropped while another stays', (tester) async {
    final h = await pumpAt(tester, '/requests/r-122', setUp: rejectTwoLines);
    await openSheet(tester);
    expect(find.text('حذف قلم'), findsNWidgets(2));
    await tester.tap(find.text('حذف قلم').first);
    await tester.pump();
    expect(find.text('این قلم حذف می‌شود.'), findsOneWidget);
    expect(find.text('حذف قلم'), findsNothing, reason: 'the last line stays');

    await tester.tap(find.text('ارسال برای اصلاح'));
    await tester.pump();
    await tester.pump(DecisionController.undoWindow);
    await tester.pumpAndSettle();
    final lines = backendRequest(h, 'r-122').returnedForEdit!.lines;
    expect(lines.where((l) => l.removed), hasLength(1));
    expect(find.textContaining('حذف شد'), findsOneWidget);
  });

  testWidgets('undo within the window sends nothing', (tester) async {
    final h = await pumpAt(tester, '/requests/r-119');
    await openSheet(tester);
    await tester.tap(find.text('ارسال برای اصلاح'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('بازگرداندن'));
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(backendRequest(h, 'r-119').status, RequestStatus.rejected);
    expect(find.text('ویرایش و برگرداندن'), findsOneWidget);
  });

  testWidgets('409: another owner sent it back first', (tester) async {
    final h = await pumpAt(tester, '/requests/r-119');
    h.backend.scenario = MockScenario.conflict;
    await openSheet(tester);
    await tester.tap(find.text('ارسال برای اصلاح'));
    await tester.pump();
    await tester.pump(DecisionController.undoWindow);
    await tester.pumpAndSettle();
    expect(find.text('این درخواست قبلاً بررسی شده است'), findsOneWidget);
    expect(
      find.textContaining('زودتر این درخواست را برای اصلاح برگرداند'),
      findsOneWidget,
    );
  });

  testWidgets('offline: queued with its quantities, sent on the next refresh', (
    tester,
  ) async {
    final h = await pumpAt(tester, '/requests/r-119');
    h.backend.scenario = MockScenario.offline;
    await openSheet(tester);
    await tester.tap(find.byTooltip('کمتر – پریز برق دوقلو'));
    await tester.tap(find.text('ارسال برای اصلاح'));
    await tester.pump();
    await tester.pump(DecisionController.undoWindow);
    await tester.pumpAndSettle();
    expect(find.text('در صف ارسال'), findsOneWidget);

    h.backend.scenario = MockScenario.normal;
    await tester.fling(
      find.byType(RequestDetailScreen),
      const Offset(0, 500),
      1000,
    );
    await tester.pumpAndSettle();
    final sent = backendRequest(h, 'r-119');
    expect(sent.status, RequestStatus.returned);
    // The lines survived the trip through the on-phone queue.
    expect(sent.returnedForEdit!.lines.single.newQty, 19);
  });
}
