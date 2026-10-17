import 'package:caspian_owner/core/notifications/notification_event.dart';

/// New events for the owner, and the server time to ask from next time.
class NotificationBatch {
  const new({required this.events, required this.serverTime});

  final List<NotificationEvent> events;
  final DateTime serverTime;
}

/// Where notifications come from. Today: polling `/v1/notifications/poll`
/// with workmanager (no Firebase). Later a push channel (UnifiedPush, ntfy)
/// can replace it without touching the UI.
abstract interface class NotificationSource {
  Future<NotificationBatch> poll({required DateTime since});

  /// The last 30 days, newest first (`/v1/notifications`), for the list
  /// behind the Home bell.
  Future<List<NotificationEvent>> recent({int limit = 50});
}
