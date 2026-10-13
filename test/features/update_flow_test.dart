import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_screen.dart';
import 'package:caspian_owner/features/home/presentation/home_screen.dart';
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
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('a newer build offers «به‌روزرسانی» or «بعداً»', (tester) async {
    final h = TestHarness.create(
      fixtures,
      signedIn: true,
      updateChecker: checkerWith(manifestJson(minBuild: 1)),
    );
    addTearDown(h.database.close);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();

    expect(find.text('نسخه تازه آماده است'), findsOneWidget);
    expect(find.textContaining('رفع اشکال'), findsOneWidget);
    await tester.tap(find.text('بعداً'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('نسخه تازه آماده است'), findsNothing);
  });
}
