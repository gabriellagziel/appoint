// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'display_name': instance.displayName,
      'role': instance.role,
    };
