import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_message.freezed.dart';
part 'assistant_message.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum AssistantRole { user, assistant }

/// A message in the «دستیار کاسپین» chat (contract: `AssistantMessage`).
@freezed
abstract class AssistantMessage with _$AssistantMessage {
  const factory({
    required String id,
    required AssistantRole role,
    required String text,
    required DateTime at,
  }) = _AssistantMessage;

  factory fromJson(Map<String, Object?> json) =>
      _$AssistantMessageFromJson(json);
}
