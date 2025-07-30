// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeetingParticipantImpl _$$MeetingParticipantImplFromJson(
        Map<String, dynamic> json) =>
    _$MeetingParticipantImpl(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: $enumDecodeNullable(_$ParticipantRoleEnumMap, json['role']) ??
          ParticipantRole.participant,
      hasResponded: json['has_responded'] as bool? ?? false,
      willAttend: json['will_attend'] as bool? ?? true,
      respondedAt: _$JsonConverterFromJson<String, DateTime>(
          json['responded_at'], const DateTimeConverter().fromJson),
    );

Map<String, dynamic> _$$MeetingParticipantImplToJson(
    _$MeetingParticipantImpl instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('avatar_url', instance.avatarUrl);
  val['role'] = _$ParticipantRoleEnumMap[instance.role]!;
  val['has_responded'] = instance.hasResponded;
  val['will_attend'] = instance.willAttend;
  writeNotNull(
      'responded_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.respondedAt, const DateTimeConverter().toJson));
  return val;
}

const _$ParticipantRoleEnumMap = {
  ParticipantRole.organizer: 'organizer',
  ParticipantRole.admin: 'admin',
  ParticipantRole.participant: 'participant',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$MeetingImpl _$$MeetingImplFromJson(Map<String, dynamic> json) =>
    _$MeetingImpl(
      id: json['id'] as String,
      organizerId: json['organizer_id'] as String,
      title: json['title'] as String,
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as String),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as String),
      description: json['description'] as String?,
      location: json['location'] as String?,
      virtualMeetingUrl: json['virtual_meeting_url'] as String?,
      participants: (json['participants'] as List<dynamic>?)
              ?.map(
                  (e) => MeetingParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MeetingParticipant>[],
      status: $enumDecodeNullable(_$MeetingStatusEnumMap, json['status']) ??
          MeetingStatus.draft,
      createdAt: _$JsonConverterFromJson<String, DateTime>(
          json['created_at'], const DateTimeConverter().fromJson),
      updatedAt: _$JsonConverterFromJson<String, DateTime>(
          json['updated_at'], const DateTimeConverter().fromJson),
      customFormId: json['custom_form_id'] as String?,
      checklistId: json['checklist_id'] as String?,
      groupChatId: json['group_chat_id'] as String?,
      eventSettings: json['event_settings'] as Map<String, dynamic>?,
      businessProfileId: json['business_profile_id'] as String?,
      isRecurring: json['is_recurring'] as bool?,
      recurringPattern: json['recurring_pattern'] as String?,
    );

Map<String, dynamic> _$$MeetingImplToJson(_$MeetingImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'organizer_id': instance.organizerId,
    'title': instance.title,
    'startTime': const DateTimeConverter().toJson(instance.startTime),
    'endTime': const DateTimeConverter().toJson(instance.endTime),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('location', instance.location);
  writeNotNull('virtual_meeting_url', instance.virtualMeetingUrl);
  val['participants'] = instance.participants.map((e) => e.toJson()).toList();
  val['status'] = _$MeetingStatusEnumMap[instance.status]!;
  writeNotNull(
      'created_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.createdAt, const DateTimeConverter().toJson));
  writeNotNull(
      'updated_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.updatedAt, const DateTimeConverter().toJson));
  writeNotNull('custom_form_id', instance.customFormId);
  writeNotNull('checklist_id', instance.checklistId);
  writeNotNull('group_chat_id', instance.groupChatId);
  writeNotNull('event_settings', instance.eventSettings);
  writeNotNull('business_profile_id', instance.businessProfileId);
  writeNotNull('is_recurring', instance.isRecurring);
  writeNotNull('recurring_pattern', instance.recurringPattern);
  return val;
}

const _$MeetingStatusEnumMap = {
  MeetingStatus.draft: 'draft',
  MeetingStatus.scheduled: 'scheduled',
  MeetingStatus.active: 'active',
  MeetingStatus.completed: 'completed',
  MeetingStatus.cancelled: 'cancelled',
};
