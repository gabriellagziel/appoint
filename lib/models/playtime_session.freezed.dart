// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playtime_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

PlaytimeSession _$PlaytimeSessionFromJson(Map<String, dynamic> json) {
  return _PlaytimeSession.fromJson(json);
}

/// @nodoc
mixin _$PlaytimeSession {
  String get id => throw _privateConstructorUsedError;
  String get gameId => throw _privateConstructorUsedError;
  List<String> get participants => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  String get mode => throw _privateConstructorUsedError; // virtual/live
  String get backgroundId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String gameId, List<String> participants,
            DateTime scheduledTime, String mode, String backgroundId)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String gameId, List<String> participants,
            DateTime scheduledTime, String mode, String backgroundId)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String gameId, List<String> participants,
            DateTime scheduledTime, String mode, String backgroundId)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaytimeSessionCopyWith<PlaytimeSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaytimeSessionCopyWith<$Res> {
  factory $PlaytimeSessionCopyWith(
          PlaytimeSession value, $Res Function(PlaytimeSession) then) =
      _$PlaytimeSessionCopyWithImpl<$Res, PlaytimeSession>;
  @useResult
  $Res call(
      {String id,
      String gameId,
      List<String> participants,
      DateTime scheduledTime,
      String mode,
      String backgroundId});
}

/// @nodoc
class _$PlaytimeSessionCopyWithImpl<$Res, $Val extends PlaytimeSession>
    implements $PlaytimeSessionCopyWith<$Res> {
  _$PlaytimeSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? participants = null,
    Object? scheduledTime = null,
    Object? mode = null,
    Object? backgroundId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      gameId: null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundId: null == backgroundId
          ? _value.backgroundId
          : backgroundId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaytimeSessionImplCopyWith<$Res>
    implements $PlaytimeSessionCopyWith<$Res> {
  factory _$$PlaytimeSessionImplCopyWith(_$PlaytimeSessionImpl value,
          $Res Function(_$PlaytimeSessionImpl) then) =
      __$$PlaytimeSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String gameId,
      List<String> participants,
      DateTime scheduledTime,
      String mode,
      String backgroundId});
}

/// @nodoc
class __$$PlaytimeSessionImplCopyWithImpl<$Res>
    extends _$PlaytimeSessionCopyWithImpl<$Res, _$PlaytimeSessionImpl>
    implements _$$PlaytimeSessionImplCopyWith<$Res> {
  __$$PlaytimeSessionImplCopyWithImpl(
      _$PlaytimeSessionImpl _value, $Res Function(_$PlaytimeSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? participants = null,
    Object? scheduledTime = null,
    Object? mode = null,
    Object? backgroundId = null,
  }) {
    return _then(_$PlaytimeSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      gameId: null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundId: null == backgroundId
          ? _value.backgroundId
          : backgroundId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaytimeSessionImpl implements _PlaytimeSession {
  const _$PlaytimeSessionImpl(
      {required this.id,
      required this.gameId,
      required final List<String> participants,
      required this.scheduledTime,
      required this.mode,
      required this.backgroundId})
      : _participants = participants;

  factory _$PlaytimeSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaytimeSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String gameId;
  final List<String> _participants;
  @override
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final DateTime scheduledTime;
  @override
  final String mode;
// virtual/live
  @override
  final String backgroundId;

  @override
  String toString() {
    return 'PlaytimeSession(id: $id, gameId: $gameId, participants: $participants, scheduledTime: $scheduledTime, mode: $mode, backgroundId: $backgroundId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaytimeSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.backgroundId, backgroundId) ||
                other.backgroundId == backgroundId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      gameId,
      const DeepCollectionEquality().hash(_participants),
      scheduledTime,
      mode,
      backgroundId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaytimeSessionImplCopyWith<_$PlaytimeSessionImpl> get copyWith =>
      __$$PlaytimeSessionImplCopyWithImpl<_$PlaytimeSessionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String gameId, List<String> participants,
            DateTime scheduledTime, String mode, String backgroundId)
        $default,
  ) {
    return $default(
        id, gameId, participants, scheduledTime, mode, backgroundId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String gameId, List<String> participants,
            DateTime scheduledTime, String mode, String backgroundId)?
        $default,
  ) {
    return $default?.call(
        id, gameId, participants, scheduledTime, mode, backgroundId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String gameId, List<String> participants,
            DateTime scheduledTime, String mode, String backgroundId)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id, gameId, participants, scheduledTime, mode, backgroundId);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaytimeSessionImplToJson(
      this,
    );
  }
}

abstract class _PlaytimeSession implements PlaytimeSession {
  const factory _PlaytimeSession(
      {required final String id,
      required final String gameId,
      required final List<String> participants,
      required final DateTime scheduledTime,
      required final String mode,
      required final String backgroundId}) = _$PlaytimeSessionImpl;

  factory _PlaytimeSession.fromJson(Map<String, dynamic> json) =
      _$PlaytimeSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get gameId;
  @override
  List<String> get participants;
  @override
  DateTime get scheduledTime;
  @override
  String get mode;
  @override // virtual/live
  String get backgroundId;
  @override
  @JsonKey(ignore: true)
  _$$PlaytimeSessionImplCopyWith<_$PlaytimeSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
