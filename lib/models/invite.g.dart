// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String,
      inviteeId: json['inviteeId'] as String,
      inviteeContact:
          Contact.fromJson(json['inviteeContact'] as Map<String, dynamic>),
      status: $enumDecode(_$InviteStatusEnumMap, json['status']),
      requiresInstallFallback: json['requiresInstallFallback'] as bool,
    );

Map<String, dynamic> _$InviteToJson(Invite instance) => <String, dynamic>{
      'id': instance.id,
      'appointmentId': instance.appointmentId,
      'inviteeId': instance.inviteeId,
      'inviteeContact': instance.inviteeContact.toJson(),
      'status': _$InviteStatusEnumMap[instance.status]!,
      'requiresInstallFallback': instance.requiresInstallFallback,
    };

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
};
