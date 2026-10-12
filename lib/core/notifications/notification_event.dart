import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_event.freezed.dart';
part 'notification_event.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum NotificationEventKind {
  requestEscalated,
  requestDecided,
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
