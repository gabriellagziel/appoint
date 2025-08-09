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
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      ownerId: json['ownerId'] as String,
      assigneeId: json['assigneeId'] as String?,
      familyId: json['familyId'] as String?,
      visibility: json['visibility'] as String,
      type: json['type'] as String,
      location: json['location'] as String?,
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CalendarItemImplToJson(_$CalendarItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'ownerId': instance.ownerId,
      'assigneeId': instance.assigneeId,
      'familyId': instance.familyId,
      'visibility': instance.visibility,
      'type': instance.type,
      'location': instance.location,
      'attendees': instance.attendees,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
