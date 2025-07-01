// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudioBooking _$StudioBookingFromJson(Map<String, dynamic> json) =>
    StudioBooking(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      staffProfileId: json['staffProfileId'] as String,
      businessProfileId: json['businessProfileId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      cost: (json['cost'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudioBookingToJson(StudioBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'staffProfileId': instance.staffProfileId,
      'businessProfileId': instance.businessProfileId,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'cost': instance.cost,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
