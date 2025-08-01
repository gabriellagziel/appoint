// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playtime_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaytimeGame _$PlaytimeGameFromJson(Map<String, dynamic> json) {
  return _PlaytimeGame.fromJson(json);
}

/// @nodoc
mixin _$PlaytimeGame {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, approved, rejected
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String name, String createdBy, String status,
            DateTime? createdAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String name, String createdBy, String status,
            DateTime? createdAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String name, String createdBy, String status,
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaytimeGameCopyWith<PlaytimeGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaytimeGameCopyWith<$Res> {
  factory $PlaytimeGameCopyWith(
          PlaytimeGame value, $Res Function(PlaytimeGame) then) =
      _$PlaytimeGameCopyWithImpl<$Res, PlaytimeGame>;
  @useResult
  $Res call(
      {String id,
      String name,
      String createdBy,
      String status,
      DateTime? createdAt});
}

/// @nodoc
class _$PlaytimeGameCopyWithImpl<$Res, $Val extends PlaytimeGame>
    implements $PlaytimeGameCopyWith<$Res> {
  _$PlaytimeGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdBy = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaytimeGameImplCopyWith<$Res>
    implements $PlaytimeGameCopyWith<$Res> {
  factory _$$PlaytimeGameImplCopyWith(
          _$PlaytimeGameImpl value, $Res Function(_$PlaytimeGameImpl) then) =
      __$$PlaytimeGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String createdBy,
      String status,
      DateTime? createdAt});
}

/// @nodoc
class __$$PlaytimeGameImplCopyWithImpl<$Res>
    extends _$PlaytimeGameCopyWithImpl<$Res, _$PlaytimeGameImpl>
    implements _$$PlaytimeGameImplCopyWith<$Res> {
  __$$PlaytimeGameImplCopyWithImpl(
      _$PlaytimeGameImpl _value, $Res Function(_$PlaytimeGameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdBy = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$PlaytimeGameImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaytimeGameImpl implements _PlaytimeGame {
  const _$PlaytimeGameImpl(
      {required this.id,
      required this.name,
      required this.createdBy,
      required this.status,
      this.createdAt});

  factory _$PlaytimeGameImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaytimeGameImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String createdBy;
  @override
  final String status;
// pending, approved, rejected
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PlaytimeGame(id: $id, name: $name, createdBy: $createdBy, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaytimeGameImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, createdBy, status, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaytimeGameImplCopyWith<_$PlaytimeGameImpl> get copyWith =>
      __$$PlaytimeGameImplCopyWithImpl<_$PlaytimeGameImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String name, String createdBy, String status,
            DateTime? createdAt)
        $default,
  ) {
    return $default(id, name, createdBy, status, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String name, String createdBy, String status,
            DateTime? createdAt)?
        $default,
  ) {
    return $default?.call(id, name, createdBy, status, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String name, String createdBy, String status,
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, name, createdBy, status, createdAt);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaytimeGameImplToJson(
      this,
    );
  }
}

abstract class _PlaytimeGame implements PlaytimeGame {
  const factory _PlaytimeGame(
      {required final String id,
      required final String name,
      required final String createdBy,
      required final String status,
      final DateTime? createdAt}) = _$PlaytimeGameImpl;

  factory _PlaytimeGame.fromJson(Map<String, dynamic> json) =
      _$PlaytimeGameImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get createdBy;
  @override
  String get status;
  @override // pending, approved, rejected
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PlaytimeGameImplCopyWith<_$PlaytimeGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
