import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ChatAuthorKind { owner, staff, manager }

@freezed
abstract class ChatAuthor with _$ChatAuthor {
  const factory({
    required ChatAuthorKind kind,
    required String nameFa,

    /// True for messages written by the logged-in owner.
    @Default(false) bool isMe,
  }) = _ChatAuthor;

  factory fromJson(Map<String, Object?> json) => _$ChatAuthorFromJson(json);
}

/// A message in the chat about one request (contract: `ChatMessage`).
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory({
    required String id,
    required String requestId,
    required ChatAuthor author,
    required String text,
    required DateTime sentAt,
  }) = _ChatMessage;

  factory fromJson(Map<String, Object?> json) => _$ChatMessageFromJson(json);
}
