import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/flows.dart';
import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

/// Headless version of `integration_test/login_approve_test.dart`, so CI
/// (which has no phone) runs the same flow on every PR.
void main() {
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

    final approved = harness.backend.requests.firstWhere(
      (r) => r.id == 'r-125',
    );
    expect(approved.status, RequestStatus.approved);
  });
}
