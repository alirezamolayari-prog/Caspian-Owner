import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:caspian_owner/core/widgets/card_segment.dart';
import 'package:caspian_owner/core/widgets/error_state.dart';
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

/// «اعلان‌ها», behind the Home bell. Tapping an event opens its screen.
class NotificationsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final events = ref.watch(recentNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: switch (events) {
        AsyncValue(:final value?) when value.isEmpty => Center(
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Text(
              l10n.notificationsEmpty,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
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
      },
    );
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
