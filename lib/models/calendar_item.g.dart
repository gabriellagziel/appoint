// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarItemImpl _$$CalendarItemImplFromJson(Map<String, dynamic> json) =>
    _$CalendarItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: json['endAt'] == null
          ? null
          : DateTime.parse(json['endAt'] as String),
      type: $enumDecode(_$CalendarItemTypeEnumMap, json['type']),
      ownerId: json['ownerId'] as String,
      assigneeId: json['assigneeId'] as String?,
      familyId: json['familyId'] as String?,
      visibility: $enumDecode(_$CalendarVisibilityEnumMap, json['visibility']),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isCompleted: json['isCompleted'] as bool?,
    );

Map<String, dynamic> _$$CalendarItemImplToJson(_$CalendarItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt?.toIso8601String(),
      'type': _$CalendarItemTypeEnumMap[instance.type]!,
      'ownerId': instance.ownerId,
      'assigneeId': instance.assigneeId,
      'familyId': instance.familyId,
      'visibility': _$CalendarVisibilityEnumMap[instance.visibility]!,
      'metadata': instance.metadata,
      'isCompleted': instance.isCompleted,
    };

const _$CalendarItemTypeEnumMap = {
  CalendarItemType.meeting: 'meeting',
  CalendarItemType.reminder: 'reminder',
  CalendarItemType.appointment: 'appointment',
};

const _$CalendarVisibilityEnumMap = {
  CalendarVisibility.private: 'private',
  CalendarVisibility.family: 'family',
};
