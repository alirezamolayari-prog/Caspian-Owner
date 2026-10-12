import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

/// Warehouse staff or manager (contract: `Person`).
@freezed
abstract class Person with _$Person {
  const factory({
    required String code,
    required String nameFa,
    String? roleFa,
  }) = _Person;

  factory fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}

/// One of the mall owners (contract: `Owner`).
@freezed
abstract class Owner with _$Owner {
  const factory({
    required String id,
    required String nameFa,
    required bool isAdmin,
  }) = _Owner;

  factory fromJson(Map<String, Object?> json) => _$OwnerFromJson(json);
}
