// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      inviteeId: json['inviteeId'] as String,
      scheduledAt:
          const DateTimeConverter().fromJson(json['scheduledAt'] as String),
      type: $enumDecode(_$AppointmentTypeEnumMap, json['type']),
      callRequestId: json['callRequestId'] as String?,
      inviteeContact: json['inviteeContact'] == null
          ? null
          : Contact.fromJson(json['inviteeContact'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$InviteStatusEnumMap, json['status']) ??
          InviteStatus.pending,
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'inviteeId': instance.inviteeId,
      'scheduledAt': const DateTimeConverter().toJson(instance.scheduledAt),
      'type': _$AppointmentTypeEnumMap[instance.type]!,
      'callRequestId': instance.callRequestId,
      'inviteeContact': instance.inviteeContact?.toJson(),
      'status': _$InviteStatusEnumMap[instance.status]!,
    };

const _$AppointmentTypeEnumMap = {
  AppointmentType.scheduled: 'scheduled',
  AppointmentType.openCall: 'openCall',
};

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
};
