// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surprise_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CountItem {

 String get itemCode; String get itemNameFa; String get unitFa;
/// Create a copy of CountItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountItemCopyWith<CountItem> get copyWith => _$CountItemCopyWithImpl<CountItem>(this as CountItem, _$identity);

  /// Serializes this CountItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CountItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountItem&&(identical(other.itemCode, _this.itemCode) || other.itemCode == _this.itemCode)&&(identical(other.itemNameFa, _this.itemNameFa) || other.itemNameFa == _this.itemNameFa)&&(identical(other.unitFa, _this.unitFa) || other.unitFa == _this.unitFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CountItem;
  return Object.hash(runtimeType,_this.itemCode,_this.itemNameFa,_this.unitFa);
}

@override
String toString() {
  final _this = this as CountItem;
  return 'CountItem(itemCode: ${_this.itemCode}, itemNameFa: ${_this.itemNameFa}, unitFa: ${_this.unitFa})';
}


}

/// @nodoc
abstract mixin class $CountItemCopyWith<$Res>  {
  factory $CountItemCopyWith(CountItem value, $Res Function(CountItem) _then) = _$CountItemCopyWithImpl;
@useResult
$Res call({
 String itemCode, String itemNameFa, String unitFa
});




}
/// @nodoc
class _$CountItemCopyWithImpl<$Res>
    implements $CountItemCopyWith<$Res> {
  _$CountItemCopyWithImpl(this._self, this._then);

  final CountItem _self;
  final $Res Function(CountItem) _then;

/// Create a copy of CountItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemCode = null,Object? itemNameFa = null,Object? unitFa = null,}) {
  return _then(CountItem(
itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CountItem].
extension CountItemPatterns on CountItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountItem value)  $default,){
final _that = this;
switch (_that) {
case _CountItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountItem value)?  $default,){
final _that = this;
switch (_that) {
case _CountItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemCode,  String itemNameFa,  String unitFa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountItem() when $default != null:
return $default(_that.itemCode,_that.itemNameFa,_that.unitFa);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemCode,  String itemNameFa,  String unitFa)  $default,) {final _that = this;
switch (_that) {
case _CountItem():
return $default(_that.itemCode,_that.itemNameFa,_that.unitFa);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemCode,  String itemNameFa,  String unitFa)?  $default,) {final _that = this;
switch (_that) {
case _CountItem() when $default != null:
return $default(_that.itemCode,_that.itemNameFa,_that.unitFa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CountItem implements CountItem {
  const _CountItem({required this.itemCode, required this.itemNameFa, required this.unitFa});
  factory _CountItem.fromJson(Map<String, dynamic> json) => _$CountItemFromJson(json);

@override final  String itemCode;
@override final  String itemNameFa;
@override final  String unitFa;

/// Create a copy of CountItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountItemCopyWith<_CountItem> get copyWith => __$CountItemCopyWithImpl<_CountItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountItem&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemNameFa, itemNameFa) || other.itemNameFa == itemNameFa)&&(identical(other.unitFa, unitFa) || other.unitFa == unitFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemCode,itemNameFa,unitFa);
}

@override
String toString() {
    return 'CountItem(itemCode: $itemCode, itemNameFa: $itemNameFa, unitFa: $unitFa)';
}


}

/// @nodoc
abstract mixin class _$CountItemCopyWith<$Res> implements $CountItemCopyWith<$Res> {
  factory _$CountItemCopyWith(_CountItem value, $Res Function(_CountItem) _then) = __$CountItemCopyWithImpl;
@override @useResult
$Res call({
 String itemCode, String itemNameFa, String unitFa
});




}
/// @nodoc
class __$CountItemCopyWithImpl<$Res>
    implements _$CountItemCopyWith<$Res> {
  __$CountItemCopyWithImpl(this._self, this._then);

  final _CountItem _self;
  final $Res Function(_CountItem) _then;

/// Create a copy of CountItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemCode = null,Object? itemNameFa = null,Object? unitFa = null,}) {
  return _then(_CountItem(
itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CountEntry {

 double get qty; Person get enteredBy; DateTime get enteredAt;
/// Create a copy of CountEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountEntryCopyWith<CountEntry> get copyWith => _$CountEntryCopyWithImpl<CountEntry>(this as CountEntry, _$identity);

  /// Serializes this CountEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CountEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountEntry&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.enteredBy, _this.enteredBy) || other.enteredBy == _this.enteredBy)&&(identical(other.enteredAt, _this.enteredAt) || other.enteredAt == _this.enteredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CountEntry;
  return Object.hash(runtimeType,_this.qty,_this.enteredBy,_this.enteredAt);
}

@override
String toString() {
  final _this = this as CountEntry;
  return 'CountEntry(qty: ${_this.qty}, enteredBy: ${_this.enteredBy}, enteredAt: ${_this.enteredAt})';
}


}

/// @nodoc
abstract mixin class $CountEntryCopyWith<$Res>  {
  factory $CountEntryCopyWith(CountEntry value, $Res Function(CountEntry) _then) = _$CountEntryCopyWithImpl;
@useResult
$Res call({
 double qty, Person enteredBy, DateTime enteredAt
});


$PersonCopyWith<$Res> get enteredBy;

}
/// @nodoc
class _$CountEntryCopyWithImpl<$Res>
    implements $CountEntryCopyWith<$Res> {
  _$CountEntryCopyWithImpl(this._self, this._then);

  final CountEntry _self;
  final $Res Function(CountEntry) _then;

/// Create a copy of CountEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qty = null,Object? enteredBy = null,Object? enteredAt = null,}) {
  return _then(CountEntry(
qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,enteredBy: null == enteredBy ? _self.enteredBy : enteredBy // ignore: cast_nullable_to_non_nullable
as Person,enteredAt: null == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CountEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get enteredBy {
  
  return $PersonCopyWith<$Res>(_self.enteredBy, (value) {
    return _then(_self.copyWith(enteredBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [CountEntry].
extension CountEntryPatterns on CountEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountEntry value)  $default,){
final _that = this;
switch (_that) {
case _CountEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CountEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double qty,  Person enteredBy,  DateTime enteredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountEntry() when $default != null:
return $default(_that.qty,_that.enteredBy,_that.enteredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double qty,  Person enteredBy,  DateTime enteredAt)  $default,) {final _that = this;
switch (_that) {
case _CountEntry():
return $default(_that.qty,_that.enteredBy,_that.enteredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double qty,  Person enteredBy,  DateTime enteredAt)?  $default,) {final _that = this;
switch (_that) {
case _CountEntry() when $default != null:
return $default(_that.qty,_that.enteredBy,_that.enteredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CountEntry implements CountEntry {
  const _CountEntry({required this.qty, required this.enteredBy, required this.enteredAt});
  factory _CountEntry.fromJson(Map<String, dynamic> json) => _$CountEntryFromJson(json);

@override final  double qty;
@override final  Person enteredBy;
@override final  DateTime enteredAt;

/// Create a copy of CountEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountEntryCopyWith<_CountEntry> get copyWith => __$CountEntryCopyWithImpl<_CountEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountEntry&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.enteredBy, enteredBy) || other.enteredBy == enteredBy)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,qty,enteredBy,enteredAt);
}

@override
String toString() {
    return 'CountEntry(qty: $qty, enteredBy: $enteredBy, enteredAt: $enteredAt)';
}


}

/// @nodoc
abstract mixin class _$CountEntryCopyWith<$Res> implements $CountEntryCopyWith<$Res> {
  factory _$CountEntryCopyWith(_CountEntry value, $Res Function(_CountEntry) _then) = __$CountEntryCopyWithImpl;
@override @useResult
$Res call({
 double qty, Person enteredBy, DateTime enteredAt
});


@override $PersonCopyWith<$Res> get enteredBy;

}
/// @nodoc
class __$CountEntryCopyWithImpl<$Res>
    implements _$CountEntryCopyWith<$Res> {
  __$CountEntryCopyWithImpl(this._self, this._then);

  final _CountEntry _self;
  final $Res Function(_CountEntry) _then;

/// Create a copy of CountEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qty = null,Object? enteredBy = null,Object? enteredAt = null,}) {
  return _then(_CountEntry(
qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,enteredBy: null == enteredBy ? _self.enteredBy : enteredBy // ignore: cast_nullable_to_non_nullable
as Person,enteredAt: null == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CountEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get enteredBy {
  
  return $PersonCopyWith<$Res>(_self.enteredBy, (value) {
    return _then(_self.copyWith(enteredBy: value));
  });
}
}


/// @nodoc
mixin _$CountResult {

 String get itemCode; double get systemQty; double get countedQty;/// Every number that was entered, in order.
 List<CountEntry> get entries; List<Person> get countedBy;
/// Create a copy of CountResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountResultCopyWith<CountResult> get copyWith => _$CountResultCopyWithImpl<CountResult>(this as CountResult, _$identity);

  /// Serializes this CountResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CountResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountResult&&(identical(other.itemCode, _this.itemCode) || other.itemCode == _this.itemCode)&&(identical(other.systemQty, _this.systemQty) || other.systemQty == _this.systemQty)&&(identical(other.countedQty, _this.countedQty) || other.countedQty == _this.countedQty)&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&const DeepCollectionEquality().equals(other.countedBy, _this.countedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CountResult;
  return Object.hash(runtimeType,_this.itemCode,_this.systemQty,_this.countedQty,const DeepCollectionEquality().hash(_this.entries),const DeepCollectionEquality().hash(_this.countedBy));
}

@override
String toString() {
  final _this = this as CountResult;
  return 'CountResult(itemCode: ${_this.itemCode}, systemQty: ${_this.systemQty}, countedQty: ${_this.countedQty}, entries: ${_this.entries}, countedBy: ${_this.countedBy})';
}


}

/// @nodoc
abstract mixin class $CountResultCopyWith<$Res>  {
  factory $CountResultCopyWith(CountResult value, $Res Function(CountResult) _then) = _$CountResultCopyWithImpl;
@useResult
$Res call({
 String itemCode, double systemQty, double countedQty, List<CountEntry> entries, List<Person> countedBy
});




}
/// @nodoc
class _$CountResultCopyWithImpl<$Res>
    implements $CountResultCopyWith<$Res> {
  _$CountResultCopyWithImpl(this._self, this._then);

  final CountResult _self;
  final $Res Function(CountResult) _then;

/// Create a copy of CountResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemCode = null,Object? systemQty = null,Object? countedQty = null,Object? entries = null,Object? countedBy = null,}) {
  return _then(CountResult(
itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,systemQty: null == systemQty ? _self.systemQty : systemQty // ignore: cast_nullable_to_non_nullable
as double,countedQty: null == countedQty ? _self.countedQty : countedQty // ignore: cast_nullable_to_non_nullable
as double,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<CountEntry>,countedBy: null == countedBy ? _self.countedBy : countedBy // ignore: cast_nullable_to_non_nullable
as List<Person>,
  ));
}

}


/// Adds pattern-matching-related methods to [CountResult].
extension CountResultPatterns on CountResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountResult value)  $default,){
final _that = this;
switch (_that) {
case _CountResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountResult value)?  $default,){
final _that = this;
switch (_that) {
case _CountResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemCode,  double systemQty,  double countedQty,  List<CountEntry> entries,  List<Person> countedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountResult() when $default != null:
return $default(_that.itemCode,_that.systemQty,_that.countedQty,_that.entries,_that.countedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemCode,  double systemQty,  double countedQty,  List<CountEntry> entries,  List<Person> countedBy)  $default,) {final _that = this;
switch (_that) {
case _CountResult():
return $default(_that.itemCode,_that.systemQty,_that.countedQty,_that.entries,_that.countedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemCode,  double systemQty,  double countedQty,  List<CountEntry> entries,  List<Person> countedBy)?  $default,) {final _that = this;
switch (_that) {
case _CountResult() when $default != null:
return $default(_that.itemCode,_that.systemQty,_that.countedQty,_that.entries,_that.countedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CountResult extends CountResult {
  const _CountResult({required this.itemCode, required this.systemQty, required this.countedQty, required  List<CountEntry> entries, required  List<Person> countedBy}): _entries = entries,_countedBy = countedBy,super._();
  factory _CountResult.fromJson(Map<String, dynamic> json) => _$CountResultFromJson(json);

@override final  String itemCode;
@override final  double systemQty;
@override final  double countedQty;
/// Every number that was entered, in order.
 final  List<CountEntry> _entries;
/// Every number that was entered, in order.
@override List<CountEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

 final  List<Person> _countedBy;
@override List<Person> get countedBy {
  if (_countedBy is EqualUnmodifiableListView) return _countedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_countedBy);
}


/// Create a copy of CountResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountResultCopyWith<_CountResult> get copyWith => __$CountResultCopyWithImpl<_CountResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountResult&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.systemQty, systemQty) || other.systemQty == systemQty)&&(identical(other.countedQty, countedQty) || other.countedQty == countedQty)&&const DeepCollectionEquality().equals(other.entries, _entries)&&const DeepCollectionEquality().equals(other.countedBy, _countedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemCode,systemQty,countedQty,const DeepCollectionEquality().hash(_entries),const DeepCollectionEquality().hash(_countedBy));
}

@override
String toString() {
    return 'CountResult(itemCode: $itemCode, systemQty: $systemQty, countedQty: $countedQty, entries: $entries, countedBy: $countedBy)';
}


}

/// @nodoc
abstract mixin class _$CountResultCopyWith<$Res> implements $CountResultCopyWith<$Res> {
  factory _$CountResultCopyWith(_CountResult value, $Res Function(_CountResult) _then) = __$CountResultCopyWithImpl;
@override @useResult
$Res call({
 String itemCode, double systemQty, double countedQty, List<CountEntry> entries, List<Person> countedBy
});




}
/// @nodoc
class __$CountResultCopyWithImpl<$Res>
    implements _$CountResultCopyWith<$Res> {
  __$CountResultCopyWithImpl(this._self, this._then);

  final _CountResult _self;
  final $Res Function(_CountResult) _then;

/// Create a copy of CountResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemCode = null,Object? systemQty = null,Object? countedQty = null,Object? entries = null,Object? countedBy = null,}) {
  return _then(_CountResult(
itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,systemQty: null == systemQty ? _self.systemQty : systemQty // ignore: cast_nullable_to_non_nullable
as double,countedQty: null == countedQty ? _self.countedQty : countedQty // ignore: cast_nullable_to_non_nullable
as double,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<CountEntry>,countedBy: null == countedBy ? _self._countedBy : countedBy // ignore: cast_nullable_to_non_nullable
as List<Person>,
  ));
}


}


/// @nodoc
mixin _$SurpriseCount {

 String get id; Owner get orderedBy; DateTime get orderedAt; List<CountItem> get items; CountStatus get status; DateTime? get finishedAt; List<CountResult>? get results;
/// Create a copy of SurpriseCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurpriseCountCopyWith<SurpriseCount> get copyWith => _$SurpriseCountCopyWithImpl<SurpriseCount>(this as SurpriseCount, _$identity);

  /// Serializes this SurpriseCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurpriseCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurpriseCount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orderedBy, _this.orderedBy) || other.orderedBy == _this.orderedBy)&&(identical(other.orderedAt, _this.orderedAt) || other.orderedAt == _this.orderedAt)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt)&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurpriseCount;
  return Object.hash(runtimeType,_this.id,_this.orderedBy,_this.orderedAt,const DeepCollectionEquality().hash(_this.items),_this.status,_this.finishedAt,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as SurpriseCount;
  return 'SurpriseCount(id: ${_this.id}, orderedBy: ${_this.orderedBy}, orderedAt: ${_this.orderedAt}, items: ${_this.items}, status: ${_this.status}, finishedAt: ${_this.finishedAt}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $SurpriseCountCopyWith<$Res>  {
  factory $SurpriseCountCopyWith(SurpriseCount value, $Res Function(SurpriseCount) _then) = _$SurpriseCountCopyWithImpl;
@useResult
$Res call({
 String id, Owner orderedBy, DateTime orderedAt, List<CountItem> items, CountStatus status, DateTime? finishedAt, List<CountResult>? results
});


$OwnerCopyWith<$Res> get orderedBy;

}
/// @nodoc
class _$SurpriseCountCopyWithImpl<$Res>
    implements $SurpriseCountCopyWith<$Res> {
  _$SurpriseCountCopyWithImpl(this._self, this._then);

  final SurpriseCount _self;
  final $Res Function(SurpriseCount) _then;

/// Create a copy of SurpriseCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderedBy = null,Object? orderedAt = null,Object? items = null,Object? status = null,Object? finishedAt = freezed,Object? results = freezed,}) {
  return _then(SurpriseCount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderedBy: null == orderedBy ? _self.orderedBy : orderedBy // ignore: cast_nullable_to_non_nullable
as Owner,orderedAt: null == orderedAt ? _self.orderedAt : orderedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CountItem>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CountStatus,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<CountResult>?,
  ));
}
/// Create a copy of SurpriseCount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerCopyWith<$Res> get orderedBy {
  
  return $OwnerCopyWith<$Res>(_self.orderedBy, (value) {
    return _then(_self.copyWith(orderedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [SurpriseCount].
extension SurpriseCountPatterns on SurpriseCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurpriseCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurpriseCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurpriseCount value)  $default,){
final _that = this;
switch (_that) {
case _SurpriseCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurpriseCount value)?  $default,){
final _that = this;
switch (_that) {
case _SurpriseCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Owner orderedBy,  DateTime orderedAt,  List<CountItem> items,  CountStatus status,  DateTime? finishedAt,  List<CountResult>? results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurpriseCount() when $default != null:
return $default(_that.id,_that.orderedBy,_that.orderedAt,_that.items,_that.status,_that.finishedAt,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Owner orderedBy,  DateTime orderedAt,  List<CountItem> items,  CountStatus status,  DateTime? finishedAt,  List<CountResult>? results)  $default,) {final _that = this;
switch (_that) {
case _SurpriseCount():
return $default(_that.id,_that.orderedBy,_that.orderedAt,_that.items,_that.status,_that.finishedAt,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Owner orderedBy,  DateTime orderedAt,  List<CountItem> items,  CountStatus status,  DateTime? finishedAt,  List<CountResult>? results)?  $default,) {final _that = this;
switch (_that) {
case _SurpriseCount() when $default != null:
return $default(_that.id,_that.orderedBy,_that.orderedAt,_that.items,_that.status,_that.finishedAt,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurpriseCount implements SurpriseCount {
  const _SurpriseCount({required this.id, required this.orderedBy, required this.orderedAt, required  List<CountItem> items, required this.status, this.finishedAt,  List<CountResult>? results}): _items = items,_results = results;
  factory _SurpriseCount.fromJson(Map<String, dynamic> json) => _$SurpriseCountFromJson(json);

@override final  String id;
@override final  Owner orderedBy;
@override final  DateTime orderedAt;
 final  List<CountItem> _items;
@override List<CountItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  CountStatus status;
@override final  DateTime? finishedAt;
 final  List<CountResult>? _results;
@override List<CountResult>? get results {
  final value = _results;
  if (value == null) return null;
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SurpriseCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurpriseCountCopyWith<_SurpriseCount> get copyWith => __$SurpriseCountCopyWithImpl<_SurpriseCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurpriseCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurpriseCount&&(identical(other.id, id) || other.id == id)&&(identical(other.orderedBy, orderedBy) || other.orderedBy == orderedBy)&&(identical(other.orderedAt, orderedAt) || other.orderedAt == orderedAt)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.status, status) || other.status == status)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orderedBy,orderedAt,const DeepCollectionEquality().hash(_items),status,finishedAt,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'SurpriseCount(id: $id, orderedBy: $orderedBy, orderedAt: $orderedAt, items: $items, status: $status, finishedAt: $finishedAt, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SurpriseCountCopyWith<$Res> implements $SurpriseCountCopyWith<$Res> {
  factory _$SurpriseCountCopyWith(_SurpriseCount value, $Res Function(_SurpriseCount) _then) = __$SurpriseCountCopyWithImpl;
@override @useResult
$Res call({
 String id, Owner orderedBy, DateTime orderedAt, List<CountItem> items, CountStatus status, DateTime? finishedAt, List<CountResult>? results
});


@override $OwnerCopyWith<$Res> get orderedBy;

}
/// @nodoc
class __$SurpriseCountCopyWithImpl<$Res>
    implements _$SurpriseCountCopyWith<$Res> {
  __$SurpriseCountCopyWithImpl(this._self, this._then);

  final _SurpriseCount _self;
  final $Res Function(_SurpriseCount) _then;

/// Create a copy of SurpriseCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderedBy = null,Object? orderedAt = null,Object? items = null,Object? status = null,Object? finishedAt = freezed,Object? results = freezed,}) {
  return _then(_SurpriseCount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderedBy: null == orderedBy ? _self.orderedBy : orderedBy // ignore: cast_nullable_to_non_nullable
as Owner,orderedAt: null == orderedAt ? _self.orderedAt : orderedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CountItem>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CountStatus,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,results: freezed == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<CountResult>?,
  ));
}

/// Create a copy of SurpriseCount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerCopyWith<$Res> get orderedBy {
  
  return $OwnerCopyWith<$Res>(_self.orderedBy, (value) {
    return _then(_self.copyWith(orderedBy: value));
  });
}
}

// dart format on
