// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderImpl _$$ReminderImplFromJson(Map<String, dynamic> json) =>
    _$ReminderImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      ownerId: json['ownerId'] as String,
      assigneeId: json['assigneeId'] as String?,
      familyId: json['familyId'] as String?,
      type: $enumDecode(_$ReminderTypeEnumMap, json['type']),
      recurrence: $enumDecode(_$ReminderRecurrenceEnumMap, json['recurrence']),
      isCompleted: json['isCompleted'] as bool?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReminderImplToJson(_$ReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'ownerId': instance.ownerId,
      'assigneeId': instance.assigneeId,
      'familyId': instance.familyId,
      'type': _$ReminderTypeEnumMap[instance.type]!,
      'recurrence': _$ReminderRecurrenceEnumMap[instance.recurrence]!,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$ReminderTypeEnumMap = {
  ReminderType.personal: 'personal',
  ReminderType.meeting: 'meeting',
  ReminderType.task: 'task',
  ReminderType.notification: 'notification',
};

const _$ReminderRecurrenceEnumMap = {
  ReminderRecurrence.none: 'none',
  ReminderRecurrence.daily: 'daily',
  ReminderRecurrence.weekly: 'weekly',
  ReminderRecurrence.monthly: 'monthly',
  ReminderRecurrence.yearly: 'yearly',
};
