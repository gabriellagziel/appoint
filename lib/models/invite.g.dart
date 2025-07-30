// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
      id: json['id'] as String,
      appointmentId: json['appointment_id'] as String,
      inviteeId: json['invitee_id'] as String,
      status: $enumDecode(_$InviteStatusEnumMap, json['status']),
      requiresInstallFallback: json['requires_install_fallback'] as bool,
    );

Map<String, dynamic> _$InviteToJson(Invite instance) => <String, dynamic>{
      'id': instance.id,
      'appointment_id': instance.appointmentId,
      'invitee_id': instance.inviteeId,
      'status': _$InviteStatusEnumMap[instance.status]!,
      'requires_install_fallback': instance.requiresInstallFallback,
    };

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
};
