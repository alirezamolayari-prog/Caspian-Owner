// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantMessage {

 String get id; AssistantRole get role; String get text; DateTime get at;
/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantMessageCopyWith<AssistantMessage> get copyWith => _$AssistantMessageCopyWithImpl<AssistantMessage>(this as AssistantMessage, _$identity);

  /// Serializes this AssistantMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.at, _this.at) || other.at == _this.at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantMessage;
  return Object.hash(runtimeType,_this.id,_this.role,_this.text,_this.at);
}

@override
String toString() {
  final _this = this as AssistantMessage;
  return 'AssistantMessage(id: ${_this.id}, role: ${_this.role}, text: ${_this.text}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $AssistantMessageCopyWith<$Res>  {
  factory $AssistantMessageCopyWith(AssistantMessage value, $Res Function(AssistantMessage) _then) = _$AssistantMessageCopyWithImpl;
@useResult
$Res call({
 String id, AssistantRole role, String text, DateTime at
});




}
/// @nodoc
class _$AssistantMessageCopyWithImpl<$Res>
    implements $AssistantMessageCopyWith<$Res> {
  _$AssistantMessageCopyWithImpl(this._self, this._then);

  final AssistantMessage _self;
  final $Res Function(AssistantMessage) _then;

/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? text = null,Object? at = null,}) {
  return _then(AssistantMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AssistantRole,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantMessage].
extension AssistantMessagePatterns on AssistantMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantMessage value)  $default,){
final _that = this;
switch (_that) {
case _AssistantMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AssistantRole role,  String text,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
return $default(_that.id,_that.role,_that.text,_that.at);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AssistantRole role,  String text,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _AssistantMessage():
return $default(_that.id,_that.role,_that.text,_that.at);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AssistantRole role,  String text,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
return $default(_that.id,_that.role,_that.text,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantMessage implements AssistantMessage {
  const _AssistantMessage({required this.id, required this.role, required this.text, required this.at});
  factory _AssistantMessage.fromJson(Map<String, dynamic> json) => _$AssistantMessageFromJson(json);

@override final  String id;
@override final  AssistantRole role;
@override final  String text;
@override final  DateTime at;

/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantMessageCopyWith<_AssistantMessage> get copyWith => __$AssistantMessageCopyWithImpl<_AssistantMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.text, text) || other.text == text)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,role,text,at);
}

@override
String toString() {
    return 'AssistantMessage(id: $id, role: $role, text: $text, at: $at)';
}


}

/// @nodoc
abstract mixin class _$AssistantMessageCopyWith<$Res> implements $AssistantMessageCopyWith<$Res> {
  factory _$AssistantMessageCopyWith(_AssistantMessage value, $Res Function(_AssistantMessage) _then) = __$AssistantMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, AssistantRole role, String text, DateTime at
});




}
/// @nodoc
class __$AssistantMessageCopyWithImpl<$Res>
    implements _$AssistantMessageCopyWith<$Res> {
  __$AssistantMessageCopyWithImpl(this._self, this._then);

  final _AssistantMessage _self;
  final $Res Function(_AssistantMessage) _then;

/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? text = null,Object? at = null,}) {
  return _then(_AssistantMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AssistantRole,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
