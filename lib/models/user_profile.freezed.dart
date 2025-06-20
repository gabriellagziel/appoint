// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  bool? get isAdminFreeAccess =>
      throw _privateConstructorUsedError; // Playtime-specific fields
  PlaytimeSettings? get playtimeSettings => throw _privateConstructorUsedError;
  PlaytimePermissions? get playtimePermissions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? email,
      String? phone,
      String? photoUrl,
      bool? isAdminFreeAccess,
      PlaytimeSettings? playtimeSettings,
      PlaytimePermissions? playtimePermissions});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? isAdminFreeAccess = freezed,
    Object? playtimeSettings = freezed,
    Object? playtimePermissions = freezed,
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
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdminFreeAccess: freezed == isAdminFreeAccess
          ? _value.isAdminFreeAccess
          : isAdminFreeAccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      playtimeSettings: freezed == playtimeSettings
          ? _value.playtimeSettings
          : playtimeSettings // ignore: cast_nullable_to_non_nullable
              as PlaytimeSettings?,
      playtimePermissions: freezed == playtimePermissions
          ? _value.playtimePermissions
          : playtimePermissions // ignore: cast_nullable_to_non_nullable
              as PlaytimePermissions?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? email,
      String? phone,
      String? photoUrl,
      bool? isAdminFreeAccess,
      PlaytimeSettings? playtimeSettings,
      PlaytimePermissions? playtimePermissions});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? isAdminFreeAccess = freezed,
    Object? playtimeSettings = freezed,
    Object? playtimePermissions = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdminFreeAccess: freezed == isAdminFreeAccess
          ? _value.isAdminFreeAccess
          : isAdminFreeAccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      playtimeSettings: freezed == playtimeSettings
          ? _value.playtimeSettings
          : playtimeSettings // ignore: cast_nullable_to_non_nullable
              as PlaytimeSettings?,
      playtimePermissions: freezed == playtimePermissions
          ? _value.playtimePermissions
          : playtimePermissions // ignore: cast_nullable_to_non_nullable
              as PlaytimePermissions?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.name,
      this.email,
      this.phone,
      this.photoUrl,
      this.isAdminFreeAccess,
      this.playtimeSettings,
      this.playtimePermissions});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? photoUrl;
  @override
  final bool? isAdminFreeAccess;
// Playtime-specific fields
  @override
  final PlaytimeSettings? playtimeSettings;
  @override
  final PlaytimePermissions? playtimePermissions;

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, phone: $phone, photoUrl: $photoUrl, isAdminFreeAccess: $isAdminFreeAccess, playtimeSettings: $playtimeSettings, playtimePermissions: $playtimePermissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.isAdminFreeAccess, isAdminFreeAccess) ||
                other.isAdminFreeAccess == isAdminFreeAccess) &&
            (identical(other.playtimeSettings, playtimeSettings) ||
                other.playtimeSettings == playtimeSettings) &&
            (identical(other.playtimePermissions, playtimePermissions) ||
                other.playtimePermissions == playtimePermissions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, phone, photoUrl,
      isAdminFreeAccess, playtimeSettings, playtimePermissions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String name,
      final String? email,
      final String? phone,
      final String? photoUrl,
      final bool? isAdminFreeAccess,
      final PlaytimeSettings? playtimeSettings,
      final PlaytimePermissions? playtimePermissions}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get photoUrl;
  @override
  bool? get isAdminFreeAccess;
  @override // Playtime-specific fields
  PlaytimeSettings? get playtimeSettings;
  @override
  PlaytimePermissions? get playtimePermissions;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
