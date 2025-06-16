// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffMember _$StaffMemberFromJson(Map<String, dynamic> json) {
  return _StaffMember.fromJson(json);
}

/// @nodoc
mixin _$StaffMember {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;

  /// Serializes this StaffMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffMemberCopyWith<StaffMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffMemberCopyWith<$Res> {
  factory $StaffMemberCopyWith(
          StaffMember value, $Res Function(StaffMember) then) =
      _$StaffMemberCopyWithImpl<$Res, StaffMember>;
  @useResult
  $Res call({String id, String displayName, String? photoUrl});
}

/// @nodoc
class _$StaffMemberCopyWithImpl<$Res, $Val extends StaffMember>
    implements $StaffMemberCopyWith<$Res> {
  _$StaffMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffMemberImplCopyWith<$Res>
    implements $StaffMemberCopyWith<$Res> {
  factory _$$StaffMemberImplCopyWith(
          _$StaffMemberImpl value, $Res Function(_$StaffMemberImpl) then) =
      __$$StaffMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String displayName, String? photoUrl});
}

/// @nodoc
class __$$StaffMemberImplCopyWithImpl<$Res>
    extends _$StaffMemberCopyWithImpl<$Res, _$StaffMemberImpl>
    implements _$$StaffMemberImplCopyWith<$Res> {
  __$$StaffMemberImplCopyWithImpl(
      _$StaffMemberImpl _value, $Res Function(_$StaffMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
  }) {
    return _then(_$StaffMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffMemberImpl implements _StaffMember {
  const _$StaffMemberImpl(
      {required this.id, required this.displayName, this.photoUrl});

  factory _$StaffMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? photoUrl;

  @override
  String toString() {
    return 'StaffMember(id: $id, displayName: $displayName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, photoUrl);

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffMemberImplCopyWith<_$StaffMemberImpl> get copyWith =>
      __$$StaffMemberImplCopyWithImpl<_$StaffMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffMemberImplToJson(
      this,
    );
  }
}

abstract class _StaffMember implements StaffMember {
  const factory _StaffMember(
      {required final String id,
      required final String displayName,
      final String? photoUrl}) = _$StaffMemberImpl;

  factory _StaffMember.fromJson(Map<String, dynamic> json) =
      _$StaffMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get photoUrl;

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffMemberImplCopyWith<_$StaffMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
