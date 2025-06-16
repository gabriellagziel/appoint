// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tmp_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tmp _$TmpFromJson(Map<String, dynamic> json) {
  return _Tmp.fromJson(json);
}

/// @nodoc
mixin _$Tmp {
  String get id => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get time => throw _privateConstructorUsedError;

  /// Serializes this Tmp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tmp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TmpCopyWith<Tmp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TmpCopyWith<$Res> {
  factory $TmpCopyWith(Tmp value, $Res Function(Tmp) then) =
      _$TmpCopyWithImpl<$Res, Tmp>;
  @useResult
  $Res call({String id, @DateTimeConverter() DateTime time});
}

/// @nodoc
class _$TmpCopyWithImpl<$Res, $Val extends Tmp> implements $TmpCopyWith<$Res> {
  _$TmpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tmp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? time = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      time: freezed == time
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
  $Res call({String id, @DateTimeConverter() DateTime time});
}

/// @nodoc
class __$$TmpImplCopyWithImpl<$Res> extends _$TmpCopyWithImpl<$Res, _$TmpImpl>
    implements _$$TmpImplCopyWith<$Res> {
  __$$TmpImplCopyWithImpl(_$TmpImpl _value, $Res Function(_$TmpImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tmp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? time = freezed,
  }) {
    return _then(_$TmpImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TmpImpl implements _Tmp {
  _$TmpImpl({required this.id, @DateTimeConverter() required this.time});

  factory _$TmpImpl.fromJson(Map<String, dynamic> json) =>
      _$$TmpImplFromJson(json);

  @override
  final String id;
  @override
  @DateTimeConverter()
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
            const DeepCollectionEquality().equals(other.time, time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, const DeepCollectionEquality().hash(time));

  /// Create a copy of Tmp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
  factory _Tmp(
      {required final String id,
      @DateTimeConverter() required final DateTime time}) = _$TmpImpl;

  factory _Tmp.fromJson(Map<String, dynamic> json) = _$TmpImpl.fromJson;

  @override
  String get id;
  @override
  @DateTimeConverter()
  DateTime get time;

  /// Create a copy of Tmp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TmpImplCopyWith<_$TmpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
