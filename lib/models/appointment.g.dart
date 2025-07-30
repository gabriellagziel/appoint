// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      inviteeId: json['invitee_id'] as String,
      scheduledAt:
          const DateTimeConverter().fromJson(json['scheduled_at'] as String),
      type: $enumDecode(_$AppointmentTypeEnumMap, json['type']),
      callRequestId: json['call_request_id'] as String?,
      status: $enumDecodeNullable(_$InviteStatusEnumMap, json['status']) ??
          InviteStatus.pending,
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'creator_id': instance.creatorId,
    'invitee_id': instance.inviteeId,
    'scheduled_at': const DateTimeConverter().toJson(instance.scheduledAt),
    'type': _$AppointmentTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('call_request_id', instance.callRequestId);
  val['status'] = _$InviteStatusEnumMap[instance.status]!;
  return val;
}

const _$AppointmentTypeEnumMap = {
  AppointmentType.scheduled: 'scheduled',
  AppointmentType.openCall: 'openCall',
};

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
};
