// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffAvailabilityImpl _$$StaffAvailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$StaffAvailabilityImpl(
      staffId: json['staff_id'] as String,
      date: const DateTimeConverter().fromJson(json['date'] as String),
      availableSlots: (json['available_slots'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$StaffAvailabilityImplToJson(
    _$StaffAvailabilityImpl instance) {
  final val = <String, dynamic>{
    'staff_id': instance.staffId,
    'date': const DateTimeConverter().toJson(instance.date),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('available_slots', instance.availableSlots);
  return val;
}
