import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_event.freezed.dart';
part 'notification_event.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum NotificationEventKind {
  requestEscalated,
  requestDecided,

  /// Surprise counts were removed in v0.2.0; a server may still send this.
  /// Parsed (so a batch never fails on it) but never shown: see [isShown].
  countResult,
  chatMessage,
}

/// Something new for the owner (contract: `NotificationEvent`).
@freezed
abstract class NotificationEvent with _$NotificationEvent {
  const factory({
    required String id,
    required NotificationEventKind kind,
    required DateTime at,
    required String titleFa,
    required String bodyFa,

    /// In-app deep link, e.g. `/requests/r-124`.
    required String target,
  }) = _NotificationEvent;

  factory fromJson(Map<String, Object?> json) =>
      _$NotificationEventFromJson(json);
}

/// Whether the app shows [event] (as a notification or in the list).
bool isShown(NotificationEvent event) =>
    event.kind != NotificationEventKind.countResult;
