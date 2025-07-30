// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playtime_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaytimeChat _$PlaytimeChatFromJson(Map<String, dynamic> json) {
  return _PlaytimeChat.fromJson(json);
}

/// @nodoc
mixin _$PlaytimeChat {
  String get sessionId => throw _privateConstructorUsedError;
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String sessionId, List<ChatMessage> messages) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String sessionId, List<ChatMessage> messages)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String sessionId, List<ChatMessage> messages)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaytimeChatCopyWith<PlaytimeChat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaytimeChatCopyWith<$Res> {
  factory $PlaytimeChatCopyWith(
          PlaytimeChat value, $Res Function(PlaytimeChat) then) =
      _$PlaytimeChatCopyWithImpl<$Res, PlaytimeChat>;
  @useResult
  $Res call({String sessionId, List<ChatMessage> messages});
}

/// @nodoc
class _$PlaytimeChatCopyWithImpl<$Res, $Val extends PlaytimeChat>
    implements $PlaytimeChatCopyWith<$Res> {
  _$PlaytimeChatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaytimeChatImplCopyWith<$Res>
    implements $PlaytimeChatCopyWith<$Res> {
  factory _$$PlaytimeChatImplCopyWith(
          _$PlaytimeChatImpl value, $Res Function(_$PlaytimeChatImpl) then) =
      __$$PlaytimeChatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sessionId, List<ChatMessage> messages});
}

/// @nodoc
class __$$PlaytimeChatImplCopyWithImpl<$Res>
    extends _$PlaytimeChatCopyWithImpl<$Res, _$PlaytimeChatImpl>
    implements _$$PlaytimeChatImplCopyWith<$Res> {
  __$$PlaytimeChatImplCopyWithImpl(
      _$PlaytimeChatImpl _value, $Res Function(_$PlaytimeChatImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? messages = null,
  }) {
    return _then(_$PlaytimeChatImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaytimeChatImpl implements _PlaytimeChat {
  const _$PlaytimeChatImpl(
      {required this.sessionId, required final List<ChatMessage> messages})
      : _messages = messages;

  factory _$PlaytimeChatImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaytimeChatImplFromJson(json);

  @override
  final String sessionId;
  final List<ChatMessage> _messages;
  @override
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'PlaytimeChat(sessionId: $sessionId, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaytimeChatImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, sessionId, const DeepCollectionEquality().hash(_messages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaytimeChatImplCopyWith<_$PlaytimeChatImpl> get copyWith =>
      __$$PlaytimeChatImplCopyWithImpl<_$PlaytimeChatImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String sessionId, List<ChatMessage> messages) $default,
  ) {
    return $default(sessionId, messages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String sessionId, List<ChatMessage> messages)? $default,
  ) {
    return $default?.call(sessionId, messages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String sessionId, List<ChatMessage> messages)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(sessionId, messages);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaytimeChatImplToJson(
      this,
    );
  }
}

abstract class _PlaytimeChat implements PlaytimeChat {
  const factory _PlaytimeChat(
      {required final String sessionId,
      required final List<ChatMessage> messages}) = _$PlaytimeChatImpl;

  factory _PlaytimeChat.fromJson(Map<String, dynamic> json) =
      _$PlaytimeChatImpl.fromJson;

  @override
  String get sessionId;
  @override
  List<ChatMessage> get messages;
  @override
  @JsonKey(ignore: true)
  _$$PlaytimeChatImplCopyWith<_$PlaytimeChatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<String> get readBy => throw _privateConstructorUsedError;
  bool get isTyping => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String senderId, String content,
            DateTime timestamp, List<String> readBy, bool isTyping)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String senderId, String content,
            DateTime timestamp, List<String> readBy, bool isTyping)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String senderId, String content,
            DateTime timestamp, List<String> readBy, bool isTyping)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String content,
      DateTime timestamp,
      List<String> readBy,
      bool isTyping});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? content = null,
    Object? timestamp = null,
    Object? readBy = null,
    Object? isTyping = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readBy: null == readBy
          ? _value.readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTyping: null == isTyping
          ? _value.isTyping
          : isTyping // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String content,
      DateTime timestamp,
      List<String> readBy,
      bool isTyping});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? content = null,
    Object? timestamp = null,
    Object? readBy = null,
    Object? isTyping = null,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readBy: null == readBy
          ? _value._readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTyping: null == isTyping
          ? _value.isTyping
          : isTyping // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.senderId,
      required this.content,
      required this.timestamp,
      final List<String> readBy = const [],
      this.isTyping = false})
      : _readBy = readBy;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String content;
  @override
  final DateTime timestamp;
  final List<String> _readBy;
  @override
  @JsonKey()
  List<String> get readBy {
    if (_readBy is EqualUnmodifiableListView) return _readBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readBy);
  }

  @override
  @JsonKey()
  final bool isTyping;

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, content: $content, timestamp: $timestamp, readBy: $readBy, isTyping: $isTyping)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._readBy, _readBy) &&
            (identical(other.isTyping, isTyping) ||
                other.isTyping == isTyping));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderId, content, timestamp,
      const DeepCollectionEquality().hash(_readBy), isTyping);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String senderId, String content,
            DateTime timestamp, List<String> readBy, bool isTyping)
        $default,
  ) {
    return $default(id, senderId, content, timestamp, readBy, isTyping);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String senderId, String content,
            DateTime timestamp, List<String> readBy, bool isTyping)?
        $default,
  ) {
    return $default?.call(id, senderId, content, timestamp, readBy, isTyping);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String senderId, String content,
            DateTime timestamp, List<String> readBy, bool isTyping)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, senderId, content, timestamp, readBy, isTyping);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String senderId,
      required final String content,
      required final DateTime timestamp,
      final List<String> readBy,
      final bool isTyping}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  List<String> get readBy;
  @override
  bool get isTyping;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
