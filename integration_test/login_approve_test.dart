import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/flows.dart';
import '../test/helpers/mock_setup.dart';
import '../test/helpers/test_app.dart';

/// On a real phone: `flutter test integration_test -d <device>`.
/// The fingerprint prompt is faked so the run needs no one at the phone.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  testWidgets('login → approve a request → it is under «بررسی‌شده»', (
    tester,
  ) async {
    final harness = TestHarness.create(fixtures);
    addTearDown(harness.database.close);
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    await loginApproveAndFindReviewed(tester);
  });
}
