// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      dateTime: const DateTimeConverter().fromJson(json['dateTime'] as String),
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'dateTime': const DateTimeConverter().toJson(instance.dateTime),
      'notes': instance.notes,
    };
