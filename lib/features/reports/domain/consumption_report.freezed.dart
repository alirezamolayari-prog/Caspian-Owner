// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consumption_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsumptionLine {

 String get itemNameFa; double get qty; String get unitFa;
/// Create a copy of ConsumptionLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionLineCopyWith<ConsumptionLine> get copyWith => _$ConsumptionLineCopyWithImpl<ConsumptionLine>(this as ConsumptionLine, _$identity);

  /// Serializes this ConsumptionLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsumptionLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionLine&&(identical(other.itemNameFa, _this.itemNameFa) || other.itemNameFa == _this.itemNameFa)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitFa, _this.unitFa) || other.unitFa == _this.unitFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsumptionLine;
  return Object.hash(runtimeType,_this.itemNameFa,_this.qty,_this.unitFa);
}

@override
String toString() {
  final _this = this as ConsumptionLine;
  return 'ConsumptionLine(itemNameFa: ${_this.itemNameFa}, qty: ${_this.qty}, unitFa: ${_this.unitFa})';
}


}

/// @nodoc
abstract mixin class $ConsumptionLineCopyWith<$Res>  {
  factory $ConsumptionLineCopyWith(ConsumptionLine value, $Res Function(ConsumptionLine) _then) = _$ConsumptionLineCopyWithImpl;
@useResult
$Res call({
 String itemNameFa, double qty, String unitFa
});




}
/// @nodoc
class _$ConsumptionLineCopyWithImpl<$Res>
    implements $ConsumptionLineCopyWith<$Res> {
  _$ConsumptionLineCopyWithImpl(this._self, this._then);

  final ConsumptionLine _self;
  final $Res Function(ConsumptionLine) _then;

/// Create a copy of ConsumptionLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemNameFa = null,Object? qty = null,Object? unitFa = null,}) {
  return _then(ConsumptionLine(
itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionLine].
extension ConsumptionLinePatterns on ConsumptionLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionLine value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionLine value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemNameFa,  double qty,  String unitFa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionLine() when $default != null:
return $default(_that.itemNameFa,_that.qty,_that.unitFa);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemNameFa,  double qty,  String unitFa)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionLine():
return $default(_that.itemNameFa,_that.qty,_that.unitFa);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemNameFa,  double qty,  String unitFa)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionLine() when $default != null:
return $default(_that.itemNameFa,_that.qty,_that.unitFa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsumptionLine implements ConsumptionLine {
  const _ConsumptionLine({required this.itemNameFa, required this.qty, required this.unitFa});
  factory _ConsumptionLine.fromJson(Map<String, dynamic> json) => _$ConsumptionLineFromJson(json);

@override final  String itemNameFa;
@override final  double qty;
@override final  String unitFa;

/// Create a copy of ConsumptionLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionLineCopyWith<_ConsumptionLine> get copyWith => __$ConsumptionLineCopyWithImpl<_ConsumptionLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsumptionLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionLine&&(identical(other.itemNameFa, itemNameFa) || other.itemNameFa == itemNameFa)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitFa, unitFa) || other.unitFa == unitFa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemNameFa,qty,unitFa);
}

@override
String toString() {
    return 'ConsumptionLine(itemNameFa: $itemNameFa, qty: $qty, unitFa: $unitFa)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionLineCopyWith<$Res> implements $ConsumptionLineCopyWith<$Res> {
  factory _$ConsumptionLineCopyWith(_ConsumptionLine value, $Res Function(_ConsumptionLine) _then) = __$ConsumptionLineCopyWithImpl;
@override @useResult
$Res call({
 String itemNameFa, double qty, String unitFa
});




}
/// @nodoc
class __$ConsumptionLineCopyWithImpl<$Res>
    implements _$ConsumptionLineCopyWith<$Res> {
  __$ConsumptionLineCopyWithImpl(this._self, this._then);

  final _ConsumptionLine _self;
  final $Res Function(_ConsumptionLine) _then;

/// Create a copy of ConsumptionLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemNameFa = null,Object? qty = null,Object? unitFa = null,}) {
  return _then(_ConsumptionLine(
itemNameFa: null == itemNameFa ? _self.itemNameFa : itemNameFa // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitFa: null == unitFa ? _self.unitFa : unitFa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConsumptionReportRow {

 String get code; String get nameFa;/// Number of issued line items in the period.
 double get total; List<ConsumptionLine>? get lines;
/// Create a copy of ConsumptionReportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionReportRowCopyWith<ConsumptionReportRow> get copyWith => _$ConsumptionReportRowCopyWithImpl<ConsumptionReportRow>(this as ConsumptionReportRow, _$identity);

  /// Serializes this ConsumptionReportRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsumptionReportRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionReportRow&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nameFa, _this.nameFa) || other.nameFa == _this.nameFa)&&(identical(other.total, _this.total) || other.total == _this.total)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsumptionReportRow;
  return Object.hash(runtimeType,_this.code,_this.nameFa,_this.total,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as ConsumptionReportRow;
  return 'ConsumptionReportRow(code: ${_this.code}, nameFa: ${_this.nameFa}, total: ${_this.total}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $ConsumptionReportRowCopyWith<$Res>  {
  factory $ConsumptionReportRowCopyWith(ConsumptionReportRow value, $Res Function(ConsumptionReportRow) _then) = _$ConsumptionReportRowCopyWithImpl;
@useResult
$Res call({
 String code, String nameFa, double total, List<ConsumptionLine>? lines
});




}
/// @nodoc
class _$ConsumptionReportRowCopyWithImpl<$Res>
    implements $ConsumptionReportRowCopyWith<$Res> {
  _$ConsumptionReportRowCopyWithImpl(this._self, this._then);

  final ConsumptionReportRow _self;
  final $Res Function(ConsumptionReportRow) _then;

/// Create a copy of ConsumptionReportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameFa = null,Object? total = null,Object? lines = freezed,}) {
  return _then(ConsumptionReportRow(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,lines: freezed == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<ConsumptionLine>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionReportRow].
extension ConsumptionReportRowPatterns on ConsumptionReportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionReportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionReportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionReportRow value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionReportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionReportRow value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionReportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nameFa,  double total,  List<ConsumptionLine>? lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionReportRow() when $default != null:
return $default(_that.code,_that.nameFa,_that.total,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nameFa,  double total,  List<ConsumptionLine>? lines)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionReportRow():
return $default(_that.code,_that.nameFa,_that.total,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nameFa,  double total,  List<ConsumptionLine>? lines)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionReportRow() when $default != null:
return $default(_that.code,_that.nameFa,_that.total,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsumptionReportRow implements ConsumptionReportRow {
  const _ConsumptionReportRow({required this.code, required this.nameFa, required this.total,  List<ConsumptionLine>? lines}): _lines = lines;
  factory _ConsumptionReportRow.fromJson(Map<String, dynamic> json) => _$ConsumptionReportRowFromJson(json);

@override final  String code;
@override final  String nameFa;
/// Number of issued line items in the period.
@override final  double total;
 final  List<ConsumptionLine>? _lines;
@override List<ConsumptionLine>? get lines {
  final value = _lines;
  if (value == null) return null;
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ConsumptionReportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionReportRowCopyWith<_ConsumptionReportRow> get copyWith => __$ConsumptionReportRowCopyWithImpl<_ConsumptionReportRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsumptionReportRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionReportRow&&(identical(other.code, code) || other.code == code)&&(identical(other.nameFa, nameFa) || other.nameFa == nameFa)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,nameFa,total,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'ConsumptionReportRow(code: $code, nameFa: $nameFa, total: $total, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionReportRowCopyWith<$Res> implements $ConsumptionReportRowCopyWith<$Res> {
  factory _$ConsumptionReportRowCopyWith(_ConsumptionReportRow value, $Res Function(_ConsumptionReportRow) _then) = __$ConsumptionReportRowCopyWithImpl;
@override @useResult
$Res call({
 String code, String nameFa, double total, List<ConsumptionLine>? lines
});




}
/// @nodoc
class __$ConsumptionReportRowCopyWithImpl<$Res>
    implements _$ConsumptionReportRowCopyWith<$Res> {
  __$ConsumptionReportRowCopyWithImpl(this._self, this._then);

  final _ConsumptionReportRow _self;
  final $Res Function(_ConsumptionReportRow) _then;

/// Create a copy of ConsumptionReportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameFa = null,Object? total = null,Object? lines = freezed,}) {
  return _then(_ConsumptionReportRow(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,lines: freezed == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<ConsumptionLine>?,
  ));
}


}


/// @nodoc
mixin _$ConsumptionReport {

 ReportGrouping get groupBy; DateTime get from; DateTime get to; List<ConsumptionReportRow> get rows;
/// Create a copy of ConsumptionReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionReportCopyWith<ConsumptionReport> get copyWith => _$ConsumptionReportCopyWithImpl<ConsumptionReport>(this as ConsumptionReport, _$identity);

  /// Serializes this ConsumptionReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsumptionReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionReport&&(identical(other.groupBy, _this.groupBy) || other.groupBy == _this.groupBy)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&const DeepCollectionEquality().equals(other.rows, _this.rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsumptionReport;
  return Object.hash(runtimeType,_this.groupBy,_this.from,_this.to,const DeepCollectionEquality().hash(_this.rows));
}

@override
String toString() {
  final _this = this as ConsumptionReport;
  return 'ConsumptionReport(groupBy: ${_this.groupBy}, from: ${_this.from}, to: ${_this.to}, rows: ${_this.rows})';
}


}

/// @nodoc
abstract mixin class $ConsumptionReportCopyWith<$Res>  {
  factory $ConsumptionReportCopyWith(ConsumptionReport value, $Res Function(ConsumptionReport) _then) = _$ConsumptionReportCopyWithImpl;
@useResult
$Res call({
 ReportGrouping groupBy, DateTime from, DateTime to, List<ConsumptionReportRow> rows
});




}
/// @nodoc
class _$ConsumptionReportCopyWithImpl<$Res>
    implements $ConsumptionReportCopyWith<$Res> {
  _$ConsumptionReportCopyWithImpl(this._self, this._then);

  final ConsumptionReport _self;
  final $Res Function(ConsumptionReport) _then;

/// Create a copy of ConsumptionReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupBy = null,Object? from = null,Object? to = null,Object? rows = null,}) {
  return _then(ConsumptionReport(
groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as ReportGrouping,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<ConsumptionReportRow>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionReport].
extension ConsumptionReportPatterns on ConsumptionReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionReport value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionReport value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportGrouping groupBy,  DateTime from,  DateTime to,  List<ConsumptionReportRow> rows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionReport() when $default != null:
return $default(_that.groupBy,_that.from,_that.to,_that.rows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportGrouping groupBy,  DateTime from,  DateTime to,  List<ConsumptionReportRow> rows)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionReport():
return $default(_that.groupBy,_that.from,_that.to,_that.rows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportGrouping groupBy,  DateTime from,  DateTime to,  List<ConsumptionReportRow> rows)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionReport() when $default != null:
return $default(_that.groupBy,_that.from,_that.to,_that.rows);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsumptionReport implements ConsumptionReport {
  const _ConsumptionReport({required this.groupBy, required this.from, required this.to, required  List<ConsumptionReportRow> rows}): _rows = rows;
  factory _ConsumptionReport.fromJson(Map<String, dynamic> json) => _$ConsumptionReportFromJson(json);

@override final  ReportGrouping groupBy;
@override final  DateTime from;
@override final  DateTime to;
 final  List<ConsumptionReportRow> _rows;
@override List<ConsumptionReportRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}


/// Create a copy of ConsumptionReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionReportCopyWith<_ConsumptionReport> get copyWith => __$ConsumptionReportCopyWithImpl<_ConsumptionReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsumptionReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionReport&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other.rows, _rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,groupBy,from,to,const DeepCollectionEquality().hash(_rows));
}

@override
String toString() {
    return 'ConsumptionReport(groupBy: $groupBy, from: $from, to: $to, rows: $rows)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionReportCopyWith<$Res> implements $ConsumptionReportCopyWith<$Res> {
  factory _$ConsumptionReportCopyWith(_ConsumptionReport value, $Res Function(_ConsumptionReport) _then) = __$ConsumptionReportCopyWithImpl;
@override @useResult
$Res call({
 ReportGrouping groupBy, DateTime from, DateTime to, List<ConsumptionReportRow> rows
});




}
/// @nodoc
class __$ConsumptionReportCopyWithImpl<$Res>
    implements _$ConsumptionReportCopyWith<$Res> {
  __$ConsumptionReportCopyWithImpl(this._self, this._then);

  final _ConsumptionReport _self;
  final $Res Function(_ConsumptionReport) _then;

/// Create a copy of ConsumptionReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupBy = null,Object? from = null,Object? to = null,Object? rows = null,}) {
  return _then(_ConsumptionReport(
groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as ReportGrouping,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<ConsumptionReportRow>,
  ));
}


}

// dart format on
