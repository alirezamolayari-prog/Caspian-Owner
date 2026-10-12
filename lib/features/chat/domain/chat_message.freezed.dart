// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatAuthor {

 ChatAuthorKind get kind; String get nameFa;/// True for messages written by the logged-in owner.
 bool get isMe;
/// Create a copy of ChatAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatAuthorCopyWith<ChatAuthor> get copyWith => _$ChatAuthorCopyWithImpl<ChatAuthor>(this as ChatAuthor, _$identity);

  /// Serializes this ChatAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatAuthor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatAuthor&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.nameFa, _this.nameFa) || other.nameFa == _this.nameFa)&&(identical(other.isMe, _this.isMe) || other.isMe == _this.isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatAuthor;
  return Object.hash(runtimeType,_this.kind,_this.nameFa,_this.isMe);
}

@override
String toString() {
  final _this = this as ChatAuthor;
  return 'ChatAuthor(kind: ${_this.kind}, nameFa: ${_this.nameFa}, isMe: ${_this.isMe})';
}


}

/// @nodoc
abstract mixin class $ChatAuthorCopyWith<$Res>  {
  factory $ChatAuthorCopyWith(ChatAuthor value, $Res Function(ChatAuthor) _then) = _$ChatAuthorCopyWithImpl;
@useResult
$Res call({
 ChatAuthorKind kind, String nameFa, bool isMe
});




}
/// @nodoc
class _$ChatAuthorCopyWithImpl<$Res>
    implements $ChatAuthorCopyWith<$Res> {
  _$ChatAuthorCopyWithImpl(this._self, this._then);

  final ChatAuthor _self;
  final $Res Function(ChatAuthor) _then;

/// Create a copy of ChatAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? nameFa = null,Object? isMe = null,}) {
  return _then(ChatAuthor(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatAuthorKind,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatAuthor].
extension ChatAuthorPatterns on ChatAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatAuthor value)  $default,){
final _that = this;
switch (_that) {
case _ChatAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _ChatAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatAuthorKind kind,  String nameFa,  bool isMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatAuthor() when $default != null:
return $default(_that.kind,_that.nameFa,_that.isMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatAuthorKind kind,  String nameFa,  bool isMe)  $default,) {final _that = this;
switch (_that) {
case _ChatAuthor():
return $default(_that.kind,_that.nameFa,_that.isMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatAuthorKind kind,  String nameFa,  bool isMe)?  $default,) {final _that = this;
switch (_that) {
case _ChatAuthor() when $default != null:
return $default(_that.kind,_that.nameFa,_that.isMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatAuthor implements ChatAuthor {
  const _ChatAuthor({required this.kind, required this.nameFa, this.isMe = false});
  factory _ChatAuthor.fromJson(Map<String, dynamic> json) => _$ChatAuthorFromJson(json);

@override final  ChatAuthorKind kind;
@override final  String nameFa;
/// True for messages written by the logged-in owner.
@override@JsonKey() final  bool isMe;

/// Create a copy of ChatAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatAuthorCopyWith<_ChatAuthor> get copyWith => __$ChatAuthorCopyWithImpl<_ChatAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatAuthor&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.nameFa, nameFa) || other.nameFa == nameFa)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,nameFa,isMe);
}

@override
String toString() {
    return 'ChatAuthor(kind: $kind, nameFa: $nameFa, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class _$ChatAuthorCopyWith<$Res> implements $ChatAuthorCopyWith<$Res> {
  factory _$ChatAuthorCopyWith(_ChatAuthor value, $Res Function(_ChatAuthor) _then) = __$ChatAuthorCopyWithImpl;
@override @useResult
$Res call({
 ChatAuthorKind kind, String nameFa, bool isMe
});




}
/// @nodoc
class __$ChatAuthorCopyWithImpl<$Res>
    implements _$ChatAuthorCopyWith<$Res> {
  __$ChatAuthorCopyWithImpl(this._self, this._then);

  final _ChatAuthor _self;
  final $Res Function(_ChatAuthor) _then;

/// Create a copy of ChatAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? nameFa = null,Object? isMe = null,}) {
  return _then(_ChatAuthor(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatAuthorKind,nameFa: null == nameFa ? _self.nameFa : nameFa // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatMessage {

 String get id; String get requestId; ChatAuthor get author; String get text; DateTime get sentAt;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessage;
  return Object.hash(runtimeType,_this.id,_this.requestId,_this.author,_this.text,_this.sentAt);
}

@override
String toString() {
  final _this = this as ChatMessage;
  return 'ChatMessage(id: ${_this.id}, requestId: ${_this.requestId}, author: ${_this.author}, text: ${_this.text}, sentAt: ${_this.sentAt})';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String requestId, ChatAuthor author, String text, DateTime sentAt
});


$ChatAuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? author = null,Object? text = null,Object? sentAt = null,}) {
  return _then(ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ChatAuthor,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatAuthorCopyWith<$Res> get author {
  
  return $ChatAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestId,  ChatAuthor author,  String text,  DateTime sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.requestId,_that.author,_that.text,_that.sentAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestId,  ChatAuthor author,  String text,  DateTime sentAt)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.requestId,_that.author,_that.text,_that.sentAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestId,  ChatAuthor author,  String text,  DateTime sentAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.requestId,_that.author,_that.text,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.requestId, required this.author, required this.text, required this.sentAt});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  String requestId;
@override final  ChatAuthor author;
@override final  String text;
@override final  DateTime sentAt;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.author, author) || other.author == author)&&(identical(other.text, text) || other.text == text)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,requestId,author,text,sentAt);
}

@override
String toString() {
    return 'ChatMessage(id: $id, requestId: $requestId, author: $author, text: $text, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestId, ChatAuthor author, String text, DateTime sentAt
});


@override $ChatAuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? author = null,Object? text = null,Object? sentAt = null,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ChatAuthor,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatAuthorCopyWith<$Res> get author {
  
  return $ChatAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
