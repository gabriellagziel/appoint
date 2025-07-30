// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoURL => throw _privateConstructorUsedError;
  String? get studioId => throw _privateConstructorUsedError;
  String? get businessProfileId => throw _privateConstructorUsedError;
  bool? get emailVerified => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get customClaims => throw _privateConstructorUsedError;
  @UserConverter()
  User? get firebaseUser => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String uid,
            String role,
            String? email,
            String? displayName,
            String? photoURL,
            String? studioId,
            String? businessProfileId,
            bool? emailVerified,
            DateTime? createdAt,
            DateTime? lastLoginAt,
            Map<String, dynamic>? customClaims,
            @UserConverter() User? firebaseUser)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String uid,
            String role,
            String? email,
            String? displayName,
            String? photoURL,
            String? studioId,
            String? businessProfileId,
            bool? emailVerified,
            DateTime? createdAt,
            DateTime? lastLoginAt,
            Map<String, dynamic>? customClaims,
            @UserConverter() User? firebaseUser)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String uid,
            String role,
            String? email,
            String? displayName,
            String? photoURL,
            String? studioId,
            String? businessProfileId,
            bool? emailVerified,
            DateTime? createdAt,
            DateTime? lastLoginAt,
            Map<String, dynamic>? customClaims,
            @UserConverter() User? firebaseUser)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call(
      {String uid,
      String role,
      String? email,
      String? displayName,
      String? photoURL,
      String? studioId,
      String? businessProfileId,
      bool? emailVerified,
      DateTime? createdAt,
      DateTime? lastLoginAt,
      Map<String, dynamic>? customClaims,
      @UserConverter() User? firebaseUser});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? role = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? photoURL = freezed,
    Object? studioId = freezed,
    Object? businessProfileId = freezed,
    Object? emailVerified = freezed,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
    Object? customClaims = freezed,
    Object? firebaseUser = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      studioId: freezed == studioId
          ? _value.studioId
          : studioId // ignore: cast_nullable_to_non_nullable
              as String?,
      businessProfileId: freezed == businessProfileId
          ? _value.businessProfileId
          : businessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customClaims: freezed == customClaims
          ? _value.customClaims
          : customClaims // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      firebaseUser: freezed == firebaseUser
          ? _value.firebaseUser
          : firebaseUser // ignore: cast_nullable_to_non_nullable
              as User?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
          _$AppUserImpl value, $Res Function(_$AppUserImpl) then) =
      __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String role,
      String? email,
      String? displayName,
      String? photoURL,
      String? studioId,
      String? businessProfileId,
      bool? emailVerified,
      DateTime? createdAt,
      DateTime? lastLoginAt,
      Map<String, dynamic>? customClaims,
      @UserConverter() User? firebaseUser});
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
      _$AppUserImpl _value, $Res Function(_$AppUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? role = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? photoURL = freezed,
    Object? studioId = freezed,
    Object? businessProfileId = freezed,
    Object? emailVerified = freezed,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
    Object? customClaims = freezed,
    Object? firebaseUser = freezed,
  }) {
    return _then(_$AppUserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      studioId: freezed == studioId
          ? _value.studioId
          : studioId // ignore: cast_nullable_to_non_nullable
              as String?,
      businessProfileId: freezed == businessProfileId
          ? _value.businessProfileId
          : businessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customClaims: freezed == customClaims
          ? _value._customClaims
          : customClaims // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      firebaseUser: freezed == firebaseUser
          ? _value.firebaseUser
          : firebaseUser // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl(
      {required this.uid,
      required this.role,
      this.email,
      this.displayName,
      this.photoURL,
      this.studioId,
      this.businessProfileId,
      this.emailVerified,
      this.createdAt,
      this.lastLoginAt,
      final Map<String, dynamic>? customClaims,
      @UserConverter() this.firebaseUser})
      : _customClaims = customClaims;

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  final String role;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL;
  @override
  final String? studioId;
  @override
  final String? businessProfileId;
  @override
  final bool? emailVerified;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? _customClaims;
  @override
  Map<String, dynamic>? get customClaims {
    final value = _customClaims;
    if (value == null) return null;
    if (_customClaims is EqualUnmodifiableMapView) return _customClaims;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @UserConverter()
  final User? firebaseUser;

  @override
  String toString() {
    return 'AppUser(uid: $uid, role: $role, email: $email, displayName: $displayName, photoURL: $photoURL, studioId: $studioId, businessProfileId: $businessProfileId, emailVerified: $emailVerified, createdAt: $createdAt, lastLoginAt: $lastLoginAt, customClaims: $customClaims, firebaseUser: $firebaseUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.studioId, studioId) ||
                other.studioId == studioId) &&
            (identical(other.businessProfileId, businessProfileId) ||
                other.businessProfileId == businessProfileId) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            const DeepCollectionEquality()
                .equals(other._customClaims, _customClaims) &&
            (identical(other.firebaseUser, firebaseUser) ||
                other.firebaseUser == firebaseUser));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      role,
      email,
      displayName,
      photoURL,
      studioId,
      businessProfileId,
      emailVerified,
      createdAt,
      lastLoginAt,
      const DeepCollectionEquality().hash(_customClaims),
      firebaseUser);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String uid,
            String role,
            String? email,
            String? displayName,
            String? photoURL,
            String? studioId,
            String? businessProfileId,
            bool? emailVerified,
            DateTime? createdAt,
            DateTime? lastLoginAt,
            Map<String, dynamic>? customClaims,
            @UserConverter() User? firebaseUser)
        $default,
  ) {
    return $default(
        uid,
        role,
        email,
        displayName,
        photoURL,
        studioId,
        businessProfileId,
        emailVerified,
        createdAt,
        lastLoginAt,
        customClaims,
        firebaseUser);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String uid,
            String role,
            String? email,
            String? displayName,
            String? photoURL,
            String? studioId,
            String? businessProfileId,
            bool? emailVerified,
            DateTime? createdAt,
            DateTime? lastLoginAt,
            Map<String, dynamic>? customClaims,
            @UserConverter() User? firebaseUser)?
        $default,
  ) {
    return $default?.call(
        uid,
        role,
        email,
        displayName,
        photoURL,
        studioId,
        businessProfileId,
        emailVerified,
        createdAt,
        lastLoginAt,
        customClaims,
        firebaseUser);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String uid,
            String role,
            String? email,
            String? displayName,
            String? photoURL,
            String? studioId,
            String? businessProfileId,
            bool? emailVerified,
            DateTime? createdAt,
            DateTime? lastLoginAt,
            Map<String, dynamic>? customClaims,
            @UserConverter() User? firebaseUser)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          uid,
          role,
          email,
          displayName,
          photoURL,
          studioId,
          businessProfileId,
          emailVerified,
          createdAt,
          lastLoginAt,
          customClaims,
          firebaseUser);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(
      this,
    );
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser(
      {required final String uid,
      required final String role,
      final String? email,
      final String? displayName,
      final String? photoURL,
      final String? studioId,
      final String? businessProfileId,
      final bool? emailVerified,
      final DateTime? createdAt,
      final DateTime? lastLoginAt,
      final Map<String, dynamic>? customClaims,
      @UserConverter() final User? firebaseUser}) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  String get role;
  @override
  String? get email;
  @override
  String? get displayName;
  @override
  String? get photoURL;
  @override
  String? get studioId;
  @override
  String? get businessProfileId;
  @override
  bool? get emailVerified;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastLoginAt;
  @override
  Map<String, dynamic>? get customClaims;
  @override
  @UserConverter()
  User? get firebaseUser;
  @override
  @JsonKey(ignore: true)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
