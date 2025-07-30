// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      role: json['role'] as String,
      email: json['email'] as String?,
      displayName: json['display_name'] as String?,
      photoURL: json['photo_u_r_l'] as String?,
      studioId: json['studio_id'] as String?,
      businessProfileId: json['business_profile_id'] as String?,
      emailVerified: json['email_verified'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
      customClaims: json['custom_claims'] as Map<String, dynamic>?,
      firebaseUser: const UserConverter()
          .fromJson(json['firebase_user'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'role': instance.role,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('display_name', instance.displayName);
  writeNotNull('photo_u_r_l', instance.photoURL);
  writeNotNull('studio_id', instance.studioId);
  writeNotNull('business_profile_id', instance.businessProfileId);
  writeNotNull('email_verified', instance.emailVerified);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('last_login_at', instance.lastLoginAt?.toIso8601String());
  writeNotNull('custom_claims', instance.customClaims);
  writeNotNull(
      'firebase_user', const UserConverter().toJson(instance.firebaseUser));
  return val;
}
