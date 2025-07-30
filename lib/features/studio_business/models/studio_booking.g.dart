// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudioBooking _$StudioBookingFromJson(Map<String, dynamic> json) =>
    StudioBooking(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      staffProfileId: json['staff_profile_id'] as String,
      businessProfileId: json['business_profile_id'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      cost: (json['cost'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StudioBookingToJson(StudioBooking instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'customer_id': instance.customerId,
    'staff_profile_id': instance.staffProfileId,
    'business_profile_id': instance.businessProfileId,
    'date': instance.date.toIso8601String(),
    'start_time': instance.startTime,
    'end_time': instance.endTime,
    'cost': instance.cost,
    'status': instance.status,
    'created_at': instance.createdAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
