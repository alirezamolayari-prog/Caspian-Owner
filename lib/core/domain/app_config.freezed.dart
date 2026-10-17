// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfig {

/// Enabled features, e.g. `assistant`, `reports`.
 List<String> get featureFlags;/// Enabled modules, e.g. `warehouse`. Other Caspian apps plug in here.
 List<String> get modules;/// Builds below this must update before use (blocking update screen).
 int get minSupportedBuild;/// Announced modules, shown on the hub as «به‌زودی» (e.g. `parking`).
 List<String> get upcomingModules;
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfig&&const DeepCollectionEquality().equals(other.featureFlags, _this.featureFlags)&&const DeepCollectionEquality().equals(other.modules, _this.modules)&&(identical(other.minSupportedBuild, _this.minSupportedBuild) || other.minSupportedBuild == _this.minSupportedBuild)&&const DeepCollectionEquality().equals(other.upcomingModules, _this.upcomingModules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppConfig;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.featureFlags),const DeepCollectionEquality().hash(_this.modules),_this.minSupportedBuild,const DeepCollectionEquality().hash(_this.upcomingModules));
}

@override
String toString() {
  final _this = this as AppConfig;
  return 'AppConfig(featureFlags: ${_this.featureFlags}, modules: ${_this.modules}, minSupportedBuild: ${_this.minSupportedBuild}, upcomingModules: ${_this.upcomingModules})';
}


}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res>  {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
@useResult
$Res call({
 List<String> featureFlags, List<String> modules, int minSupportedBuild, List<String> upcomingModules
});




}
/// @nodoc
class _$AppConfigCopyWithImpl<$Res>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? featureFlags = null,Object? modules = null,Object? minSupportedBuild = null,Object? upcomingModules = null,}) {
  return _then(AppConfig(
featureFlags: null == featureFlags ? _self.featureFlags : featureFlags // ignore: cast_nullable_to_non_nullable
as List<String>,modules: null == modules ? _self.modules : modules // ignore: cast_nullable_to_non_nullable
as List<String>,minSupportedBuild: null == minSupportedBuild ? _self.minSupportedBuild : minSupportedBuild // ignore: cast_nullable_to_non_nullable
as int,upcomingModules: null == upcomingModules ? _self.upcomingModules : upcomingModules // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> featureFlags,  List<String> modules,  int minSupportedBuild,  List<String> upcomingModules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.featureFlags,_that.modules,_that.minSupportedBuild,_that.upcomingModules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> featureFlags,  List<String> modules,  int minSupportedBuild,  List<String> upcomingModules)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.featureFlags,_that.modules,_that.minSupportedBuild,_that.upcomingModules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> featureFlags,  List<String> modules,  int minSupportedBuild,  List<String> upcomingModules)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.featureFlags,_that.modules,_that.minSupportedBuild,_that.upcomingModules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfig extends AppConfig {
  const _AppConfig({required  List<String> featureFlags, required  List<String> modules, required this.minSupportedBuild,  List<String> upcomingModules = const <String>[]}): _featureFlags = featureFlags,_modules = modules,_upcomingModules = upcomingModules,super._();
  factory _AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

/// Enabled features, e.g. `assistant`, `reports`.
 final  List<String> _featureFlags;
/// Enabled features, e.g. `assistant`, `reports`.
@override List<String> get featureFlags {
  if (_featureFlags is EqualUnmodifiableListView) return _featureFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featureFlags);
}

/// Enabled modules, e.g. `warehouse`. Other Caspian apps plug in here.
 final  List<String> _modules;
/// Enabled modules, e.g. `warehouse`. Other Caspian apps plug in here.
@override List<String> get modules {
  if (_modules is EqualUnmodifiableListView) return _modules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modules);
}

/// Builds below this must update before use (blocking update screen).
@override final  int minSupportedBuild;
/// Announced modules, shown on the hub as «به‌زودی» (e.g. `parking`).
 final  List<String> _upcomingModules;
/// Announced modules, shown on the hub as «به‌زودی» (e.g. `parking`).
@override@JsonKey() List<String> get upcomingModules {
  if (_upcomingModules is EqualUnmodifiableListView) return _upcomingModules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcomingModules);
}


/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&const DeepCollectionEquality().equals(other.featureFlags, _featureFlags)&&const DeepCollectionEquality().equals(other.modules, _modules)&&(identical(other.minSupportedBuild, minSupportedBuild) || other.minSupportedBuild == minSupportedBuild)&&const DeepCollectionEquality().equals(other.upcomingModules, _upcomingModules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_featureFlags),const DeepCollectionEquality().hash(_modules),minSupportedBuild,const DeepCollectionEquality().hash(_upcomingModules));
}

@override
String toString() {
    return 'AppConfig(featureFlags: $featureFlags, modules: $modules, minSupportedBuild: $minSupportedBuild, upcomingModules: $upcomingModules)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
 List<String> featureFlags, List<String> modules, int minSupportedBuild, List<String> upcomingModules
});




}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? featureFlags = null,Object? modules = null,Object? minSupportedBuild = null,Object? upcomingModules = null,}) {
  return _then(_AppConfig(
featureFlags: null == featureFlags ? _self._featureFlags : featureFlags // ignore: cast_nullable_to_non_nullable
as List<String>,modules: null == modules ? _self._modules : modules // ignore: cast_nullable_to_non_nullable
as List<String>,minSupportedBuild: null == minSupportedBuild ? _self.minSupportedBuild : minSupportedBuild // ignore: cast_nullable_to_non_nullable
as int,upcomingModules: null == upcomingModules ? _self._upcomingModules : upcomingModules // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
