// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssistantMessage _$AssistantMessageFromJson(Map<String, dynamic> json) =>
    _AssistantMessage(
      id: json['id'] as String,
      role: $enumDecode(_$AssistantRoleEnumMap, json['role']),
      text: json['text'] as String,
      at: DateTime.parse(json['at'] as String),
    );

Map<String, dynamic> _$AssistantMessageToJson(_AssistantMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$AssistantRoleEnumMap[instance.role]!,
      'text': instance.text,
      'at': instance.at.toIso8601String(),
    };

const _$AssistantRoleEnumMap = {
  AssistantRole.user: 'user',
  AssistantRole.assistant: 'assistant',
};
