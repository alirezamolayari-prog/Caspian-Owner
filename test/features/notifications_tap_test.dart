import 'dart:async';

import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/notifications/notification_providers.dart';
import 'package:caspian_owner/features/auth/presentation/lock_screen.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/mock_setup.dart';
import '../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  testWidgets('tapping a notification opens its request', (tester) async {
    final taps = StreamController<String>.broadcast();
    addTearDown(taps.close);
    final h = TestHarness.create(fixtures, signedIn: true);
    addTearDown(h.database.close);
    await tester.pumpWidget(
      h.app(extra: [notificationTapsProvider.overrideWithValue(taps)]),
    );
    await tester.pumpAndSettle();

    taps.add('/requests/r-124');
    await tester.pumpAndSettle();

    final detail = tester.widget<RequestDetailScreen>(
      find.byType(RequestDetailScreen),
    );
    expect(detail.requestId, 'r-124');
  });

  testWidgets('a notification that launched the app opens after unlocking', (
    tester,
  ) async {
    final h = TestHarness.create(fixtures, signedIn: true);
    addTearDown(h.database.close);
    h.authenticator.succeeds = false;
    await tester.pumpWidget(
      h.app(
        extra: [
          launchNotificationTargetProvider.overrideWithValue('/counts/c-6'),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LockScreen), findsOneWidget);

    h.authenticator.succeeds = true;
    await tester.tap(find.text('باز کردن با اثر انگشت'));
    await tester.pumpAndSettle();
    expect(find.text('نتیجه شمارش'), findsOneWidget);
  });
}
