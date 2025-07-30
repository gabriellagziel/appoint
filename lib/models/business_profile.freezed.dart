// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) {
  return _BusinessProfile.fromJson(json);
}

/// @nodoc
mixin _$BusinessProfile {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name, String description, String phone) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name, String description, String phone)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name, String description, String phone)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessProfileCopyWith<BusinessProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessProfileCopyWith<$Res> {
  factory $BusinessProfileCopyWith(
          BusinessProfile value, $Res Function(BusinessProfile) then) =
      _$BusinessProfileCopyWithImpl<$Res, BusinessProfile>;
  @useResult
  $Res call({String name, String description, String phone});
}

/// @nodoc
class _$BusinessProfileCopyWithImpl<$Res, $Val extends BusinessProfile>
    implements $BusinessProfileCopyWith<$Res> {
  _$BusinessProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? phone = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessProfileImplCopyWith<$Res>
    implements $BusinessProfileCopyWith<$Res> {
  factory _$$BusinessProfileImplCopyWith(_$BusinessProfileImpl value,
          $Res Function(_$BusinessProfileImpl) then) =
      __$$BusinessProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String description, String phone});
}

/// @nodoc
class __$$BusinessProfileImplCopyWithImpl<$Res>
    extends _$BusinessProfileCopyWithImpl<$Res, _$BusinessProfileImpl>
    implements _$$BusinessProfileImplCopyWith<$Res> {
  __$$BusinessProfileImplCopyWithImpl(
      _$BusinessProfileImpl _value, $Res Function(_$BusinessProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? phone = null,
  }) {
    return _then(_$BusinessProfileImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessProfileImpl implements _BusinessProfile {
  const _$BusinessProfileImpl(
      {required this.name, required this.description, required this.phone});

  factory _$BusinessProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessProfileImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final String phone;

  @override
  String toString() {
    return 'BusinessProfile(name: $name, description: $description, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessProfileImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      __$$BusinessProfileImplCopyWithImpl<_$BusinessProfileImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name, String description, String phone) $default,
  ) {
    return $default(name, description, phone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name, String description, String phone)? $default,
  ) {
    return $default?.call(name, description, phone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name, String description, String phone)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(name, description, phone);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessProfileImplToJson(
      this,
    );
  }
}

abstract class _BusinessProfile implements BusinessProfile {
  const factory _BusinessProfile(
      {required final String name,
      required final String description,
      required final String phone}) = _$BusinessProfileImpl;

  factory _BusinessProfile.fromJson(Map<String, dynamic> json) =
      _$BusinessProfileImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  String get phone;
  @override
  @JsonKey(ignore: true)
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
