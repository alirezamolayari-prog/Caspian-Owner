// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationEvent _$NotificationEventFromJson(Map<String, dynamic> json) =>
    _NotificationEvent(
      id: json['id'] as String,
      kind: $enumDecode(_$NotificationEventKindEnumMap, json['kind']),
      at: DateTime.parse(json['at'] as String),
      titleFa: json['title_fa'] as String,
      bodyFa: json['body_fa'] as String,
      target: json['target'] as String,
    );

Map<String, dynamic> _$NotificationEventToJson(_NotificationEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$NotificationEventKindEnumMap[instance.kind]!,
      'at': instance.at.toIso8601String(),
      'title_fa': instance.titleFa,
      'body_fa': instance.bodyFa,
      'target': instance.target,
    };

const _$NotificationEventKindEnumMap = {
  NotificationEventKind.requestEscalated: 'request_escalated',
  NotificationEventKind.requestDecided: 'request_decided',
  NotificationEventKind.countResult: 'count_result',
  NotificationEventKind.chatMessage: 'chat_message',
};
