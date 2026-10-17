import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/features/notifications/presentation/notifications_screen.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  testWidgets('the Home bell opens recent notifications; a tap opens its '
      'request', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final harness = TestHarness.create(fixtures, signedIn: true);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('اعلان‌ها'));
    await tester.pumpAndSettle();
    expect(find.byType(NotificationsScreen), findsOneWidget);
    // Newest first: the newest pending request leads.
    expect(find.text('درخواست ۱۲۵ منتظر تأیید شماست'), findsOneWidget);

    await tester.tap(find.text('درخواست ۱۲۵ منتظر تأیید شماست'));
    await tester.pumpAndSettle();
    expect(find.byType(RequestDetailScreen), findsOneWidget);
    expect(find.text('درخواست ۱۲۵'), findsOneWidget);
  });
}
