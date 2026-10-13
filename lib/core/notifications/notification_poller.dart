import 'dart:convert';

import 'package:caspian_owner/core/notifications/notification_event.dart';
import 'package:caspian_owner/core/notifications/notification_source.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:clock/clock.dart';

/// Shows one notification on the phone.
abstract interface class LocalNotifier {
  Future<void> show(NotificationEvent event);
}

/// One background check: asks the [source] for events since the last
/// check, shows each new one once, and remembers what it showed.
class NotificationPoller {
  const new({
    required this.source,
    required this.store,
    required this.notifier,
  });

  static const sinceKey = 'notif_since';
  static const shownKey = 'notif_shown';

  /// Ids remembered to avoid repeats.
  static const keepIds = 300;

  /// First run: look back this far.
  static const firstLookBack = Duration(hours: 1);

  final NotificationSource source;
  final SecureStore store;
  final LocalNotifier notifier;

  /// Returns how many notifications were shown.
  Future<int> run() async {
    final sinceRaw = await store.read(sinceKey);
    final since = sinceRaw == null
        ? clock.now().subtract(firstLookBack)
        : DateTime.parse(sinceRaw);
    final shownRaw = await store.read(shownKey);
    final shown = <String>[
      if (shownRaw != null) ...(jsonDecode(shownRaw) as List<Object?>).cast(),
    ];

    final batch = await source.poll(since: since);
    final fresh = [
      for (final e in batch.events)
        if (!shown.contains(e.id)) e,
    ];
    for (final event in fresh) {
      await notifier.show(event);
      shown.add(event.id);
    }

    final kept = shown.length > keepIds
        ? shown.sublist(shown.length - keepIds)
        : shown;
    await store.write(shownKey, jsonEncode(kept));
    await store.write(sinceKey, batch.serverTime.toUtc().toIso8601String());
    return fresh.length;
  }
}
