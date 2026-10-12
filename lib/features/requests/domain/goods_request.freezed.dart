// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DecidedBy {

 DeciderKind get kind; String get nameFa;
/// Create a copy of DecidedBy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DecidedByCopyWith<DecidedBy> get copyWith => _$DecidedByCopyWithImpl<DecidedBy>(this as DecidedBy, _$identity);

  /// Serializes this DecidedBy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DecidedBy;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DecidedBy&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.nameFa, _this.nameFa) || other.nameFa == _this.nameFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DecidedBy;
  return Object.hash(runtimeType,_this.kind,_this.nameFa);
}

@override
String toString() {
  final _this = this as DecidedBy;
  return 'DecidedBy(kind: ${_this.kind}, nameFa: ${_this.nameFa})';
}


}

/// @nodoc
abstract mixin class $DecidedByCopyWith<$Res>  {
  factory $DecidedByCopyWith(DecidedBy value, $Res Function(DecidedBy) _then) = _$DecidedByCopyWithImpl;
@useResult
$Res call({
 DeciderKind kind, String nameFa
});




}
/// @nodoc
class _$DecidedByCopyWithImpl<$Res>
    implements $DecidedByCopyWith<$Res> {
  _$DecidedByCopyWithImpl(this._self, this._then);

  final DecidedBy _self;
  final $Res Function(DecidedBy) _then;

/// Create a copy of DecidedBy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? nameFa = null,}) {
  return _then(DecidedBy(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeciderKind,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DecidedBy].
extension DecidedByPatterns on DecidedBy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DecidedBy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DecidedBy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DecidedBy value)  $default,){
final _that = this;
switch (_that) {
case _DecidedBy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DecidedBy value)?  $default,){
final _that = this;
switch (_that) {
case _DecidedBy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeciderKind kind,  String nameFa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DecidedBy() when $default != null:
return $default(_that.kind,_that.nameFa);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeciderKind kind,  String nameFa)  $default,) {final _that = this;
switch (_that) {
case _DecidedBy():
return $default(_that.kind,_that.nameFa);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeciderKind kind,  String nameFa)?  $default,) {final _that = this;
switch (_that) {
case _DecidedBy() when $default != null:
return $default(_that.kind,_that.nameFa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DecidedBy implements DecidedBy {
  const _DecidedBy({required this.kind, required this.nameFa});
  factory _DecidedBy.fromJson(Map<String, dynamic> json) => _$DecidedByFromJson(json);

@override final  DeciderKind kind;
@override final  String nameFa;

/// Create a copy of DecidedBy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DecidedByCopyWith<_DecidedBy> get copyWith => __$DecidedByCopyWithImpl<_DecidedBy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DecidedByToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DecidedBy&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.nameFa, nameFa) || other.nameFa == nameFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,nameFa);
}

@override
String toString() {
    return 'DecidedBy(kind: $kind, nameFa: $nameFa)';
}


}

/// @nodoc
abstract mixin class _$DecidedByCopyWith<$Res> implements $DecidedByCopyWith<$Res> {
  factory _$DecidedByCopyWith(_DecidedBy value, $Res Function(_DecidedBy) _then) = __$DecidedByCopyWithImpl;
@override @useResult
$Res call({
 DeciderKind kind, String nameFa
});




}
/// @nodoc
class __$DecidedByCopyWithImpl<$Res>
    implements _$DecidedByCopyWith<$Res> {
  __$DecidedByCopyWithImpl(this._self, this._then);

  final _DecidedBy _self;
  final $Res Function(_DecidedBy) _then;

/// Create a copy of DecidedBy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? nameFa = null,}) {
  return _then(_DecidedBy(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeciderKind,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RequestLine {

 String get itemCode; String get itemNameFa; double get qty; String get unitFa;/// Null while the item is hidden by a running surprise count.
@JsonKey(includeIfNull: true) double? get stockNow;@JsonKey(name: 'used_last_30d') double get usedLast30d;
/// Create a copy of RequestLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestLineCopyWith<RequestLine> get copyWith => _$RequestLineCopyWithImpl<RequestLine>(this as RequestLine, _$identity);

  /// Serializes this RequestLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RequestLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestLine&&(identical(other.itemCode, _this.itemCode) || other.itemCode == _this.itemCode)&&(identical(other.itemNameFa, _this.itemNameFa) || other.itemNameFa == _this.itemNameFa)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitFa, _this.unitFa) || other.unitFa == _this.unitFa)&&(identical(other.stockNow, _this.stockNow) || other.stockNow == _this.stockNow)&&(identical(other.usedLast30d, _this.usedLast30d) || other.usedLast30d == _this.usedLast30d));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RequestLine;
  return Object.hash(runtimeType,_this.itemCode,_this.itemNameFa,_this.qty,_this.unitFa,_this.stockNow,_this.usedLast30d);
}

@override
String toString() {
  final _this = this as RequestLine;
  return 'RequestLine(itemCode: ${_this.itemCode}, itemNameFa: ${_this.itemNameFa}, qty: ${_this.qty}, unitFa: ${_this.unitFa}, stockNow: ${_this.stockNow}, usedLast30d: ${_this.usedLast30d})';
}


}

/// @nodoc
abstract mixin class $RequestLineCopyWith<$Res>  {
  factory $RequestLineCopyWith(RequestLine value, $Res Function(RequestLine) _then) = _$RequestLineCopyWithImpl;
@useResult
$Res call({
 String itemCode, String itemNameFa, double qty, String unitFa,@JsonKey(includeIfNull: true) double? stockNow,@JsonKey(name: 'used_last_30d') double usedLast30d
});




}
/// @nodoc
class _$RequestLineCopyWithImpl<$Res>
    implements $RequestLineCopyWith<$Res> {
  _$RequestLineCopyWithImpl(this._self, this._then);

  final RequestLine _self;
  final $Res Function(RequestLine) _then;

/// Create a copy of RequestLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemCode = null,Object? itemNameFa = null,Object? qty = null,Object? unitFa = null,Object? stockNow = freezed,Object? usedLast30d = null,}) {
  return _then(RequestLine(
itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,stockNow: freezed == stockNow ? _self.stockNow : stockNow // ignore: cast_nullable_to_non_nullable
as double?,usedLast30d: null == usedLast30d ? _self.usedLast30d : usedLast30d // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestLine].
extension RequestLinePatterns on RequestLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestLine value)  $default,){
final _that = this;
switch (_that) {
case _RequestLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestLine value)?  $default,){
final _that = this;
switch (_that) {
case _RequestLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemCode,  String itemNameFa,  double qty,  String unitFa, @JsonKey(includeIfNull: true)  double? stockNow, @JsonKey(name: 'used_last_30d')  double usedLast30d)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestLine() when $default != null:
return $default(_that.itemCode,_that.itemNameFa,_that.qty,_that.unitFa,_that.stockNow,_that.usedLast30d);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemCode,  String itemNameFa,  double qty,  String unitFa, @JsonKey(includeIfNull: true)  double? stockNow, @JsonKey(name: 'used_last_30d')  double usedLast30d)  $default,) {final _that = this;
switch (_that) {
case _RequestLine():
return $default(_that.itemCode,_that.itemNameFa,_that.qty,_that.unitFa,_that.stockNow,_that.usedLast30d);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemCode,  String itemNameFa,  double qty,  String unitFa, @JsonKey(includeIfNull: true)  double? stockNow, @JsonKey(name: 'used_last_30d')  double usedLast30d)?  $default,) {final _that = this;
switch (_that) {
case _RequestLine() when $default != null:
return $default(_that.itemCode,_that.itemNameFa,_that.qty,_that.unitFa,_that.stockNow,_that.usedLast30d);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestLine implements RequestLine {
  const _RequestLine({required this.itemCode, required this.itemNameFa, required this.qty, required this.unitFa, @JsonKey(includeIfNull: true) required this.stockNow, @JsonKey(name: 'used_last_30d') required this.usedLast30d});
  factory _RequestLine.fromJson(Map<String, dynamic> json) => _$RequestLineFromJson(json);

@override final  String itemCode;
@override final  String itemNameFa;
@override final  double qty;
@override final  String unitFa;
/// Null while the item is hidden by a running surprise count.
@override@JsonKey(includeIfNull: true) final  double? stockNow;
@override@JsonKey(name: 'used_last_30d') final  double usedLast30d;

/// Create a copy of RequestLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestLineCopyWith<_RequestLine> get copyWith => __$RequestLineCopyWithImpl<_RequestLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestLine&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemNameFa, itemNameFa) || other.itemNameFa == itemNameFa)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitFa, unitFa) || other.unitFa == unitFa)&&(identical(other.stockNow, stockNow) || other.stockNow == stockNow)&&(identical(other.usedLast30d, usedLast30d) || other.usedLast30d == usedLast30d));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemCode,itemNameFa,qty,unitFa,stockNow,usedLast30d);
}

@override
String toString() {
    return 'RequestLine(itemCode: $itemCode, itemNameFa: $itemNameFa, qty: $qty, unitFa: $unitFa, stockNow: $stockNow, usedLast30d: $usedLast30d)';
}


}

/// @nodoc
abstract mixin class _$RequestLineCopyWith<$Res> implements $RequestLineCopyWith<$Res> {
  factory _$RequestLineCopyWith(_RequestLine value, $Res Function(_RequestLine) _then) = __$RequestLineCopyWithImpl;
@override @useResult
$Res call({
 String itemCode, String itemNameFa, double qty, String unitFa,@JsonKey(includeIfNull: true) double? stockNow,@JsonKey(name: 'used_last_30d') double usedLast30d
});




}
/// @nodoc
class __$RequestLineCopyWithImpl<$Res>
    implements _$RequestLineCopyWith<$Res> {
  __$RequestLineCopyWithImpl(this._self, this._then);

  final _RequestLine _self;
  final $Res Function(_RequestLine) _then;

/// Create a copy of RequestLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemCode = null,Object? itemNameFa = null,Object? qty = null,Object? unitFa = null,Object? stockNow = freezed,Object? usedLast30d = null,}) {
  return _then(_RequestLine(
itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,stockNow: freezed == stockNow ? _self.stockNow : stockNow // ignore: cast_nullable_to_non_nullable
as double?,usedLast30d: null == usedLast30d ? _self.usedLast30d : usedLast30d // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$LocationUsage {

 DateTime get date; String get itemNameFa; double get qty; String get unitFa; String get documentNo;
/// Create a copy of LocationUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationUsageCopyWith<LocationUsage> get copyWith => _$LocationUsageCopyWithImpl<LocationUsage>(this as LocationUsage, _$identity);

  /// Serializes this LocationUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocationUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationUsage&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.itemNameFa, _this.itemNameFa) || other.itemNameFa == _this.itemNameFa)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitFa, _this.unitFa) || other.unitFa == _this.unitFa)&&(identical(other.documentNo, _this.documentNo) || other.documentNo == _this.documentNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocationUsage;
  return Object.hash(runtimeType,_this.date,_this.itemNameFa,_this.qty,_this.unitFa,_this.documentNo);
}

@override
String toString() {
  final _this = this as LocationUsage;
  return 'LocationUsage(date: ${_this.date}, itemNameFa: ${_this.itemNameFa}, qty: ${_this.qty}, unitFa: ${_this.unitFa}, documentNo: ${_this.documentNo})';
}


}

/// @nodoc
abstract mixin class $LocationUsageCopyWith<$Res>  {
  factory $LocationUsageCopyWith(LocationUsage value, $Res Function(LocationUsage) _then) = _$LocationUsageCopyWithImpl;
@useResult
$Res call({
 DateTime date, String itemNameFa, double qty, String unitFa, String documentNo
});




}
/// @nodoc
class _$LocationUsageCopyWithImpl<$Res>
    implements $LocationUsageCopyWith<$Res> {
  _$LocationUsageCopyWithImpl(this._self, this._then);

  final LocationUsage _self;
  final $Res Function(LocationUsage) _then;

/// Create a copy of LocationUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? itemNameFa = null,Object? qty = null,Object? unitFa = null,Object? documentNo = null,}) {
  return _then(LocationUsage(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,documentNo: null == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationUsage].
extension LocationUsagePatterns on LocationUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationUsage value)  $default,){
final _that = this;
switch (_that) {
case _LocationUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationUsage value)?  $default,){
final _that = this;
switch (_that) {
case _LocationUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  String itemNameFa,  double qty,  String unitFa,  String documentNo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationUsage() when $default != null:
return $default(_that.date,_that.itemNameFa,_that.qty,_that.unitFa,_that.documentNo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  String itemNameFa,  double qty,  String unitFa,  String documentNo)  $default,) {final _that = this;
switch (_that) {
case _LocationUsage():
return $default(_that.date,_that.itemNameFa,_that.qty,_that.unitFa,_that.documentNo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  String itemNameFa,  double qty,  String unitFa,  String documentNo)?  $default,) {final _that = this;
switch (_that) {
case _LocationUsage() when $default != null:
return $default(_that.date,_that.itemNameFa,_that.qty,_that.unitFa,_that.documentNo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationUsage implements LocationUsage {
  const _LocationUsage({required this.date, required this.itemNameFa, required this.qty, required this.unitFa, required this.documentNo});
  factory _LocationUsage.fromJson(Map<String, dynamic> json) => _$LocationUsageFromJson(json);

@override final  DateTime date;
@override final  String itemNameFa;
@override final  double qty;
@override final  String unitFa;
@override final  String documentNo;

/// Create a copy of LocationUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationUsageCopyWith<_LocationUsage> get copyWith => __$LocationUsageCopyWithImpl<_LocationUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationUsageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationUsage&&(identical(other.date, date) || other.date == date)&&(identical(other.itemNameFa, itemNameFa) || other.itemNameFa == itemNameFa)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitFa, unitFa) || other.unitFa == unitFa)&&(identical(other.documentNo, documentNo) || other.documentNo == documentNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,itemNameFa,qty,unitFa,documentNo);
}

@override
String toString() {
    return 'LocationUsage(date: $date, itemNameFa: $itemNameFa, qty: $qty, unitFa: $unitFa, documentNo: $documentNo)';
}


}

/// @nodoc
abstract mixin class _$LocationUsageCopyWith<$Res> implements $LocationUsageCopyWith<$Res> {
  factory _$LocationUsageCopyWith(_LocationUsage value, $Res Function(_LocationUsage) _then) = __$LocationUsageCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String itemNameFa, double qty, String unitFa, String documentNo
});




}
/// @nodoc
class __$LocationUsageCopyWithImpl<$Res>
    implements _$LocationUsageCopyWith<$Res> {
  __$LocationUsageCopyWithImpl(this._self, this._then);

  final _LocationUsage _self;
  final $Res Function(_LocationUsage) _then;

/// Create a copy of LocationUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? itemNameFa = null,Object? qty = null,Object? unitFa = null,Object? documentNo = null,}) {
  return _then(_LocationUsage(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,documentNo: null == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GoodsRequest {

 String get id; int get number; DateTime get createdAt; Person get requester; ConsumptionPlace get place; List<RequestLine> get lines; RequestStatus get status;/// True when owners must decide. Routine requests are decided by the
/// warehouse manager and are shown read-only.
 bool get escalated; String? get note; EscalationReason? get escalationReason; DecidedBy? get decidedBy; DateTime? get decidedAt; String? get decisionReason; List<LocationUsage>? get locationHistory;
/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoodsRequestCopyWith<GoodsRequest> get copyWith => _$GoodsRequestCopyWithImpl<GoodsRequest>(this as GoodsRequest, _$identity);

  /// Serializes this GoodsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GoodsRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoodsRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.requester, _this.requester) || other.requester == _this.requester)&&(identical(other.place, _this.place) || other.place == _this.place)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.escalated, _this.escalated) || other.escalated == _this.escalated)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.escalationReason, _this.escalationReason) || other.escalationReason == _this.escalationReason)&&(identical(other.decidedBy, _this.decidedBy) || other.decidedBy == _this.decidedBy)&&(identical(other.decidedAt, _this.decidedAt) || other.decidedAt == _this.decidedAt)&&(identical(other.decisionReason, _this.decisionReason) || other.decisionReason == _this.decisionReason)&&const DeepCollectionEquality().equals(other.locationHistory, _this.locationHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GoodsRequest;
  return Object.hash(runtimeType,_this.id,_this.number,_this.createdAt,_this.requester,_this.place,const DeepCollectionEquality().hash(_this.lines),_this.status,_this.escalated,_this.note,_this.escalationReason,_this.decidedBy,_this.decidedAt,_this.decisionReason,const DeepCollectionEquality().hash(_this.locationHistory));
}

@override
String toString() {
  final _this = this as GoodsRequest;
  return 'GoodsRequest(id: ${_this.id}, number: ${_this.number}, createdAt: ${_this.createdAt}, requester: ${_this.requester}, place: ${_this.place}, lines: ${_this.lines}, status: ${_this.status}, escalated: ${_this.escalated}, note: ${_this.note}, escalationReason: ${_this.escalationReason}, decidedBy: ${_this.decidedBy}, decidedAt: ${_this.decidedAt}, decisionReason: ${_this.decisionReason}, locationHistory: ${_this.locationHistory})';
}


}

/// @nodoc
abstract mixin class $GoodsRequestCopyWith<$Res>  {
  factory $GoodsRequestCopyWith(GoodsRequest value, $Res Function(GoodsRequest) _then) = _$GoodsRequestCopyWithImpl;
@useResult
$Res call({
 String id, int number, DateTime createdAt, Person requester, ConsumptionPlace place, List<RequestLine> lines, RequestStatus status, bool escalated, String? note, EscalationReason? escalationReason, DecidedBy? decidedBy, DateTime? decidedAt, String? decisionReason, List<LocationUsage>? locationHistory
});


$PersonCopyWith<$Res> get requester;$ConsumptionPlaceCopyWith<$Res> get place;$DecidedByCopyWith<$Res>? get decidedBy;

}
/// @nodoc
class _$GoodsRequestCopyWithImpl<$Res>
    implements $GoodsRequestCopyWith<$Res> {
  _$GoodsRequestCopyWithImpl(this._self, this._then);

  final GoodsRequest _self;
  final $Res Function(GoodsRequest) _then;

/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? createdAt = null,Object? requester = null,Object? place = null,Object? lines = null,Object? status = null,Object? escalated = null,Object? note = freezed,Object? escalationReason = freezed,Object? decidedBy = freezed,Object? decidedAt = freezed,Object? decisionReason = freezed,Object? locationHistory = freezed,}) {
  return _then(GoodsRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as Person,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as ConsumptionPlace,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<RequestLine>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,escalated: null == escalated ? _self.escalated : escalated // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,escalationReason: freezed == escalationReason ? _self.escalationReason : escalationReason // ignore: cast_nullable_to_non_nullable
as EscalationReason?,decidedBy: freezed == decidedBy ? _self.decidedBy : decidedBy // ignore: cast_nullable_to_non_nullable
as DecidedBy?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,decisionReason: freezed == decisionReason ? _self.decisionReason : decisionReason // ignore: cast_nullable_to_non_nullable
as String?,locationHistory: freezed == locationHistory ? _self.locationHistory : locationHistory // ignore: cast_nullable_to_non_nullable
as List<LocationUsage>?,
  ));
}
/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get requester {
  
  return $PersonCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsumptionPlaceCopyWith<$Res> get place {
  
  return $ConsumptionPlaceCopyWith<$Res>(_self.place, (value) {
    return _then(_self.copyWith(place: value));
  });
}/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DecidedByCopyWith<$Res>? get decidedBy {
    if (_self.decidedBy == null) {
    return null;
  }

  return $DecidedByCopyWith<$Res>(_self.decidedBy!, (value) {
    return _then(_self.copyWith(decidedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [GoodsRequest].
extension GoodsRequestPatterns on GoodsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoodsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoodsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoodsRequest value)  $default,){
final _that = this;
switch (_that) {
case _GoodsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoodsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GoodsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  DateTime createdAt,  Person requester,  ConsumptionPlace place,  List<RequestLine> lines,  RequestStatus status,  bool escalated,  String? note,  EscalationReason? escalationReason,  DecidedBy? decidedBy,  DateTime? decidedAt,  String? decisionReason,  List<LocationUsage>? locationHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoodsRequest() when $default != null:
return $default(_that.id,_that.number,_that.createdAt,_that.requester,_that.place,_that.lines,_that.status,_that.escalated,_that.note,_that.escalationReason,_that.decidedBy,_that.decidedAt,_that.decisionReason,_that.locationHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  DateTime createdAt,  Person requester,  ConsumptionPlace place,  List<RequestLine> lines,  RequestStatus status,  bool escalated,  String? note,  EscalationReason? escalationReason,  DecidedBy? decidedBy,  DateTime? decidedAt,  String? decisionReason,  List<LocationUsage>? locationHistory)  $default,) {final _that = this;
switch (_that) {
case _GoodsRequest():
return $default(_that.id,_that.number,_that.createdAt,_that.requester,_that.place,_that.lines,_that.status,_that.escalated,_that.note,_that.escalationReason,_that.decidedBy,_that.decidedAt,_that.decisionReason,_that.locationHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  DateTime createdAt,  Person requester,  ConsumptionPlace place,  List<RequestLine> lines,  RequestStatus status,  bool escalated,  String? note,  EscalationReason? escalationReason,  DecidedBy? decidedBy,  DateTime? decidedAt,  String? decisionReason,  List<LocationUsage>? locationHistory)?  $default,) {final _that = this;
switch (_that) {
case _GoodsRequest() when $default != null:
return $default(_that.id,_that.number,_that.createdAt,_that.requester,_that.place,_that.lines,_that.status,_that.escalated,_that.note,_that.escalationReason,_that.decidedBy,_that.decidedAt,_that.decisionReason,_that.locationHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoodsRequest extends GoodsRequest {
  const _GoodsRequest({required this.id, required this.number, required this.createdAt, required this.requester, required this.place, required  List<RequestLine> lines, required this.status, required this.escalated, this.note, this.escalationReason, this.decidedBy, this.decidedAt, this.decisionReason,  List<LocationUsage>? locationHistory}): _lines = lines,_locationHistory = locationHistory,super._();
  factory _GoodsRequest.fromJson(Map<String, dynamic> json) => _$GoodsRequestFromJson(json);

@override final  String id;
@override final  int number;
@override final  DateTime createdAt;
@override final  Person requester;
@override final  ConsumptionPlace place;
 final  List<RequestLine> _lines;
@override List<RequestLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  RequestStatus status;
/// True when owners must decide. Routine requests are decided by the
/// warehouse manager and are shown read-only.
@override final  bool escalated;
@override final  String? note;
@override final  EscalationReason? escalationReason;
@override final  DecidedBy? decidedBy;
@override final  DateTime? decidedAt;
@override final  String? decisionReason;
 final  List<LocationUsage>? _locationHistory;
@override List<LocationUsage>? get locationHistory {
  final value = _locationHistory;
  if (value == null) return null;
  if (_locationHistory is EqualUnmodifiableListView) return _locationHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoodsRequestCopyWith<_GoodsRequest> get copyWith => __$GoodsRequestCopyWithImpl<_GoodsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoodsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoodsRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requester, requester) || other.requester == requester)&&(identical(other.place, place) || other.place == place)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.status, status) || other.status == status)&&(identical(other.escalated, escalated) || other.escalated == escalated)&&(identical(other.note, note) || other.note == note)&&(identical(other.escalationReason, escalationReason) || other.escalationReason == escalationReason)&&(identical(other.decidedBy, decidedBy) || other.decidedBy == decidedBy)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt)&&(identical(other.decisionReason, decisionReason) || other.decisionReason == decisionReason)&&const DeepCollectionEquality().equals(other.locationHistory, _locationHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,number,createdAt,requester,place,const DeepCollectionEquality().hash(_lines),status,escalated,note,escalationReason,decidedBy,decidedAt,decisionReason,const DeepCollectionEquality().hash(_locationHistory));
}

@override
String toString() {
    return 'GoodsRequest(id: $id, number: $number, createdAt: $createdAt, requester: $requester, place: $place, lines: $lines, status: $status, escalated: $escalated, note: $note, escalationReason: $escalationReason, decidedBy: $decidedBy, decidedAt: $decidedAt, decisionReason: $decisionReason, locationHistory: $locationHistory)';
}


}

/// @nodoc
abstract mixin class _$GoodsRequestCopyWith<$Res> implements $GoodsRequestCopyWith<$Res> {
  factory _$GoodsRequestCopyWith(_GoodsRequest value, $Res Function(_GoodsRequest) _then) = __$GoodsRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, DateTime createdAt, Person requester, ConsumptionPlace place, List<RequestLine> lines, RequestStatus status, bool escalated, String? note, EscalationReason? escalationReason, DecidedBy? decidedBy, DateTime? decidedAt, String? decisionReason, List<LocationUsage>? locationHistory
});


@override $PersonCopyWith<$Res> get requester;@override $ConsumptionPlaceCopyWith<$Res> get place;@override $DecidedByCopyWith<$Res>? get decidedBy;

}
/// @nodoc
class __$GoodsRequestCopyWithImpl<$Res>
    implements _$GoodsRequestCopyWith<$Res> {
  __$GoodsRequestCopyWithImpl(this._self, this._then);

  final _GoodsRequest _self;
  final $Res Function(_GoodsRequest) _then;

/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? createdAt = null,Object? requester = null,Object? place = null,Object? lines = null,Object? status = null,Object? escalated = null,Object? note = freezed,Object? escalationReason = freezed,Object? decidedBy = freezed,Object? decidedAt = freezed,Object? decisionReason = freezed,Object? locationHistory = freezed,}) {
  return _then(_GoodsRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as Person,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as ConsumptionPlace,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<RequestLine>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,escalated: null == escalated ? _self.escalated : escalated // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,escalationReason: freezed == escalationReason ? _self.escalationReason : escalationReason // ignore: cast_nullable_to_non_nullable
as EscalationReason?,decidedBy: freezed == decidedBy ? _self.decidedBy : decidedBy // ignore: cast_nullable_to_non_nullable
as DecidedBy?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,decisionReason: freezed == decisionReason ? _self.decisionReason : decisionReason // ignore: cast_nullable_to_non_nullable
as String?,locationHistory: freezed == locationHistory ? _self._locationHistory : locationHistory // ignore: cast_nullable_to_non_nullable
as List<LocationUsage>?,
  ));
}

/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get requester {
  
  return $PersonCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsumptionPlaceCopyWith<$Res> get place {
  
  return $ConsumptionPlaceCopyWith<$Res>(_self.place, (value) {
    return _then(_self.copyWith(place: value));
  });
}/// Create a copy of GoodsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DecidedByCopyWith<$Res>? get decidedBy {
    if (_self.decidedBy == null) {
    return null;
  }

  return $DecidedByCopyWith<$Res>(_self.decidedBy!, (value) {
    return _then(_self.copyWith(decidedBy: value));
  });
}
}


/// @nodoc
mixin _$Decision {

 String get requestId; DecisionAction get action;/// Lets the server apply the same decision only once (offline retries).
 String get idempotencyKey; String? get reason;
/// Create a copy of Decision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DecisionCopyWith<Decision> get copyWith => _$DecisionCopyWithImpl<Decision>(this as Decision, _$identity);

  /// Serializes this Decision to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Decision;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Decision&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.idempotencyKey, _this.idempotencyKey) || other.idempotencyKey == _this.idempotencyKey)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Decision;
  return Object.hash(runtimeType,_this.requestId,_this.action,_this.idempotencyKey,_this.reason);
}

@override
String toString() {
  final _this = this as Decision;
  return 'Decision(requestId: ${_this.requestId}, action: ${_this.action}, idempotencyKey: ${_this.idempotencyKey}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $DecisionCopyWith<$Res>  {
  factory $DecisionCopyWith(Decision value, $Res Function(Decision) _then) = _$DecisionCopyWithImpl;
@useResult
$Res call({
 String requestId, DecisionAction action, String idempotencyKey, String? reason
});




}
/// @nodoc
class _$DecisionCopyWithImpl<$Res>
    implements $DecisionCopyWith<$Res> {
  _$DecisionCopyWithImpl(this._self, this._then);

  final Decision _self;
  final $Res Function(Decision) _then;

/// Create a copy of Decision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? action = null,Object? idempotencyKey = null,Object? reason = freezed,}) {
  return _then(Decision(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as DecisionAction,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Decision].
extension DecisionPatterns on Decision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Decision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Decision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Decision value)  $default,){
final _that = this;
switch (_that) {
case _Decision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Decision value)?  $default,){
final _that = this;
switch (_that) {
case _Decision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  DecisionAction action,  String idempotencyKey,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Decision() when $default != null:
return $default(_that.requestId,_that.action,_that.idempotencyKey,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  DecisionAction action,  String idempotencyKey,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _Decision():
return $default(_that.requestId,_that.action,_that.idempotencyKey,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  DecisionAction action,  String idempotencyKey,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _Decision() when $default != null:
return $default(_that.requestId,_that.action,_that.idempotencyKey,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Decision implements Decision {
  const _Decision({required this.requestId, required this.action, required this.idempotencyKey, this.reason});
  factory _Decision.fromJson(Map<String, dynamic> json) => _$DecisionFromJson(json);

@override final  String requestId;
@override final  DecisionAction action;
/// Lets the server apply the same decision only once (offline retries).
@override final  String idempotencyKey;
@override final  String? reason;

/// Create a copy of Decision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DecisionCopyWith<_Decision> get copyWith => __$DecisionCopyWithImpl<_Decision>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DecisionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Decision&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.action, action) || other.action == action)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requestId,action,idempotencyKey,reason);
}

@override
String toString() {
    return 'Decision(requestId: $requestId, action: $action, idempotencyKey: $idempotencyKey, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$DecisionCopyWith<$Res> implements $DecisionCopyWith<$Res> {
  factory _$DecisionCopyWith(_Decision value, $Res Function(_Decision) _then) = __$DecisionCopyWithImpl;
@override @useResult
$Res call({
 String requestId, DecisionAction action, String idempotencyKey, String? reason
});




}
/// @nodoc
class __$DecisionCopyWithImpl<$Res>
    implements _$DecisionCopyWith<$Res> {
  __$DecisionCopyWithImpl(this._self, this._then);

  final _Decision _self;
  final $Res Function(_Decision) _then;

/// Create a copy of Decision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? action = null,Object? idempotencyKey = null,Object? reason = freezed,}) {
  return _then(_Decision(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as DecisionAction,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
