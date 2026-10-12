import 'dart:async';

import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/features/requests/application/decision_controller.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_setup.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockFixtures fixtures;
  setUpAll(() async => fixtures = await loadTestFixtures());

  /// Runs [body] on a fake clock with a fresh app container.
  void run(
    void Function(
      FakeAsync time,
      ProviderContainer container,
      TestHarness harness,
    )
    body,
  ) {
    fakeAsync((time) {
      final harness = TestHarness.create(fixtures, signedIn: true);
      final container = harness.container();
      body(time, container, harness);
      container.dispose();
      unawaited(harness.database.close());
      time.flushMicrotasks();
    });
  }

  GoodsRequest request(TestHarness h, String id) =>
      h.backend.requests.firstWhere((r) => r.id == id);

  void decide(
    FakeAsync time,
    ProviderContainer c,
    TestHarness h,
    DecisionAction action, {
    String? reason,
  }) {
    // On the fake clock, futures are driven by flushMicrotasks/elapse.
    unawaited(
      c
          .read(decisionControllerProvider.notifier)
          .decide(
            request: request(h, 'r-124'),
            action: action,
            reason: reason,
            fingerprintReason: 'ok?',
          ),
    );
    time.flushMicrotasks();
  }

  test('approve: shown at once, sent after the 5-second undo window', () {
    run((time, c, h) {
      decide(time, c, h, DecisionAction.approve);
      expect(h.authenticator.prompts, 1);
      expect(
        c.read(decisionControllerProvider)['r-124']!.phase,
        DecisionPhase.undoable,
      );
      expect(request(h, 'r-124').status, RequestStatus.pending);

      time
        ..elapse(DecisionController.undoWindow)
        ..flushMicrotasks();
      expect(request(h, 'r-124').status, RequestStatus.approved);
      expect(request(h, 'r-124').decidedBy!.nameFa, 'علیرضا');
      expect(c.read(decisionControllerProvider), isEmpty);
    });
  });

  test('undo within the window sends nothing', () {
    run((time, c, h) {
      decide(time, c, h, DecisionAction.approve);
      time.elapse(const Duration(seconds: 3));
      c.read(decisionControllerProvider.notifier).undo('r-124');
      time
        ..elapse(const Duration(seconds: 10))
        ..flushMicrotasks();
      expect(request(h, 'r-124').status, RequestStatus.pending);
      expect(c.read(decisionControllerProvider), isEmpty);
    });
  });

  test('a failed fingerprint decides nothing', () {
    run((time, c, h) {
      h.authenticator.succeeds = false;
      decide(time, c, h, DecisionAction.approve);
      expect(c.read(decisionControllerProvider), isEmpty);
    });
  });

  test('with the fingerprint setting off, approving needs no touch', () {
    run((time, c, h) {
      c
          .read(settingsControllerProvider.notifier)
          .setFingerprintForApproval(enabled: false);
      decide(time, c, h, DecisionAction.approve);
      expect(h.authenticator.prompts, 0);
      expect(c.read(decisionControllerProvider), contains('r-124'));
    });
  });

  test('reject needs no fingerprint and keeps the reason', () {
    run((time, c, h) {
      decide(time, c, h, DecisionAction.reject, reason: 'زیاد است');
      expect(h.authenticator.prompts, 0);
      time
        ..elapse(DecisionController.undoWindow)
        ..flushMicrotasks();
      expect(request(h, 'r-124').status, RequestStatus.rejected);
      expect(request(h, 'r-124').decisionReason, 'زیاد است');
    });
  });

  test('offline: queued, then sent once back online', () {
    run((time, c, h) {
      h.backend.scenario = MockScenario.offline;
      decide(time, c, h, DecisionAction.approve);
      time
        ..elapse(DecisionController.undoWindow)
        ..flushMicrotasks();
      expect(
        c.read(decisionControllerProvider)['r-124']!.phase,
        DecisionPhase.queued,
      );
      late List<Decision> queued;
      unawaited(
        c.read(pendingDecisionQueueProvider).pending().then((q) => queued = q),
      );
      time.flushMicrotasks();
      expect(queued.single.requestId, 'r-124');

      h.backend.scenario = MockScenario.normal;
      unawaited(c.read(decisionControllerProvider.notifier).flush());
      time.flushMicrotasks();
      expect(request(h, 'r-124').status, RequestStatus.approved);
      expect(c.read(decisionControllerProvider), isEmpty);
    });
  });

  test('409: someone else decided first; the owner is told who', () {
    run((time, c, h) {
      h.backend.scenario = MockScenario.conflict;
      decide(time, c, h, DecisionAction.approve);
      time
        ..elapse(DecisionController.undoWindow)
        ..flushMicrotasks();
      final local = c.read(decisionControllerProvider)['r-124']!;
      expect(local.phase, DecisionPhase.conflict);
      expect(local.winner!.decidedBy!.nameFa, isNot('علیرضا'));

      c.read(decisionControllerProvider.notifier).acknowledge('r-124');
      expect(c.read(decisionControllerProvider), isEmpty);
    });
  });
}
