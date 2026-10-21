import 'dart:async';

import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/domain/place_label.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/security/secure_screen_scope.dart';
import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/stale_notice.dart';
import 'package:caspian_owner/features/chat/presentation/request_chat_tile.dart';
import 'package:caspian_owner/features/requests/application/decision_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/presentation/reject_sheet.dart';
import 'package:caspian_owner/features/requests/presentation/return_for_edit_sheet.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_status_chip.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One request (UI spec 5.3), pushed over the tabs.
class RequestDetailScreen extends ConsumerWidget {
  const new({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(requestDetailProvider(requestId));
    final local = ref.watch(
      decisionControllerProvider.select((all) => all[requestId]),
    );
    final queued =
        ref.watch(queuedRequestIdsProvider).value?.contains(requestId) ?? false;

    ref.listen(decisionControllerProvider.select((all) => all[requestId]), (
      _,
      next,
    ) {
      if (next?.phase == DecisionPhase.conflict && next?.winner != null) {
        unawaited(_showConflict(context, ref, next!.winner!));
      }
    });

    final request = detail.value?.value;
    final canAct =
        request != null && request.canDecide && local == null && !queued;
    // Caspian Server v1 has no «برگشت برای اصلاح»: the bar is hidden there.
    final canReturn =
        ref.watch(serverCapabilitiesProvider).returnForEdit &&
        request != null &&
        request.canReturnForEdit &&
        local == null &&
        !queued;

    return SecureScreenScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            request == null
                ? l10n.requestsTitle
                : l10n.requestTitle(toPersianDigits('${request.number}')),
          ),
        ),
        body: switch (detail) {
          AsyncValue(:final value?) => RefreshIndicator(
            onRefresh: () async {
              await ref.read(decisionControllerProvider.notifier).flush();
              ref.invalidate(requestDetailProvider(requestId));
            },
            child: _DetailBody(
              request: value.value,
              cachedAt: value.cachedAt,
              local: local,
              queued: queued,
            ),
          ),
          AsyncValue(:final error?) => ErrorState(
            error: error,
            onRetry: () => ref.invalidate(requestDetailProvider(requestId)),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
        bottomNavigationBar: switch (local) {
          LocalDecision(phase: DecisionPhase.undoable) => _UndoBar(
            requestId: requestId,
            decision: local,
          ),
          _ when canAct => _DecisionBar(request: request),
          _ when canReturn => _ReturnBar(request: request),
          _ => null,
        },
      ),
    );
  }

  static Future<void> _showConflict(
    BuildContext context,
    WidgetRef ref,
    GoodsRequest winner,
  ) async {
    final l10n = AppLocalizations.of(context);
    final name =
        winner.returnedForEdit?.by.nameFa ?? winner.decidedBy?.nameFa ?? '';
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.conflictTitle),
        content: Text(switch (winner.status) {
          RequestStatus.returned => l10n.conflictReturned(name),
          RequestStatus.rejected => l10n.conflictRejected(name),
          _ => l10n.conflictApproved(name),
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
    ref.read(decisionControllerProvider.notifier).acknowledge(winner.id);
  }
}

class _DetailBody extends ConsumerWidget {
  const new({
    required this.request,
    required this.local,
    required this.queued,
    this.cachedAt,
  });

  final GoodsRequest request;
  final LocalDecision? local;
  final bool queued;
  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final directory = ref.watch(locationDirectoryProvider).value;
    // The server doesn't send stock, 30-day use or same-place history yet.
    final stockInfo = ref.watch(serverCapabilitiesProvider).stockInfo;
    final cachedAt = this.cachedAt;
    final time = formatRelativeTime(
      request.createdAt,
      now: clock.now(),
      l10n: l10n,
    );

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        Space.page,
        Space.sm,
        Space.page,
        Space.lg,
      ),
      children: [
        if (cachedAt != null) ...[
          StaleNotice(cachedAt: cachedAt),
          const SizedBox(height: Space.md),
        ],
        _DecisionBanner(request: request, local: local, queued: queued),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.requestFrom(request.requester.nameFa, time),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    if (local == null && !queued)
                      RequestStatusChip(request.status),
                  ],
                ),
                const SizedBox(height: Space.md),
                for (final line in request.lines) ...[
                  Text(
                    l10n.requestLineTitle(
                      line.itemNameFa,
                      formatNumber(line.qty),
                      line.unitFa,
                    ),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: Space.sm),
                  if (stockInfo)
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            label: l10n.stockNow,
                            value: line.stockNow == null
                                ? l10n.hiddenByCount
                                : l10n.qtyWithUnit(
                                    formatNumber(line.stockNow!),
                                    line.unitFa,
                                  ),
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        Expanded(
                          child: _InfoTile(
                            label: l10n.usedLastMonth,
                            value: l10n.qtyWithUnit(
                              formatNumber(line.usedLast30d),
                              line.unitFa,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: Space.md),
                ],
                _PlaceRow(request: request, directory: directory),
                if (request.note case final note?) ...[
                  const SizedBox(height: Space.md),
                  Text(l10n.noteLabel, style: theme.textTheme.labelMedium),
                  Text(note, style: theme.textTheme.bodyMedium),
                ],
                if (!request.escalated) ...[
                  const SizedBox(height: Space.md),
                  Text(
                    l10n.routineRequestNote,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: Space.md),
        if (stockInfo) ...[
          _LocationHistoryCard(history: request.locationHistory ?? const []),
          const SizedBox(height: Space.md),
        ],
        RequestChatTile(requestId: request.id, summary: request.chatSummary),
      ],
    );
  }
}

/// Who decided and when, or the owner's own just-made decision.
class _DecisionBanner extends StatelessWidget {
  const new({required this.request, required this.local, required this.queued});

  final GoodsRequest request;
  final LocalDecision? local;
  final bool queued;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final scheme = Theme.of(context).colorScheme;
    final local = this.local;

    final (
      String text,
      String? detail,
      Color bg,
      Color fg,
      IconData icon,
    ) = switch ((local, queued, request)) {
      (LocalDecision(phase: DecisionPhase.queued), _, _) || (null, true, _) => (
        l10n.queuedLabel,
        l10n.decisionQueued,
        scheme.surfaceContainer,
        scheme.onSurfaceVariant,
        AppIcons.queued,
      ),
      // Not sent yet: the undo bar at the bottom says what happens.
      (LocalDecision(phase: DecisionPhase.undoable), _, _) => (
        '',
        null,
        scheme.surface,
        scheme.onSurface,
        AppIcons.pending,
      ),
      (LocalDecision(action: DecisionAction.approve), _, _) => (
        l10n.approvedDone,
        null,
        colors.successContainer,
        colors.success,
        AppIcons.approved,
      ),
      (LocalDecision(action: DecisionAction.reject), _, _) => (
        l10n.rejectedDone,
        null,
        scheme.errorContainer,
        scheme.onErrorContainer,
        AppIcons.rejected,
      ),
      (LocalDecision(action: DecisionAction.returnForEdit), _, _) => (
        l10n.returnedDone,
        null,
        scheme.surfaceContainer,
        scheme.onSurface,
        AppIcons.returned,
      ),
      (
        null,
        false,
        GoodsRequest(status: RequestStatus.returned, :final returnedForEdit?),
      ) =>
        (
          l10n.returnedBy(
            returnedForEdit.by.nameFa,
            formatRelativeTime(
              returnedForEdit.at,
              now: clock.now(),
              l10n: l10n,
            ),
          ),
          [
            for (final line in returnedForEdit.lines)
              if (line.removed)
                l10n.returnedLineRemoved(line.itemNameFa)
              else if (line.newQty != line.oldQty)
                l10n.returnedLineChange(
                  line.itemNameFa,
                  formatNumber(line.oldQty),
                  formatNumber(line.newQty),
                  line.unitFa,
                ),
            if (returnedForEdit.note case final note?) l10n.returnedNote(note),
          ].join('\n'),
          scheme.surfaceContainer,
          scheme.onSurface,
          AppIcons.returned,
        ),
      (null, false, GoodsRequest(isDecided: true, :final decidedBy?)) => (
        _decidedText(l10n, request, decidedBy),
        request.decisionReason == null
            ? null
            : l10n.decisionReason(request.decisionReason!),
        request.status == RequestStatus.approved
            ? colors.successContainer
            : scheme.errorContainer,
        request.status == RequestStatus.approved
            ? colors.success
            : scheme.onErrorContainer,
        request.status == RequestStatus.approved
            ? AppIcons.approved
            : AppIcons.rejected,
      ),
      _ => ('', null, scheme.surface, scheme.onSurface, AppIcons.pending),
    };
    if (text.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Semantics(
        liveRegion: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.all(Radius.circular(Radii.card)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: fg),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text, style: theme.titleSmall?.copyWith(color: fg)),
                      if (detail != null)
                        Text(
                          detail,
                          style: theme.bodySmall?.copyWith(color: fg),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _decidedText(
    AppLocalizations l10n,
    GoodsRequest request,
    DecidedBy by,
  ) {
    final name = by.kind == DeciderKind.manager
        ? '${by.nameFa} (${l10n.managerLabel})'
        : by.nameFa;
    final when = request.decidedAt == null
        ? ''
        : formatRelativeTime(request.decidedAt!, now: clock.now(), l10n: l10n);
    return request.status == RequestStatus.approved
        ? l10n.decidedApprovedBy(name, when)
        : l10n.decidedRejectedBy(name, when);
  }
}

class _InfoTile extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(Radii.chip + 6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.md - Space.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            const SizedBox(height: Space.xs),
            Text(value, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const new({required this.request, required this.directory});

  final GoodsRequest request;
  final LocationDirectory? directory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final place = request.place;
    final label =
        directory?.label(place) ??
        toPersianDigits('${place.locationCode} – ${place.floorCode}');
    return Semantics(
      label: '${l10n.placeLabel}: $label',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.place, color: theme.colorScheme.primary),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.placeLabel, style: theme.textTheme.bodySmall),
                Text(label, style: theme.textTheme.titleSmall),
                if (place.usageNote case final note?)
                  Text(note, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// «مصرف قبلی همین محل»: past issues to the same location and floor.
class _LocationHistoryCard extends StatelessWidget {
  const new({required this.history});

  final List<LocationUsage> history;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AppIcons.history, color: theme.colorScheme.primary),
                const SizedBox(width: Space.sm),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.locationHistoryTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.sm),
            if (history.isEmpty)
              Text(l10n.locationHistoryEmpty, style: theme.textTheme.bodySmall)
            else
              for (final usage in history)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.historyLine(
                          usage.itemNameFa,
                          formatNumber(usage.qty),
                          usage.unitFa,
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        l10n.historyMeta(
                          formatJalaliDayMonth(usage.date),
                          usage.documentNo,
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

/// Sticky bottom bar: «رد کردن» and «تأیید», equal width.
class _DecisionBar extends ConsumerWidget {
  const new({required this.request});

  final GoodsRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final number = toPersianDigits('${request.number}');
    final controller = ref.read(decisionControllerProvider.notifier);

    // The undo bar replaces this bar right away (see RequestDetailScreen).
    Future<void> approve() => controller.decide(
      request: request,
      action: DecisionAction.approve,
      fingerprint: AuthPrompt.of(l10n, l10n.approveReason(number)),
    );

    Future<void> reject() async {
      final reason = await showRejectSheet(context, number: number);
      if (reason == null || !context.mounted) return;
      await controller.decide(
        request: request,
        action: DecisionAction.reject,
        reason: reason.isEmpty ? null : reason,
      );
    }

    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                  ),
                  onPressed: reject,
                  child: Text(l10n.reject),
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: FilledButton(
                  onPressed: approve,
                  child: Text(l10n.approve),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Replaces the decision buttons for the 5-second undo window: what will
/// be sent, a countdown, and «بازگرداندن». It lives in this screen only, so
/// it never covers another tab or a text field, and it is gone the moment
/// the window ends (the decision then shows as being sent).
class _UndoBar extends ConsumerStatefulWidget {
  const new({required this.requestId, required this.decision});

  final String requestId;
  final LocalDecision decision;

  @override
  ConsumerState<_UndoBar> createState() => _UndoBarState();
}

class _UndoBarState extends ConsumerState<_UndoBar> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  int get _secondsLeft {
    final until = widget.decision.undoUntil;
    if (until == null) return 0;
    final ms = until.difference(clock.now()).inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final seconds = toPersianDigits('$_secondsLeft');
    final message = switch (widget.decision.action) {
      DecisionAction.approve => l10n.undoApprovePending(seconds),
      DecisionAction.reject => l10n.undoRejectPending(seconds),
      DecisionAction.returnForEdit => l10n.undoReturnPending(seconds),
    };
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: scheme.onInverseSurface),
                  ),
                ),
              ),
              const SizedBox(width: Space.sm),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: scheme.inversePrimary,
                  minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
                ),
                onPressed: () => ref
                    .read(decisionControllerProvider.notifier)
                    .undo(widget.requestId),
                child: Text(l10n.undo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// On a rejected request: «ویرایش و برگرداندن» opens the edit sheet; the
/// request then goes back to the requester (5 seconds to undo, no
/// fingerprint: it isn't an approval).
class _ReturnBar extends ConsumerWidget {
  const new({required this.request});

  final GoodsRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Future<void> edit() async {
      final result = await showReturnForEditSheet(context, request: request);
      if (result == null || !context.mounted) return;
      await ref
          .read(decisionControllerProvider.notifier)
          .decide(
            request: request,
            action: DecisionAction.returnForEdit,
            lines: result.lines,
            note: result.note,
          );
    }

    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: FilledButton.tonalIcon(
            onPressed: edit,
            icon: const Icon(AppIcons.edit),
            label: Text(l10n.returnForEdit),
          ),
        ),
      ),
    );
  }
}
