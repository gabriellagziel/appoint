// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'display_name': instance.displayName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('phone_number', instance.phoneNumber);
  writeNotNull('email', instance.email);
  writeNotNull('location', instance.location);
  return val;
}
