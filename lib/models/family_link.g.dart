// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FamilyLinkImpl _$$FamilyLinkImplFromJson(Map<String, dynamic> json) =>
    _$FamilyLinkImpl(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      childId: json['childId'] as String,
      status: json['status'] as String,
      invitedAt: DateTime.parse(json['invitedAt'] as String),
      consentedAt: (json['consentedAt'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$FamilyLinkImplToJson(_$FamilyLinkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'childId': instance.childId,
      'status': instance.status,
      'invitedAt': instance.invitedAt.toIso8601String(),
      'consentedAt':
          instance.consentedAt?.map((e) => e.toIso8601String()).toList(),
      'notes': instance.notes,
    };

_$FamilyOverviewImpl _$$FamilyOverviewImplFromJson(Map<String, dynamic> json) =>
    _$FamilyOverviewImpl(
      parentId: json['parentId'] as String,
      connectedChildren: (json['connectedChildren'] as List<dynamic>)
          .map((e) => FamilyLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      pendingInvites: (json['pendingInvites'] as List<dynamic>)
          .map((e) => FamilyLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSessions: (json['totalSessions'] as num).toInt(),
      completedReminders: (json['completedReminders'] as num).toInt(),
    );

Map<String, dynamic> _$$FamilyOverviewImplToJson(
        _$FamilyOverviewImpl instance) =>
    <String, dynamic>{
      'parentId': instance.parentId,
      'connectedChildren': instance.connectedChildren,
      'pendingInvites': instance.pendingInvites,
      'totalSessions': instance.totalSessions,
      'completedReminders': instance.completedReminders,
    };
