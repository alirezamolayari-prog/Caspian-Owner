// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatAuthor _$ChatAuthorFromJson(Map<String, dynamic> json) => _ChatAuthor(
  kind: $enumDecode(_$ChatAuthorKindEnumMap, json['kind']),
  nameFa: json['name_fa'] as String,
  isMe: json['is_me'] as bool? ?? false,
);

Map<String, dynamic> _$ChatAuthorToJson(_ChatAuthor instance) =>
    <String, dynamic>{
      'kind': _$ChatAuthorKindEnumMap[instance.kind]!,
      'name_fa': instance.nameFa,
      'is_me': instance.isMe,
    };

const _$ChatAuthorKindEnumMap = {
  ChatAuthorKind.owner: 'owner',
  ChatAuthorKind.staff: 'staff',
  ChatAuthorKind.manager: 'manager',
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  requestId: json['request_id'] as String,
  author: ChatAuthor.fromJson(json['author'] as Map<String, dynamic>),
  text: json['text'] as String,
  sentAt: DateTime.parse(json['sent_at'] as String),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'author': instance.author.toJson(),
      'text': instance.text,
      'sent_at': instance.sentAt.toIso8601String(),
    };
