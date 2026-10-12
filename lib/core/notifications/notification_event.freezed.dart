// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationEvent {

 String get id; NotificationEventKind get kind; DateTime get at; String get titleFa; String get bodyFa;/// In-app deep link, e.g. `/requests/r-124`.
 String get target;
/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEventCopyWith<NotificationEvent> get copyWith => _$NotificationEventCopyWithImpl<NotificationEvent>(this as NotificationEvent, _$identity);

  /// Serializes this NotificationEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.titleFa, _this.titleFa) || other.titleFa == _this.titleFa)&&(identical(other.bodyFa, _this.bodyFa) || other.bodyFa == _this.bodyFa)&&(identical(other.target, _this.target) || other.target == _this.target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationEvent;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.at,_this.titleFa,_this.bodyFa,_this.target);
}

@override
String toString() {
  final _this = this as NotificationEvent;
  return 'NotificationEvent(id: ${_this.id}, kind: ${_this.kind}, at: ${_this.at}, titleFa: ${_this.titleFa}, bodyFa: ${_this.bodyFa}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $NotificationEventCopyWith<$Res>  {
  factory $NotificationEventCopyWith(NotificationEvent value, $Res Function(NotificationEvent) _then) = _$NotificationEventCopyWithImpl;
@useResult
$Res call({
 String id, NotificationEventKind kind, DateTime at, String titleFa, String bodyFa, String target
});




}
/// @nodoc
class _$NotificationEventCopyWithImpl<$Res>
    implements $NotificationEventCopyWith<$Res> {
  _$NotificationEventCopyWithImpl(this._self, this._then);

  final NotificationEvent _self;
  final $Res Function(NotificationEvent) _then;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? at = null,Object? titleFa = null,Object? bodyFa = null,Object? target = null,}) {
  return _then(NotificationEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationEventKind,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,titleFa: null == titleFa ? _self.titleFa : titleFa // ignore: cast_nullable_to_non_nullable
as String,bodyFa: null == bodyFa ? _self.bodyFa : bodyFa // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationEvent].
extension NotificationEventPatterns on NotificationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEvent value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEvent value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  NotificationEventKind kind,  DateTime at,  String titleFa,  String bodyFa,  String target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
return $default(_that.id,_that.kind,_that.at,_that.titleFa,_that.bodyFa,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  NotificationEventKind kind,  DateTime at,  String titleFa,  String bodyFa,  String target)  $default,) {final _that = this;
switch (_that) {
case _NotificationEvent():
return $default(_that.id,_that.kind,_that.at,_that.titleFa,_that.bodyFa,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  NotificationEventKind kind,  DateTime at,  String titleFa,  String bodyFa,  String target)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
return $default(_that.id,_that.kind,_that.at,_that.titleFa,_that.bodyFa,_that.target);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationEvent implements NotificationEvent {
  const _NotificationEvent({required this.id, required this.kind, required this.at, required this.titleFa, required this.bodyFa, required this.target});
  factory _NotificationEvent.fromJson(Map<String, dynamic> json) => _$NotificationEventFromJson(json);

@override final  String id;
@override final  NotificationEventKind kind;
@override final  DateTime at;
@override final  String titleFa;
@override final  String bodyFa;
/// In-app deep link, e.g. `/requests/r-124`.
@override final  String target;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEventCopyWith<_NotificationEvent> get copyWith => __$NotificationEventCopyWithImpl<_NotificationEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.at, at) || other.at == at)&&(identical(other.titleFa, titleFa) || other.titleFa == titleFa)&&(identical(other.bodyFa, bodyFa) || other.bodyFa == bodyFa)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,at,titleFa,bodyFa,target);
}

@override
String toString() {
    return 'NotificationEvent(id: $id, kind: $kind, at: $at, titleFa: $titleFa, bodyFa: $bodyFa, target: $target)';
}


}

/// @nodoc
abstract mixin class _$NotificationEventCopyWith<$Res> implements $NotificationEventCopyWith<$Res> {
  factory _$NotificationEventCopyWith(_NotificationEvent value, $Res Function(_NotificationEvent) _then) = __$NotificationEventCopyWithImpl;
@override @useResult
$Res call({
 String id, NotificationEventKind kind, DateTime at, String titleFa, String bodyFa, String target
});




}
/// @nodoc
class __$NotificationEventCopyWithImpl<$Res>
    implements _$NotificationEventCopyWith<$Res> {
  __$NotificationEventCopyWithImpl(this._self, this._then);

  final _NotificationEvent _self;
  final $Res Function(_NotificationEvent) _then;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? at = null,Object? titleFa = null,Object? bodyFa = null,Object? target = null,}) {
  return _then(_NotificationEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationEventKind,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,titleFa: null == titleFa ? _self.titleFa : titleFa // ignore: cast_nullable_to_non_nullable
as String,bodyFa: null == bodyFa ? _self.bodyFa : bodyFa // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
