// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      inviteeId: json['inviteeId'] as String,
      scheduledAt:
          const DateTimeConverter().fromJson(json['scheduledAt'] as String),
      type: AppointmentType.values.byName(json['type'] as String),
      callRequestId: json['callRequestId'] as String?,
      inviteeContact: json['inviteeContact'] == null
          ? null
          : Contact.fromJson(json['inviteeContact'] as Map<String, dynamic>),
      status: InviteStatus.values.byName(json['status'] as String),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'inviteeId': instance.inviteeId,
      'scheduledAt': const DateTimeConverter().toJson(instance.scheduledAt),
      'type': instance.type.name,
      'callRequestId': instance.callRequestId,
      'inviteeContact': instance.inviteeContact?.toJson(),
      'status': instance.status.name,
    };
