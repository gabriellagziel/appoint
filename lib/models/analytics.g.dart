// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Analytics _$AnalyticsFromJson(Map<String, dynamic> json) => Analytics(
      totalUsers: (json['totalUsers'] as num).toInt(),
      totalOrgs: (json['totalOrgs'] as num).toInt(),
      activeAppointments: (json['activeAppointments'] as num).toInt(),
    );

Map<String, dynamic> _$AnalyticsToJson(Analytics instance) => <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'totalOrgs': instance.totalOrgs,
      'activeAppointments': instance.activeAppointments,
    };
