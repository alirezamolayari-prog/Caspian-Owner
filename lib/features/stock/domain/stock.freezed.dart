// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockItem {

 String get code; String get nameFa; String get unitFa;/// Null while hidden by a running surprise count. Always sent: the
/// contract requires the key even when the value is null.
@JsonKey(includeIfNull: true) double? get qty; bool get low; bool get lockedByCount; String? get shelfFa;
/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockItemCopyWith<StockItem> get copyWith => _$StockItemCopyWithImpl<StockItem>(this as StockItem, _$identity);

  /// Serializes this StockItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockItem&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nameFa, _this.nameFa) || other.nameFa == _this.nameFa)&&(identical(other.unitFa, _this.unitFa) || other.unitFa == _this.unitFa)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.low, _this.low) || other.low == _this.low)&&(identical(other.lockedByCount, _this.lockedByCount) || other.lockedByCount == _this.lockedByCount)&&(identical(other.shelfFa, _this.shelfFa) || other.shelfFa == _this.shelfFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockItem;
  return Object.hash(runtimeType,_this.code,_this.nameFa,_this.unitFa,_this.qty,_this.low,_this.lockedByCount,_this.shelfFa);
}

@override
String toString() {
  final _this = this as StockItem;
  return 'StockItem(code: ${_this.code}, nameFa: ${_this.nameFa}, unitFa: ${_this.unitFa}, qty: ${_this.qty}, low: ${_this.low}, lockedByCount: ${_this.lockedByCount}, shelfFa: ${_this.shelfFa})';
}


}

/// @nodoc
abstract mixin class $StockItemCopyWith<$Res>  {
  factory $StockItemCopyWith(StockItem value, $Res Function(StockItem) _then) = _$StockItemCopyWithImpl;
@useResult
$Res call({
 String code, String nameFa, String unitFa,@JsonKey(includeIfNull: true) double? qty, bool low, bool lockedByCount, String? shelfFa
});




}
/// @nodoc
class _$StockItemCopyWithImpl<$Res>
    implements $StockItemCopyWith<$Res> {
  _$StockItemCopyWithImpl(this._self, this._then);

  final StockItem _self;
  final $Res Function(StockItem) _then;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameFa = null,Object? unitFa = null,Object? qty = freezed,Object? low = null,Object? lockedByCount = null,Object? shelfFa = freezed,}) {
  return _then(StockItem(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,qty: freezed == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double?,low: null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as bool,lockedByCount: null == lockedByCount ? _self.lockedByCount : lockedByCount // ignore: cast_nullable_to_non_nullable
as bool,shelfFa: freezed == shelfFa ? _self.shelfFa : shelfFa // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockItem].
extension StockItemPatterns on StockItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockItem value)  $default,){
final _that = this;
switch (_that) {
case _StockItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockItem value)?  $default,){
final _that = this;
switch (_that) {
case _StockItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nameFa,  String unitFa, @JsonKey(includeIfNull: true)  double? qty,  bool low,  bool lockedByCount,  String? shelfFa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that.code,_that.nameFa,_that.unitFa,_that.qty,_that.low,_that.lockedByCount,_that.shelfFa);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nameFa,  String unitFa, @JsonKey(includeIfNull: true)  double? qty,  bool low,  bool lockedByCount,  String? shelfFa)  $default,) {final _that = this;
switch (_that) {
case _StockItem():
return $default(_that.code,_that.nameFa,_that.unitFa,_that.qty,_that.low,_that.lockedByCount,_that.shelfFa);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nameFa,  String unitFa, @JsonKey(includeIfNull: true)  double? qty,  bool low,  bool lockedByCount,  String? shelfFa)?  $default,) {final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that.code,_that.nameFa,_that.unitFa,_that.qty,_that.low,_that.lockedByCount,_that.shelfFa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockItem implements StockItem {
  const _StockItem({required this.code, required this.nameFa, required this.unitFa, @JsonKey(includeIfNull: true) required this.qty, required this.low, required this.lockedByCount, this.shelfFa});
  factory _StockItem.fromJson(Map<String, dynamic> json) => _$StockItemFromJson(json);

@override final  String code;
@override final  String nameFa;
@override final  String unitFa;
/// Null while hidden by a running surprise count. Always sent: the
/// contract requires the key even when the value is null.
@override@JsonKey(includeIfNull: true) final  double? qty;
@override final  bool low;
@override final  bool lockedByCount;
@override final  String? shelfFa;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockItemCopyWith<_StockItem> get copyWith => __$StockItemCopyWithImpl<_StockItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockItem&&(identical(other.code, code) || other.code == code)&&(identical(other.nameFa, nameFa) || other.nameFa == nameFa)&&(identical(other.unitFa, unitFa) || other.unitFa == unitFa)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.low, low) || other.low == low)&&(identical(other.lockedByCount, lockedByCount) || other.lockedByCount == lockedByCount)&&(identical(other.shelfFa, shelfFa) || other.shelfFa == shelfFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,nameFa,unitFa,qty,low,lockedByCount,shelfFa);
}

@override
String toString() {
    return 'StockItem(code: $code, nameFa: $nameFa, unitFa: $unitFa, qty: $qty, low: $low, lockedByCount: $lockedByCount, shelfFa: $shelfFa)';
}


}

/// @nodoc
abstract mixin class _$StockItemCopyWith<$Res> implements $StockItemCopyWith<$Res> {
  factory _$StockItemCopyWith(_StockItem value, $Res Function(_StockItem) _then) = __$StockItemCopyWithImpl;
@override @useResult
$Res call({
 String code, String nameFa, String unitFa,@JsonKey(includeIfNull: true) double? qty, bool low, bool lockedByCount, String? shelfFa
});




}
/// @nodoc
class __$StockItemCopyWithImpl<$Res>
    implements _$StockItemCopyWith<$Res> {
  __$StockItemCopyWithImpl(this._self, this._then);

  final _StockItem _self;
  final $Res Function(_StockItem) _then;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameFa = null,Object? unitFa = null,Object? qty = freezed,Object? low = null,Object? lockedByCount = null,Object? shelfFa = freezed,}) {
  return _then(_StockItem(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,qty: freezed == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double?,low: null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as bool,lockedByCount: null == lockedByCount ? _self.lockedByCount : lockedByCount // ignore: cast_nullable_to_non_nullable
as bool,shelfFa: freezed == shelfFa ? _self.shelfFa : shelfFa // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StockMovement {

 DateTime get date; StockMovementKind get kind; double get qty; String get documentNo; ConsumptionPlace? get place;
/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementCopyWith<StockMovement> get copyWith => _$StockMovementCopyWithImpl<StockMovement>(this as StockMovement, _$identity);

  /// Serializes this StockMovement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockMovement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovement&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.documentNo, _this.documentNo) || other.documentNo == _this.documentNo)&&(identical(other.place, _this.place) || other.place == _this.place));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockMovement;
  return Object.hash(runtimeType,_this.date,_this.kind,_this.qty,_this.documentNo,_this.place);
}

@override
String toString() {
  final _this = this as StockMovement;
  return 'StockMovement(date: ${_this.date}, kind: ${_this.kind}, qty: ${_this.qty}, documentNo: ${_this.documentNo}, place: ${_this.place})';
}


}

/// @nodoc
abstract mixin class $StockMovementCopyWith<$Res>  {
  factory $StockMovementCopyWith(StockMovement value, $Res Function(StockMovement) _then) = _$StockMovementCopyWithImpl;
@useResult
$Res call({
 DateTime date, StockMovementKind kind, double qty, String documentNo, ConsumptionPlace? place
});


$ConsumptionPlaceCopyWith<$Res>? get place;

}
/// @nodoc
class _$StockMovementCopyWithImpl<$Res>
    implements $StockMovementCopyWith<$Res> {
  _$StockMovementCopyWithImpl(this._self, this._then);

  final StockMovement _self;
  final $Res Function(StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? kind = null,Object? qty = null,Object? documentNo = null,Object? place = freezed,}) {
  return _then(StockMovement(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as StockMovementKind,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,documentNo: null == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as ConsumptionPlace?,
  ));
}
/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsumptionPlaceCopyWith<$Res>? get place {
    if (_self.place == null) {
    return null;
  }

  return $ConsumptionPlaceCopyWith<$Res>(_self.place!, (value) {
    return _then(_self.copyWith(place: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockMovement].
extension StockMovementPatterns on StockMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovement value)  $default,){
final _that = this;
switch (_that) {
case _StockMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovement value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  StockMovementKind kind,  double qty,  String documentNo,  ConsumptionPlace? place)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.date,_that.kind,_that.qty,_that.documentNo,_that.place);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  StockMovementKind kind,  double qty,  String documentNo,  ConsumptionPlace? place)  $default,) {final _that = this;
switch (_that) {
case _StockMovement():
return $default(_that.date,_that.kind,_that.qty,_that.documentNo,_that.place);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  StockMovementKind kind,  double qty,  String documentNo,  ConsumptionPlace? place)?  $default,) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.date,_that.kind,_that.qty,_that.documentNo,_that.place);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockMovement implements StockMovement {
  const _StockMovement({required this.date, required this.kind, required this.qty, required this.documentNo, this.place});
  factory _StockMovement.fromJson(Map<String, dynamic> json) => _$StockMovementFromJson(json);

@override final  DateTime date;
@override final  StockMovementKind kind;
@override final  double qty;
@override final  String documentNo;
@override final  ConsumptionPlace? place;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementCopyWith<_StockMovement> get copyWith => __$StockMovementCopyWithImpl<_StockMovement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockMovementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovement&&(identical(other.date, date) || other.date == date)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.documentNo, documentNo) || other.documentNo == documentNo)&&(identical(other.place, place) || other.place == place));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,kind,qty,documentNo,place);
}

@override
String toString() {
    return 'StockMovement(date: $date, kind: $kind, qty: $qty, documentNo: $documentNo, place: $place)';
}


}

/// @nodoc
abstract mixin class _$StockMovementCopyWith<$Res> implements $StockMovementCopyWith<$Res> {
  factory _$StockMovementCopyWith(_StockMovement value, $Res Function(_StockMovement) _then) = __$StockMovementCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, StockMovementKind kind, double qty, String documentNo, ConsumptionPlace? place
});


@override $ConsumptionPlaceCopyWith<$Res>? get place;

}
/// @nodoc
class __$StockMovementCopyWithImpl<$Res>
    implements _$StockMovementCopyWith<$Res> {
  __$StockMovementCopyWithImpl(this._self, this._then);

  final _StockMovement _self;
  final $Res Function(_StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? kind = null,Object? qty = null,Object? documentNo = null,Object? place = freezed,}) {
  return _then(_StockMovement(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as StockMovementKind,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,documentNo: null == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as ConsumptionPlace?,
  ));
}

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsumptionPlaceCopyWith<$Res>? get place {
    if (_self.place == null) {
    return null;
  }

  return $ConsumptionPlaceCopyWith<$Res>(_self.place!, (value) {
    return _then(_self.copyWith(place: value));
  });
}
}

// dart format on
