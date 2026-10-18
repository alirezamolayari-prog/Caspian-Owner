import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/features/chat/application/chat_controller.dart';
import 'package:caspian_owner/features/chat/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  Future<ProviderContainer> pumpAt(WidgetTester tester, String location) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    container.read(routerProvider).go(location);
    await tester.pumpAndSettle();
    return container;
  }

  // Request 121 has a 60-message chat over three months (mock data).
  ChatState chatOf(ProviderContainer c) =>
      c.read(chatControllerProvider('r-121')).value!;

  testWidgets('opens at the newest message, with request number and item', (
    tester,
  ) async {
    final c = await pumpAt(tester, '/requests/r-121/chat');
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.text('گفتگو – درخواست ۱۲۱'), findsOneWidget);
    expect(find.text('رنگ پلاستیک سفید'), findsOneWidget);
    // One page loaded; the newest message is on screen without scrolling.
    expect(chatOf(c).entries, hasLength(ChatController.pageSize));
    expect(chatOf(c).hasOlder, isTrue);
    final newest = chatOf(c).entries.last.message.text;
    expect(find.text(newest), findsWidgets);
    expect(find.text('جدیدترین'), findsNothing);
  });

  testWidgets('scrolling up loads older pages; «جدیدترین» jumps back', (
    tester,
  ) async {
    final c = await pumpAt(tester, '/requests/r-121/chat');
    final list = find.byType(Scrollable).first;
    for (var i = 0; i < 20 && chatOf(c).hasOlder; i++) {
      await tester.drag(list, const Offset(0, 800));
      await tester.pumpAndSettle();
    }
    expect(chatOf(c).hasOlder, isFalse);
    expect(chatOf(c).entries.length, greaterThanOrEqualTo(60));

    expect(find.text('جدیدترین'), findsOneWidget);
    await tester.tap(find.text('جدیدترین'));
    await tester.pumpAndSettle();
    expect(find.text('جدیدترین'), findsNothing);
  });

  testWidgets('messages are grouped under Jalali date separators', (
    tester,
  ) async {
    await pumpAt(tester, '/requests/r-121/chat');
    // Messages are 36 hours apart, so every screen shows a day change.
    expect(find.textContaining('۱۴۰۵'), findsWidgets);
  });

  testWidgets('works on a rejected request: send and see it at once', (
    tester,
  ) async {
    await pumpAt(tester, '/requests/r-119/chat');
    expect(find.text('هنوز پیامی نیست.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'لطفاً اصلاح کنید.');
    await tester.tap(find.byTooltip('فرستادن'));
    await tester.pumpAndSettle();
    expect(find.text('لطفاً اصلاح کنید.'), findsOneWidget);
    expect(find.text('شما'), findsOneWidget, reason: 'my bubble is labelled');
  });

  testWidgets('the tile shows a new-message dot until the chat is opened', (
    tester,
  ) async {
    await pumpAt(tester, '/requests/r-124');
    await tester.scrollUntilVisible(
      find.text('گفتگو – ۹ پیام'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('پیام تازه'), findsOneWidget);

    await tester.tap(find.text('گفتگو – ۹ پیام'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('گفتگو – ۹ پیام'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('پیام تازه'), findsNothing);
  });
}
