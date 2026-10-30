import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/core/widgets/card_segment.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
import 'package:caspian_owner/core/widgets/server_feature_gate.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The last 30 days of events, newest first (`/v1/notifications`).
final recentNotificationsProvider = FutureProvider<List<NotificationEvent>>(
  (ref) async => [
    for (final e in await ref.watch(notificationSourceProvider).recent())
      if (isShown(e)) e,
  ],
);

/// «اعلان‌ها», behind the bell. Tapping an event opens its screen. A new
/// app version leads the page (it opens «درباره و نسخه»), also while the
/// server has no notification list yet («به‌زودی»).
class NotificationsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final update = ref.watch(availableUpdateProvider);
    final hasList = ref.watch(serverCapabilitiesProvider).extraModules;

    final list = hasList
        ? _EventList(showEmpty: update == null)
        : const NotConnectedBody();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: update == null
          ? list
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.page,
                    Space.page,
                    Space.page,
                    0,
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: _UpdateTile(version: update.version),
                  ),
                ),
                Expanded(child: list),
              ],
            ),
    );
  }
}

/// «نسخه X آماده است – برای دیدن تغییرات و نصب بزنید».
class _UpdateTile extends StatelessWidget {
  const new({required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(AppIcons.update, color: scheme.primary),
      title: Text(l10n.notificationsUpdateTitle(toPersianDigits(version))),
      subtitle: Text(l10n.notificationsUpdateBody),
      trailing: const Icon(AppIcons.forward),
      onTap: () => context.push(Routes.about),
    );
  }
}

/// The server's events of the last 30 days.
class _EventList extends ConsumerWidget {
  const new({required this.showEmpty});

  /// «اعلانی نیست» (not when the update row is already on the page).
  final bool showEmpty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final events = ref.watch(recentNotificationsProvider);

    return switch (events) {
      AsyncValue(:final value?) when value.isEmpty =>
        showEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Text(
                    l10n.notificationsEmpty,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      AsyncValue(:final value?) => RefreshIndicator(
        onRefresh: () => ref.refresh(recentNotificationsProvider.future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              // Edge to edge (Android 15): keep the last row above the
              // system navigation bar.
              padding: const EdgeInsets.all(Space.page).add(
                EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
              ),
              sliver: CardSliverList(
                itemCount: value.length,
                itemBuilder: (context, i) => _EventTile(event: value[i]),
              ),
            ),
          ],
        ),
      ),
      AsyncValue(:final error?) => ErrorState(
        error: error,
        onRetry: () => ref.invalidate(recentNotificationsProvider),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _EventTile extends StatelessWidget {
  const new({required this.event});

  final NotificationEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final time = formatRelativeTime(event.at, now: clock.now(), l10n: l10n);
    return ListTile(
      leading: Icon(switch (event.kind) {
        NotificationEventKind.chatMessage => AppIcons.chat,
        NotificationEventKind.requestDecided => AppIcons.approved,
        _ => AppIcons.requests,
      }, color: Theme.of(context).colorScheme.primary),
      title: Text(event.titleFa),
      subtitle: Text('${event.bodyFa}\n$time'),
      isThreeLine: true,
      onTap: () => context.push(event.target),
    );
  }
}
