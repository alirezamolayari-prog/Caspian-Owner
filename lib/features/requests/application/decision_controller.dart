import 'dart:async';

import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where an owner's decision is, from the tap to the server.
enum DecisionPhase {
  /// Shown as done; can still be undone (5 seconds).
  undoable,

  /// Being sent.
  sending,

  /// Offline: waiting in the queue («در صف ارسال»).
  queued,

  /// Someone else decided first (`409`); [LocalDecision.winner] says who.
  conflict,
}

class LocalDecision {
  const new({
    required this.action,
    required this.phase,
    this.reason,
    this.winner,
    this.undoUntil,
  });

  final DecisionAction action;
  final DecisionPhase phase;
  final String? reason;

  /// The request as decided by someone else (conflict only).
  final GoodsRequest? winner;

  /// When the undo window ends (undoable only).
  final DateTime? undoUntil;

  LocalDecision copyWith({DecisionPhase? phase, GoodsRequest? winner}) =>
      LocalDecision(
        action: action,
        reason: reason,
        phase: phase ?? this.phase,
        winner: winner ?? this.winner,
        undoUntil: undoUntil,
      );
}

final decisionControllerProvider =
    NotifierProvider<DecisionController, Map<String, LocalDecision>>(
      DecisionController.new,
    );

/// Approve/reject flow:
/// 1. (approve) one fingerprint touch, if that setting is on;
/// 2. shown as done right away, with 5 seconds to undo;
/// 3. then queued with an idempotency key and sent. Offline it stays queued;
///    `409` means someone else decided first.
/// Lives app-wide, so leaving the screen doesn't cancel a decision.
class DecisionController extends Notifier<Map<String, LocalDecision>> {
  static const undoWindow = Duration(seconds: 5);

  final Map<String, Timer> _timers = {};

  @override
  Map<String, LocalDecision> build() {
    ref.onDispose(() {
      for (final timer in _timers.values) {
        timer.cancel();
      }
    });
    return const {};
  }

  /// Starts a decision. [fingerprint] (approvals) asks for one touch if that
  /// setting is on. Returns false if the fingerprint check failed.
  Future<bool> decide({
    required GoodsRequest request,
    required DecisionAction action,
    AuthPrompt? fingerprint,
    String? reason,
  }) async {
    final settings = ref.read(settingsControllerProvider);
    if (fingerprint != null && settings.fingerprintForApproval) {
      final ok = await ref
          .read(deviceAuthenticatorProvider)
          .authenticate(fingerprint);
      if (!ok) return false;
    }
    _set(
      request.id,
      LocalDecision(
        action: action,
        reason: reason,
        phase: DecisionPhase.undoable,
        undoUntil: clock.now().add(undoWindow),
      ),
    );
    _timers[request.id]?.cancel();
    _timers[request.id] = Timer(undoWindow, () => _commit(request.id));
    return true;
  }

  /// Cancels a decision within the undo window. Nothing was sent.
  /// Returns false when it's too late (already being sent).
  bool undo(String requestId) {
    final local = state[requestId];
    if (local == null || local.phase != DecisionPhase.undoable) return false;
    _timers.remove(requestId)?.cancel();
    _remove(requestId);
    return true;
  }

  /// The owner saw the conflict message.
  void acknowledge(String requestId) => _remove(requestId);

  Future<void> _commit(String requestId) async {
    _timers.remove(requestId);
    final local = state[requestId];
    if (local == null) return;
    _set(requestId, local.copyWith(phase: DecisionPhase.sending));
    await ref
        .read(pendingDecisionQueueProvider)
        .enqueue(
          requestId: requestId,
          action: local.action,
          reason: local.reason,
        );
    await flush();
  }

  /// Sends everything in the queue (also on refresh and app resume).
  Future<void> flush() async {
    final result = await ref
        .read(pendingDecisionQueueProvider)
        .flush(ref.read(requestsRepositoryProvider));

    for (final applied in result.applied) {
      _remove(applied.id);
      _refresh(applied.id);
    }
    for (final winner in result.conflicts) {
      final local =
          state[winner.id] ??
          const LocalDecision(
            action: DecisionAction.approve,
            phase: DecisionPhase.conflict,
          );
      _set(
        winner.id,
        local.copyWith(phase: DecisionPhase.conflict, winner: winner),
      );
      _refresh(winner.id);
    }
    // Anything still sending is now waiting offline.
    for (final MapEntry(:key, :value) in state.entries.toList()) {
      if (value.phase == DecisionPhase.sending) {
        _set(key, value.copyWith(phase: DecisionPhase.queued));
      }
    }
  }

  void _refresh(String requestId) {
    ref
      ..invalidate(requestDetailProvider(requestId))
      ..invalidate(requestsControllerProvider)
      ..invalidate(homeControllerProvider);
  }

  void _set(String id, LocalDecision decision) =>
      state = {...state, id: decision};

  void _remove(String id) {
    if (!state.containsKey(id)) return;
    state = {...state}..remove(id);
  }
}
