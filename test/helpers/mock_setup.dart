import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// The fixed "now" used by tests: the fixtures' anchor, so fixture dates
/// stay exactly as written in `assets/mock/`.
final DateTime testNow = MockFixtures.anchor;

Future<MockFixtures> loadTestFixtures() {
  TestWidgetsFlutterBinding.ensureInitialized();
  return MockFixtures.load(rootBundle, now: testNow);
}

/// A backend with no latency, for fast tests.
Future<MockBackend> testBackend({
  MockScenario scenario = MockScenario.normal,
}) async => MockBackend(
  await loadTestFixtures(),
  scenario: scenario,
  latency: Duration.zero,
);
