// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enhanced_chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EnhancedChatMessage _$EnhancedChatMessageFromJson(Map<String, dynamic> json) {
  return _EnhancedChatMessage.fromJson(json);
}

/// @nodoc
mixin _$EnhancedChatMessage {
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
  $EnhancedChatMessageCopyWith<EnhancedChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnhancedChatMessageCopyWith<$Res> {
  factory $EnhancedChatMessageCopyWith(
          EnhancedChatMessage value, $Res Function(EnhancedChatMessage) then) =
      _$EnhancedChatMessageCopyWithImpl<$Res, EnhancedChatMessage>;
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
class _$EnhancedChatMessageCopyWithImpl<$Res, $Val extends EnhancedChatMessage>
    implements $EnhancedChatMessageCopyWith<$Res> {
  _$EnhancedChatMessageCopyWithImpl(this._value, this._then);

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
abstract class _$$EnhancedChatMessageImplCopyWith<$Res>
    implements $EnhancedChatMessageCopyWith<$Res> {
  factory _$$EnhancedChatMessageImplCopyWith(_$EnhancedChatMessageImpl value,
          $Res Function(_$EnhancedChatMessageImpl) then) =
      __$$EnhancedChatMessageImplCopyWithImpl<$Res>;
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
class __$$EnhancedChatMessageImplCopyWithImpl<$Res>
    extends _$EnhancedChatMessageCopyWithImpl<$Res, _$EnhancedChatMessageImpl>
    implements _$$EnhancedChatMessageImplCopyWith<$Res> {
  __$$EnhancedChatMessageImplCopyWithImpl(_$EnhancedChatMessageImpl _value,
      $Res Function(_$EnhancedChatMessageImpl) _then)
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
    return _then(_$EnhancedChatMessageImpl(
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
class _$EnhancedChatMessageImpl implements _EnhancedChatMessage {
  const _$EnhancedChatMessageImpl(
      {required this.id,
      required this.senderId,
      required this.content,
      required this.timestamp,
      final List<String> readBy = const [],
      this.isTyping = false})
      : _readBy = readBy;

  factory _$EnhancedChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnhancedChatMessageImplFromJson(json);

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
    return 'EnhancedChatMessage(id: $id, senderId: $senderId, content: $content, timestamp: $timestamp, readBy: $readBy, isTyping: $isTyping)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnhancedChatMessageImpl &&
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
  _$$EnhancedChatMessageImplCopyWith<_$EnhancedChatMessageImpl> get copyWith =>
      __$$EnhancedChatMessageImplCopyWithImpl<_$EnhancedChatMessageImpl>(
          this, _$identity);

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
    return _$$EnhancedChatMessageImplToJson(
      this,
    );
  }
}

abstract class _EnhancedChatMessage implements EnhancedChatMessage {
  const factory _EnhancedChatMessage(
      {required final String id,
      required final String senderId,
      required final String content,
      required final DateTime timestamp,
      final List<String> readBy,
      final bool isTyping}) = _$EnhancedChatMessageImpl;

  factory _EnhancedChatMessage.fromJson(Map<String, dynamic> json) =
      _$EnhancedChatMessageImpl.fromJson;

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
  _$$EnhancedChatMessageImplCopyWith<_$EnhancedChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
