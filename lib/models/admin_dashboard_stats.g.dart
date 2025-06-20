// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminDashboardStatsImpl _$$AdminDashboardStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminDashboardStatsImpl(
      totalUsers: (json['totalUsers'] as num).toInt(),
      activeUsers: (json['activeUsers'] as num).toInt(),
      totalBookings: (json['totalBookings'] as num).toInt(),
      completedBookings: (json['completedBookings'] as num).toInt(),
      pendingBookings: (json['pendingBookings'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      adRevenue: (json['adRevenue'] as num).toDouble(),
      subscriptionRevenue: (json['subscriptionRevenue'] as num).toDouble(),
      totalOrganizations: (json['totalOrganizations'] as num).toInt(),
      activeOrganizations: (json['activeOrganizations'] as num).toInt(),
      totalAmbassadors: (json['totalAmbassadors'] as num).toInt(),
      activeAmbassadors: (json['activeAmbassadors'] as num).toInt(),
      totalErrors: (json['totalErrors'] as num).toInt(),
      criticalErrors: (json['criticalErrors'] as num).toInt(),
      userGrowthByMonth:
          Map<String, int>.from(json['userGrowthByMonth'] as Map),
      revenueByMonth: (json['revenueByMonth'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      bookingsByMonth: Map<String, int>.from(json['bookingsByMonth'] as Map),
      topCountries: Map<String, int>.from(json['topCountries'] as Map),
      topCities: Map<String, int>.from(json['topCities'] as Map),
      userTypes: Map<String, int>.from(json['userTypes'] as Map),
      subscriptionTiers:
          Map<String, int>.from(json['subscriptionTiers'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$AdminDashboardStatsImplToJson(
        _$AdminDashboardStatsImpl instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'activeUsers': instance.activeUsers,
      'totalBookings': instance.totalBookings,
      'completedBookings': instance.completedBookings,
      'pendingBookings': instance.pendingBookings,
      'totalRevenue': instance.totalRevenue,
      'adRevenue': instance.adRevenue,
      'subscriptionRevenue': instance.subscriptionRevenue,
      'totalOrganizations': instance.totalOrganizations,
      'activeOrganizations': instance.activeOrganizations,
      'totalAmbassadors': instance.totalAmbassadors,
      'activeAmbassadors': instance.activeAmbassadors,
      'totalErrors': instance.totalErrors,
      'criticalErrors': instance.criticalErrors,
      'userGrowthByMonth': instance.userGrowthByMonth,
      'revenueByMonth': instance.revenueByMonth,
      'bookingsByMonth': instance.bookingsByMonth,
      'topCountries': instance.topCountries,
      'topCities': instance.topCities,
      'userTypes': instance.userTypes,
      'subscriptionTiers': instance.subscriptionTiers,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$AdminErrorLogImpl _$$AdminErrorLogImplFromJson(Map<String, dynamic> json) =>
    _$AdminErrorLogImpl(
      id: json['id'] as String,
      errorType: json['errorType'] as String,
      errorMessage: json['errorMessage'] as String,
      stackTrace: json['stackTrace'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: $enumDecode(_$ErrorSeverityEnumMap, json['severity']),
      deviceInfo: json['deviceInfo'] as String?,
      appVersion: json['appVersion'] as String?,
      isResolved: json['isResolved'] as bool,
      resolvedBy: json['resolvedBy'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      resolutionNotes: json['resolutionNotes'] as String?,
    );

Map<String, dynamic> _$$AdminErrorLogImplToJson(_$AdminErrorLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'errorType': instance.errorType,
      'errorMessage': instance.errorMessage,
      'stackTrace': instance.stackTrace,
      'userId': instance.userId,
      'userEmail': instance.userEmail,
      'timestamp': instance.timestamp.toIso8601String(),
      'severity': _$ErrorSeverityEnumMap[instance.severity]!,
      'deviceInfo': instance.deviceInfo,
      'appVersion': instance.appVersion,
      'isResolved': instance.isResolved,
      'resolvedBy': instance.resolvedBy,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'resolutionNotes': instance.resolutionNotes,
    };

const _$ErrorSeverityEnumMap = {
  ErrorSeverity.low: 'low',
  ErrorSeverity.medium: 'medium',
  ErrorSeverity.high: 'high',
  ErrorSeverity.critical: 'critical',
};

_$AdminActivityLogImpl _$$AdminActivityLogImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminActivityLogImpl(
      id: json['id'] as String,
      adminId: json['adminId'] as String,
      adminEmail: json['adminEmail'] as String,
      action: json['action'] as String,
      targetType: json['targetType'] as String,
      targetId: json['targetId'] as String,
      details: json['details'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
    );

Map<String, dynamic> _$$AdminActivityLogImplToJson(
        _$AdminActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adminId': instance.adminId,
      'adminEmail': instance.adminEmail,
      'action': instance.action,
      'targetType': instance.targetType,
      'targetId': instance.targetId,
      'details': instance.details,
      'timestamp': instance.timestamp.toIso8601String(),
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
    };

_$AdRevenueStatsImpl _$$AdRevenueStatsImplFromJson(Map<String, dynamic> json) =>
    _$AdRevenueStatsImpl(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      weeklyRevenue: (json['weeklyRevenue'] as num).toDouble(),
      dailyRevenue: (json['dailyRevenue'] as num).toDouble(),
      totalImpressions: (json['totalImpressions'] as num).toInt(),
      totalClicks: (json['totalClicks'] as num).toInt(),
      clickThroughRate: (json['clickThroughRate'] as num).toDouble(),
      revenueByAdType: (json['revenueByAdType'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      revenueByUserTier:
          (json['revenueByUserTier'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      revenueByCountry: (json['revenueByCountry'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$AdRevenueStatsImplToJson(
        _$AdRevenueStatsImpl instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'monthlyRevenue': instance.monthlyRevenue,
      'weeklyRevenue': instance.weeklyRevenue,
      'dailyRevenue': instance.dailyRevenue,
      'totalImpressions': instance.totalImpressions,
      'totalClicks': instance.totalClicks,
      'clickThroughRate': instance.clickThroughRate,
      'revenueByAdType': instance.revenueByAdType,
      'revenueByUserTier': instance.revenueByUserTier,
      'revenueByCountry': instance.revenueByCountry,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$MonetizationSettingsImpl _$$MonetizationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$MonetizationSettingsImpl(
      adsEnabledForFreeUsers: json['adsEnabledForFreeUsers'] as bool,
      adsEnabledForChildren: json['adsEnabledForChildren'] as bool,
      adsEnabledForStudioUsers: json['adsEnabledForStudioUsers'] as bool,
      adsEnabledForPremiumUsers: json['adsEnabledForPremiumUsers'] as bool,
      adFrequencyForFreeUsers:
          (json['adFrequencyForFreeUsers'] as num).toDouble(),
      adFrequencyForChildren:
          (json['adFrequencyForChildren'] as num).toDouble(),
      adFrequencyForStudioUsers:
          (json['adFrequencyForStudioUsers'] as num).toDouble(),
      adFrequencyForPremiumUsers:
          (json['adFrequencyForPremiumUsers'] as num).toDouble(),
      enabledAdTypes: (json['enabledAdTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      adTypeSettings: Map<String, bool>.from(json['adTypeSettings'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$MonetizationSettingsImplToJson(
        _$MonetizationSettingsImpl instance) =>
    <String, dynamic>{
      'adsEnabledForFreeUsers': instance.adsEnabledForFreeUsers,
      'adsEnabledForChildren': instance.adsEnabledForChildren,
      'adsEnabledForStudioUsers': instance.adsEnabledForStudioUsers,
      'adsEnabledForPremiumUsers': instance.adsEnabledForPremiumUsers,
      'adFrequencyForFreeUsers': instance.adFrequencyForFreeUsers,
      'adFrequencyForChildren': instance.adFrequencyForChildren,
      'adFrequencyForStudioUsers': instance.adFrequencyForStudioUsers,
      'adFrequencyForPremiumUsers': instance.adFrequencyForPremiumUsers,
      'enabledAdTypes': instance.enabledAdTypes,
      'adTypeSettings': instance.adTypeSettings,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
