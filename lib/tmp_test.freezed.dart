// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tmp_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

Tmp _$TmpFromJson(Map<String, dynamic> json) {
  return _Tmp.fromJson(json);
}

/// @nodoc
mixin _$Tmp {
  String get id => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TmpCopyWith<Tmp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TmpCopyWith<$Res> {
  factory $TmpCopyWith(Tmp value, $Res Function(Tmp) then) =
      _$TmpCopyWithImpl<$Res, Tmp>;
  @useResult
  $Res call({String id, DateTime time});
}

/// @nodoc
class _$TmpCopyWithImpl<$Res, $Val extends Tmp> implements $TmpCopyWith<$Res> {
  _$TmpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TmpImplCopyWith<$Res> implements $TmpCopyWith<$Res> {
  factory _$$TmpImplCopyWith(_$TmpImpl value, $Res Function(_$TmpImpl) then) =
      __$$TmpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime time});
}

/// @nodoc
class __$$TmpImplCopyWithImpl<$Res> extends _$TmpCopyWithImpl<$Res, _$TmpImpl>
    implements _$$TmpImplCopyWith<$Res> {
  __$$TmpImplCopyWithImpl(_$TmpImpl _value, $Res Function(_$TmpImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? time = null,
  }) {
    return _then(_$TmpImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TmpImpl implements _Tmp {
  const _$TmpImpl({required this.id, required this.time});

  factory _$TmpImpl.fromJson(Map<String, dynamic> json) =>
      _$$TmpImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime time;

  @override
  String toString() {
    return 'Tmp(id: $id, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TmpImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TmpImplCopyWith<_$TmpImpl> get copyWith =>
      __$$TmpImplCopyWithImpl<_$TmpImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TmpImplToJson(
      this,
    );
  }
}

abstract class _Tmp implements Tmp {
  const factory _Tmp({required final String id, required final DateTime time}) =
      _$TmpImpl;

  factory _Tmp.fromJson(Map<String, dynamic> json) = _$TmpImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$TmpImplCopyWith<_$TmpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
