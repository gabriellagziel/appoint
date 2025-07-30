// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Analytics _$AnalyticsFromJson(Map<String, dynamic> json) => Analytics(
      totalUsers: (json['total_users'] as num).toInt(),
      totalOrgs: (json['total_orgs'] as num).toInt(),
      activeAppointments: (json['active_appointments'] as num).toInt(),
    );

Map<String, dynamic> _$AnalyticsToJson(Analytics instance) => <String, dynamic>{
      'total_users': instance.totalUsers,
      'total_orgs': instance.totalOrgs,
      'active_appointments': instance.activeAppointments,
    };
