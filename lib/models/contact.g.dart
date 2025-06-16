// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'phone': instance.phone,
      'photoUrl': instance.photoUrl,
    };
