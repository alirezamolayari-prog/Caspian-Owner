import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_screen.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/hub/presentation/hub_screen.dart';
import 'package:caspian_owner/features/more/presentation/about_screen.dart';
import 'package:caspian_owner/features/notifications/presentation/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../core/update/update_test.dart' show manifestJson;
import '../helpers/fake_http.dart';
import '../helpers/mock_setup.dart';
import '../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  UpdateChecker checkerWith(Map<String, Object?> manifest) => UpdateChecker(
    dio: fakeDio(
      FakeHttpAdapter({
        'https://u.example/update.json': (o) => FakeHttpAdapter.json(manifest),
      }),
    ),
    urls: const ['https://u.example/update.json'],
  );

  testWidgets('a too-old build gets the blocking update screen', (
    tester,
  ) async {
    final h = TestHarness.create(
      fixtures,
      signedIn: true,
      updateChecker: checkerWith(manifestJson(minBuild: 5)),
    );
    addTearDown(h.database.close);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();

    expect(find.byType(UpdateScreen), findsOneWidget);
    expect(find.text('برای ادامه، برنامه را به‌روز کنید'), findsOneWidget);
    // No way back into the app.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(UpdateScreen), findsOneWidget);
    expect(find.byType(HubScreen), findsNothing);
  });

  Future<TestHarness> pumpWithUpdate(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final h = TestHarness.create(
      fixtures,
      signedIn: true,
      updateChecker: checkerWith(manifestJson(minBuild: 1)),
    );
    addTearDown(h.database.close);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    return h;
  }

  final newVersion = 'نسخه ${toPersianDigits('1.2.0')} آماده است';

  testWidgets('a newer build is introduced; «به‌روزرسانی» opens About with '
      '«دانلود و نصب»', (tester) async {
    await pumpWithUpdate(tester);

    expect(find.text('نسخه تازه آماده است'), findsOneWidget);
    expect(find.textContaining('رفع اشکال'), findsOneWidget);
    expect(find.text('رد کردن'), findsOneWidget);
    await tester.tap(find.text('به‌روزرسانی'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.text('دانلود و نصب'), findsOneWidget);
    expect(find.text('بررسی به‌روزرسانی'), findsNothing);
    // Back to where the owner was.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(HubScreen), findsOneWidget);
    expect(find.text('نسخه تازه آماده است'), findsNothing);
  });

  testWidgets('«رد کردن» lets the owner work; the bell then leads to About', (
    tester,
  ) async {
    await pumpWithUpdate(tester);
    await tester.tap(find.text('رد کردن'));
    await tester.pumpAndSettle();
    expect(find.byType(HubScreen), findsOneWidget);
    expect(find.text('نسخه تازه آماده است'), findsNothing);

    // The bell says so (a dot, and in words for TalkBack).
    await tester.tap(find.byTooltip('اعلان‌ها – نسخه تازه آماده است'));
    await tester.pumpAndSettle();
    expect(find.byType(NotificationsScreen), findsOneWidget);
    expect(find.text(newVersion), findsOneWidget);

    await tester.tap(find.text(newVersion));
    await tester.pumpAndSettle();
    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.text('دانلود و نصب'), findsOneWidget);
  });

  testWidgets('About and the bell list with an update meet the accessibility '
      'guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpWithUpdate(tester);
    await tester.tap(find.text('رد کردن'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('اعلان‌ها – نسخه تازه آماده است'));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await tester.tap(find.text(newVersion));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });
}
