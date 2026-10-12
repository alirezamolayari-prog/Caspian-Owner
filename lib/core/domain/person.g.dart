// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Person _$PersonFromJson(Map<String, dynamic> json) => _Person(
  code: json['code'] as String,
  nameFa: json['name_fa'] as String,
  roleFa: json['role_fa'] as String?,
);

Map<String, dynamic> _$PersonToJson(_Person instance) => <String, dynamic>{
  'code': instance.code,
  'name_fa': instance.nameFa,
  'role_fa': ?instance.roleFa,
};

_Owner _$OwnerFromJson(Map<String, dynamic> json) => _Owner(
  id: json['id'] as String,
  nameFa: json['name_fa'] as String,
  isAdmin: json['is_admin'] as bool,
);

Map<String, dynamic> _$OwnerToJson(_Owner instance) => <String, dynamic>{
  'id': instance.id,
  'name_fa': instance.nameFa,
  'is_admin': instance.isAdmin,
};
