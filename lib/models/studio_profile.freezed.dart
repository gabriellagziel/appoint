// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StudioProfile _$StudioProfileFromJson(Map<String, dynamic> json) {
  return _StudioProfile.fromJson(json);
}

/// @nodoc
mixin _$StudioProfile {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool? get isAdminFreeAccess => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String ownerId,
            String? description,
            String? address,
            String? phone,
            String? email,
            String? imageUrl,
            bool? isAdminFreeAccess,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String name,
            String ownerId,
            String? description,
            String? address,
            String? phone,
            String? email,
            String? imageUrl,
            bool? isAdminFreeAccess,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String ownerId,
            String? description,
            String? address,
            String? phone,
            String? email,
            String? imageUrl,
            bool? isAdminFreeAccess,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StudioProfileCopyWith<StudioProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudioProfileCopyWith<$Res> {
  factory $StudioProfileCopyWith(
          StudioProfile value, $Res Function(StudioProfile) then) =
      _$StudioProfileCopyWithImpl<$Res, StudioProfile>;
  @useResult
  $Res call(
      {String id,
      String name,
      String ownerId,
      String? description,
      String? address,
      String? phone,
      String? email,
      String? imageUrl,
      bool? isAdminFreeAccess,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$StudioProfileCopyWithImpl<$Res, $Val extends StudioProfile>
    implements $StudioProfileCopyWith<$Res> {
  _$StudioProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? imageUrl = freezed,
    Object? isAdminFreeAccess = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdminFreeAccess: freezed == isAdminFreeAccess
          ? _value.isAdminFreeAccess
          : isAdminFreeAccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudioProfileImplCopyWith<$Res>
    implements $StudioProfileCopyWith<$Res> {
  factory _$$StudioProfileImplCopyWith(
          _$StudioProfileImpl value, $Res Function(_$StudioProfileImpl) then) =
      __$$StudioProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String ownerId,
      String? description,
      String? address,
      String? phone,
      String? email,
      String? imageUrl,
      bool? isAdminFreeAccess,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$StudioProfileImplCopyWithImpl<$Res>
    extends _$StudioProfileCopyWithImpl<$Res, _$StudioProfileImpl>
    implements _$$StudioProfileImplCopyWith<$Res> {
  __$$StudioProfileImplCopyWithImpl(
      _$StudioProfileImpl _value, $Res Function(_$StudioProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? imageUrl = freezed,
    Object? isAdminFreeAccess = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StudioProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdminFreeAccess: freezed == isAdminFreeAccess
          ? _value.isAdminFreeAccess
          : isAdminFreeAccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudioProfileImpl implements _StudioProfile {
  const _$StudioProfileImpl(
      {required this.id,
      required this.name,
      required this.ownerId,
      this.description,
      this.address,
      this.phone,
      this.email,
      this.imageUrl,
      this.isAdminFreeAccess,
      this.createdAt,
      this.updatedAt});

  factory _$StudioProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudioProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String ownerId;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? imageUrl;
  @override
  final bool? isAdminFreeAccess;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StudioProfile(id: $id, name: $name, ownerId: $ownerId, description: $description, address: $address, phone: $phone, email: $email, imageUrl: $imageUrl, isAdminFreeAccess: $isAdminFreeAccess, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudioProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAdminFreeAccess, isAdminFreeAccess) ||
                other.isAdminFreeAccess == isAdminFreeAccess) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, ownerId, description,
      address, phone, email, imageUrl, isAdminFreeAccess, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StudioProfileImplCopyWith<_$StudioProfileImpl> get copyWith =>
      __$$StudioProfileImplCopyWithImpl<_$StudioProfileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String ownerId,
            String? description,
            String? address,
            String? phone,
            String? email,
            String? imageUrl,
            bool? isAdminFreeAccess,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    return $default(id, name, ownerId, description, address, phone, email,
        imageUrl, isAdminFreeAccess, createdAt, updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String name,
            String ownerId,
            String? description,
            String? address,
            String? phone,
            String? email,
            String? imageUrl,
            bool? isAdminFreeAccess,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    return $default?.call(id, name, ownerId, description, address, phone, email,
        imageUrl, isAdminFreeAccess, createdAt, updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String ownerId,
            String? description,
            String? address,
            String? phone,
            String? email,
            String? imageUrl,
            bool? isAdminFreeAccess,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, name, ownerId, description, address, phone, email,
          imageUrl, isAdminFreeAccess, createdAt, updatedAt);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StudioProfileImplToJson(
      this,
    );
  }
}

abstract class _StudioProfile implements StudioProfile {
  const factory _StudioProfile(
      {required final String id,
      required final String name,
      required final String ownerId,
      final String? description,
      final String? address,
      final String? phone,
      final String? email,
      final String? imageUrl,
      final bool? isAdminFreeAccess,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$StudioProfileImpl;

  factory _StudioProfile.fromJson(Map<String, dynamic> json) =
      _$StudioProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get ownerId;
  @override
  String? get description;
  @override
  String? get address;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get imageUrl;
  @override
  bool? get isAdminFreeAccess;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$StudioProfileImplCopyWith<_$StudioProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
