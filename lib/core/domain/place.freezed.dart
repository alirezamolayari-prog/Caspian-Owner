// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Floor {

 String get code; String get nameFa;/// Building order, bottom to top: P4 = 0 … ROOF = 9.
 int get sortOrder;
/// Create a copy of Floor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorCopyWith<Floor> get copyWith => _$FloorCopyWithImpl<Floor>(this as Floor, _$identity);

  /// Serializes this Floor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Floor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Floor&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nameFa, _this.nameFa) || other.nameFa == _this.nameFa)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Floor;
  return Object.hash(runtimeType,_this.code,_this.nameFa,_this.sortOrder);
}

@override
String toString() {
  final _this = this as Floor;
  return 'Floor(code: ${_this.code}, nameFa: ${_this.nameFa}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $FloorCopyWith<$Res>  {
  factory $FloorCopyWith(Floor value, $Res Function(Floor) _then) = _$FloorCopyWithImpl;
@useResult
$Res call({
 String code, String nameFa, int sortOrder
});




}
/// @nodoc
class _$FloorCopyWithImpl<$Res>
    implements $FloorCopyWith<$Res> {
  _$FloorCopyWithImpl(this._self, this._then);

  final Floor _self;
  final $Res Function(Floor) _then;

/// Create a copy of Floor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameFa = null,Object? sortOrder = null,}) {
  return _then(Floor(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Floor].
extension FloorPatterns on Floor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Floor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Floor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Floor value)  $default,){
final _that = this;
switch (_that) {
case _Floor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Floor value)?  $default,){
final _that = this;
switch (_that) {
case _Floor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nameFa,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Floor() when $default != null:
return $default(_that.code,_that.nameFa,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nameFa,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Floor():
return $default(_that.code,_that.nameFa,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nameFa,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Floor() when $default != null:
return $default(_that.code,_that.nameFa,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Floor implements Floor {
  const _Floor({required this.code, required this.nameFa, required this.sortOrder});
  factory _Floor.fromJson(Map<String, dynamic> json) => _$FloorFromJson(json);

@override final  String code;
@override final  String nameFa;
/// Building order, bottom to top: P4 = 0 … ROOF = 9.
@override final  int sortOrder;

/// Create a copy of Floor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorCopyWith<_Floor> get copyWith => __$FloorCopyWithImpl<_Floor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FloorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Floor&&(identical(other.code, code) || other.code == code)&&(identical(other.nameFa, nameFa) || other.nameFa == nameFa)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,nameFa,sortOrder);
}

@override
String toString() {
    return 'Floor(code: $code, nameFa: $nameFa, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$FloorCopyWith<$Res> implements $FloorCopyWith<$Res> {
  factory _$FloorCopyWith(_Floor value, $Res Function(_Floor) _then) = __$FloorCopyWithImpl;
@override @useResult
$Res call({
 String code, String nameFa, int sortOrder
});




}
/// @nodoc
class __$FloorCopyWithImpl<$Res>
    implements _$FloorCopyWith<$Res> {
  __$FloorCopyWithImpl(this._self, this._then);

  final _Floor _self;
  final $Res Function(_Floor) _then;

/// Create a copy of Floor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameFa = null,Object? sortOrder = null,}) {
  return _then(_Floor(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Location {

 String get code; String get nameFa; LocationType get type; bool get needsFloor; bool get isActive; String? get floorCode; List<String> get aliases; List<String> get mergedWith;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Location;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nameFa, _this.nameFa) || other.nameFa == _this.nameFa)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.needsFloor, _this.needsFloor) || other.needsFloor == _this.needsFloor)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.floorCode, _this.floorCode) || other.floorCode == _this.floorCode)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&const DeepCollectionEquality().equals(other.mergedWith, _this.mergedWith));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Location;
  return Object.hash(runtimeType,_this.code,_this.nameFa,_this.type,_this.needsFloor,_this.isActive,_this.floorCode,const DeepCollectionEquality().hash(_this.aliases),const DeepCollectionEquality().hash(_this.mergedWith));
}

@override
String toString() {
  final _this = this as Location;
  return 'Location(code: ${_this.code}, nameFa: ${_this.nameFa}, type: ${_this.type}, needsFloor: ${_this.needsFloor}, isActive: ${_this.isActive}, floorCode: ${_this.floorCode}, aliases: ${_this.aliases}, mergedWith: ${_this.mergedWith})';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 String code, String nameFa, LocationType type, bool needsFloor, bool isActive, String? floorCode, List<String> aliases, List<String> mergedWith
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameFa = null,Object? type = null,Object? needsFloor = null,Object? isActive = null,Object? floorCode = freezed,Object? aliases = null,Object? mergedWith = null,}) {
  return _then(Location(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LocationType,needsFloor: null == needsFloor ? _self.needsFloor : needsFloor // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,floorCode: freezed == floorCode ? _self.floorCode : floorCode // ignore: cast_nullable_to_non_nullable
as String?,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,mergedWith: null == mergedWith ? _self.mergedWith : mergedWith // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nameFa,  LocationType type,  bool needsFloor,  bool isActive,  String? floorCode,  List<String> aliases,  List<String> mergedWith)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.code,_that.nameFa,_that.type,_that.needsFloor,_that.isActive,_that.floorCode,_that.aliases,_that.mergedWith);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nameFa,  LocationType type,  bool needsFloor,  bool isActive,  String? floorCode,  List<String> aliases,  List<String> mergedWith)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.code,_that.nameFa,_that.type,_that.needsFloor,_that.isActive,_that.floorCode,_that.aliases,_that.mergedWith);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nameFa,  LocationType type,  bool needsFloor,  bool isActive,  String? floorCode,  List<String> aliases,  List<String> mergedWith)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.code,_that.nameFa,_that.type,_that.needsFloor,_that.isActive,_that.floorCode,_that.aliases,_that.mergedWith);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Location implements Location {
  const _Location({required this.code, required this.nameFa, required this.type, required this.needsFloor, required this.isActive, this.floorCode,  List<String> aliases = const <String>[],  List<String> mergedWith = const <String>[]}): _aliases = aliases,_mergedWith = mergedWith;
  factory _Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

@override final  String code;
@override final  String nameFa;
@override final  LocationType type;
@override final  bool needsFloor;
@override final  bool isActive;
@override final  String? floorCode;
 final  List<String> _aliases;
@override@JsonKey() List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

 final  List<String> _mergedWith;
@override@JsonKey() List<String> get mergedWith {
  if (_mergedWith is EqualUnmodifiableListView) return _mergedWith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mergedWith);
}


/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.code, code) || other.code == code)&&(identical(other.nameFa, nameFa) || other.nameFa == nameFa)&&(identical(other.type, type) || other.type == type)&&(identical(other.needsFloor, needsFloor) || other.needsFloor == needsFloor)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.floorCode, floorCode) || other.floorCode == floorCode)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&const DeepCollectionEquality().equals(other.mergedWith, _mergedWith));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,nameFa,type,needsFloor,isActive,floorCode,const DeepCollectionEquality().hash(_aliases),const DeepCollectionEquality().hash(_mergedWith));
}

@override
String toString() {
    return 'Location(code: $code, nameFa: $nameFa, type: $type, needsFloor: $needsFloor, isActive: $isActive, floorCode: $floorCode, aliases: $aliases, mergedWith: $mergedWith)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 String code, String nameFa, LocationType type, bool needsFloor, bool isActive, String? floorCode, List<String> aliases, List<String> mergedWith
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameFa = null,Object? type = null,Object? needsFloor = null,Object? isActive = null,Object? floorCode = freezed,Object? aliases = null,Object? mergedWith = null,}) {
  return _then(_Location(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LocationType,needsFloor: null == needsFloor ? _self.needsFloor : needsFloor // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,floorCode: freezed == floorCode ? _self.floorCode : floorCode // ignore: cast_nullable_to_non_nullable
as String?,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,mergedWith: null == mergedWith ? _self._mergedWith : mergedWith // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$LocationsSnapshot {

 String get version; List<Floor> get floors; List<Location> get locations;
/// Create a copy of LocationsSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationsSnapshotCopyWith<LocationsSnapshot> get copyWith => _$LocationsSnapshotCopyWithImpl<LocationsSnapshot>(this as LocationsSnapshot, _$identity);

  /// Serializes this LocationsSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocationsSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationsSnapshot&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.floors, _this.floors)&&const DeepCollectionEquality().equals(other.locations, _this.locations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocationsSnapshot;
  return Object.hash(runtimeType,_this.version,const DeepCollectionEquality().hash(_this.floors),const DeepCollectionEquality().hash(_this.locations));
}

@override
String toString() {
  final _this = this as LocationsSnapshot;
  return 'LocationsSnapshot(version: ${_this.version}, floors: ${_this.floors}, locations: ${_this.locations})';
}


}

/// @nodoc
abstract mixin class $LocationsSnapshotCopyWith<$Res>  {
  factory $LocationsSnapshotCopyWith(LocationsSnapshot value, $Res Function(LocationsSnapshot) _then) = _$LocationsSnapshotCopyWithImpl;
@useResult
$Res call({
 String version, List<Floor> floors, List<Location> locations
});




}
/// @nodoc
class _$LocationsSnapshotCopyWithImpl<$Res>
    implements $LocationsSnapshotCopyWith<$Res> {
  _$LocationsSnapshotCopyWithImpl(this._self, this._then);

  final LocationsSnapshot _self;
  final $Res Function(LocationsSnapshot) _then;

/// Create a copy of LocationsSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? floors = null,Object? locations = null,}) {
  return _then(LocationsSnapshot(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,floors: null == floors ? _self.floors : floors // ignore: cast_nullable_to_non_nullable
as List<Floor>,locations: null == locations ? _self.locations : locations // ignore: cast_nullable_to_non_nullable
as List<Location>,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationsSnapshot].
extension LocationsSnapshotPatterns on LocationsSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationsSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationsSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationsSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _LocationsSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationsSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _LocationsSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  List<Floor> floors,  List<Location> locations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationsSnapshot() when $default != null:
return $default(_that.version,_that.floors,_that.locations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  List<Floor> floors,  List<Location> locations)  $default,) {final _that = this;
switch (_that) {
case _LocationsSnapshot():
return $default(_that.version,_that.floors,_that.locations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  List<Floor> floors,  List<Location> locations)?  $default,) {final _that = this;
switch (_that) {
case _LocationsSnapshot() when $default != null:
return $default(_that.version,_that.floors,_that.locations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationsSnapshot implements LocationsSnapshot {
  const _LocationsSnapshot({required this.version, required  List<Floor> floors, required  List<Location> locations}): _floors = floors,_locations = locations;
  factory _LocationsSnapshot.fromJson(Map<String, dynamic> json) => _$LocationsSnapshotFromJson(json);

@override final  String version;
 final  List<Floor> _floors;
@override List<Floor> get floors {
  if (_floors is EqualUnmodifiableListView) return _floors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_floors);
}

 final  List<Location> _locations;
@override List<Location> get locations {
  if (_locations is EqualUnmodifiableListView) return _locations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_locations);
}


/// Create a copy of LocationsSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationsSnapshotCopyWith<_LocationsSnapshot> get copyWith => __$LocationsSnapshotCopyWithImpl<_LocationsSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationsSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationsSnapshot&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.floors, _floors)&&const DeepCollectionEquality().equals(other.locations, _locations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_floors),const DeepCollectionEquality().hash(_locations));
}

@override
String toString() {
    return 'LocationsSnapshot(version: $version, floors: $floors, locations: $locations)';
}


}

/// @nodoc
abstract mixin class _$LocationsSnapshotCopyWith<$Res> implements $LocationsSnapshotCopyWith<$Res> {
  factory _$LocationsSnapshotCopyWith(_LocationsSnapshot value, $Res Function(_LocationsSnapshot) _then) = __$LocationsSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String version, List<Floor> floors, List<Location> locations
});




}
/// @nodoc
class __$LocationsSnapshotCopyWithImpl<$Res>
    implements _$LocationsSnapshotCopyWith<$Res> {
  __$LocationsSnapshotCopyWithImpl(this._self, this._then);

  final _LocationsSnapshot _self;
  final $Res Function(_LocationsSnapshot) _then;

/// Create a copy of LocationsSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? floors = null,Object? locations = null,}) {
  return _then(_LocationsSnapshot(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,floors: null == floors ? _self._floors : floors // ignore: cast_nullable_to_non_nullable
as List<Floor>,locations: null == locations ? _self._locations : locations // ignore: cast_nullable_to_non_nullable
as List<Location>,
  ));
}


}


/// @nodoc
mixin _$ConsumptionPlace {

 String get locationCode; String get floorCode; String? get usageNote;
/// Create a copy of ConsumptionPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionPlaceCopyWith<ConsumptionPlace> get copyWith => _$ConsumptionPlaceCopyWithImpl<ConsumptionPlace>(this as ConsumptionPlace, _$identity);

  /// Serializes this ConsumptionPlace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsumptionPlace;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionPlace&&(identical(other.locationCode, _this.locationCode) || other.locationCode == _this.locationCode)&&(identical(other.floorCode, _this.floorCode) || other.floorCode == _this.floorCode)&&(identical(other.usageNote, _this.usageNote) || other.usageNote == _this.usageNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsumptionPlace;
  return Object.hash(runtimeType,_this.locationCode,_this.floorCode,_this.usageNote);
}

@override
String toString() {
  final _this = this as ConsumptionPlace;
  return 'ConsumptionPlace(locationCode: ${_this.locationCode}, floorCode: ${_this.floorCode}, usageNote: ${_this.usageNote})';
}


}

/// @nodoc
abstract mixin class $ConsumptionPlaceCopyWith<$Res>  {
  factory $ConsumptionPlaceCopyWith(ConsumptionPlace value, $Res Function(ConsumptionPlace) _then) = _$ConsumptionPlaceCopyWithImpl;
@useResult
$Res call({
 String locationCode, String floorCode, String? usageNote
});




}
/// @nodoc
class _$ConsumptionPlaceCopyWithImpl<$Res>
    implements $ConsumptionPlaceCopyWith<$Res> {
  _$ConsumptionPlaceCopyWithImpl(this._self, this._then);

  final ConsumptionPlace _self;
  final $Res Function(ConsumptionPlace) _then;

/// Create a copy of ConsumptionPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locationCode = null,Object? floorCode = null,Object? usageNote = freezed,}) {
  return _then(ConsumptionPlace(
locationCode: null == locationCode ? _self.locationCode : locationCode // ignore: cast_nullable_to_non_nullable
as String,floorCode: null == floorCode ? _self.floorCode : floorCode // ignore: cast_nullable_to_non_nullable
as String,usageNote: freezed == usageNote ? _self.usageNote : usageNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionPlace].
extension ConsumptionPlacePatterns on ConsumptionPlace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionPlace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionPlace value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionPlace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionPlace value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionPlace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String locationCode,  String floorCode,  String? usageNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionPlace() when $default != null:
return $default(_that.locationCode,_that.floorCode,_that.usageNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String locationCode,  String floorCode,  String? usageNote)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionPlace():
return $default(_that.locationCode,_that.floorCode,_that.usageNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String locationCode,  String floorCode,  String? usageNote)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionPlace() when $default != null:
return $default(_that.locationCode,_that.floorCode,_that.usageNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsumptionPlace implements ConsumptionPlace {
  const _ConsumptionPlace({required this.locationCode, required this.floorCode, this.usageNote});
  factory _ConsumptionPlace.fromJson(Map<String, dynamic> json) => _$ConsumptionPlaceFromJson(json);

@override final  String locationCode;
@override final  String floorCode;
@override final  String? usageNote;

/// Create a copy of ConsumptionPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionPlaceCopyWith<_ConsumptionPlace> get copyWith => __$ConsumptionPlaceCopyWithImpl<_ConsumptionPlace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsumptionPlaceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionPlace&&(identical(other.locationCode, locationCode) || other.locationCode == locationCode)&&(identical(other.floorCode, floorCode) || other.floorCode == floorCode)&&(identical(other.usageNote, usageNote) || other.usageNote == usageNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,locationCode,floorCode,usageNote);
}

@override
String toString() {
    return 'ConsumptionPlace(locationCode: $locationCode, floorCode: $floorCode, usageNote: $usageNote)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionPlaceCopyWith<$Res> implements $ConsumptionPlaceCopyWith<$Res> {
  factory _$ConsumptionPlaceCopyWith(_ConsumptionPlace value, $Res Function(_ConsumptionPlace) _then) = __$ConsumptionPlaceCopyWithImpl;
@override @useResult
$Res call({
 String locationCode, String floorCode, String? usageNote
});




}
/// @nodoc
class __$ConsumptionPlaceCopyWithImpl<$Res>
    implements _$ConsumptionPlaceCopyWith<$Res> {
  __$ConsumptionPlaceCopyWithImpl(this._self, this._then);

  final _ConsumptionPlace _self;
  final $Res Function(_ConsumptionPlace) _then;

/// Create a copy of ConsumptionPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationCode = null,Object? floorCode = null,Object? usageNote = freezed,}) {
  return _then(_ConsumptionPlace(
locationCode: null == locationCode ? _self.locationCode : locationCode // ignore: cast_nullable_to_non_nullable
as String,floorCode: null == floorCode ? _self.floorCode : floorCode // ignore: cast_nullable_to_non_nullable
as String,usageNote: freezed == usageNote ? _self.usageNote : usageNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
