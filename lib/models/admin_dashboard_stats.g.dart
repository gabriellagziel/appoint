// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminDashboardStatsImpl _$$AdminDashboardStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminDashboardStatsImpl(
      totalUsers: (json['total_users'] as num).toInt(),
      activeUsers: (json['active_users'] as num).toInt(),
      totalBookings: (json['total_bookings'] as num).toInt(),
      completedBookings: (json['completed_bookings'] as num).toInt(),
      pendingBookings: (json['pending_bookings'] as num).toInt(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      adRevenue: (json['ad_revenue'] as num).toDouble(),
      subscriptionRevenue: (json['subscription_revenue'] as num).toDouble(),
      totalOrganizations: (json['total_organizations'] as num).toInt(),
      activeOrganizations: (json['active_organizations'] as num).toInt(),
      totalAmbassadors: (json['total_ambassadors'] as num).toInt(),
      activeAmbassadors: (json['active_ambassadors'] as num).toInt(),
      totalErrors: (json['total_errors'] as num).toInt(),
      criticalErrors: (json['critical_errors'] as num).toInt(),
      userGrowthByMonth:
          Map<String, int>.from(json['user_growth_by_month'] as Map),
      revenueByMonth: (json['revenue_by_month'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      bookingsByMonth: Map<String, int>.from(json['bookings_by_month'] as Map),
      topCountries: Map<String, int>.from(json['top_countries'] as Map),
      topCities: Map<String, int>.from(json['top_cities'] as Map),
      userTypes: Map<String, int>.from(json['user_types'] as Map),
      subscriptionTiers:
          Map<String, int>.from(json['subscription_tiers'] as Map),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$AdminDashboardStatsImplToJson(
        _$AdminDashboardStatsImpl instance) =>
    <String, dynamic>{
      'total_users': instance.totalUsers,
      'active_users': instance.activeUsers,
      'total_bookings': instance.totalBookings,
      'completed_bookings': instance.completedBookings,
      'pending_bookings': instance.pendingBookings,
      'total_revenue': instance.totalRevenue,
      'ad_revenue': instance.adRevenue,
      'subscription_revenue': instance.subscriptionRevenue,
      'total_organizations': instance.totalOrganizations,
      'active_organizations': instance.activeOrganizations,
      'total_ambassadors': instance.totalAmbassadors,
      'active_ambassadors': instance.activeAmbassadors,
      'total_errors': instance.totalErrors,
      'critical_errors': instance.criticalErrors,
      'user_growth_by_month': instance.userGrowthByMonth,
      'revenue_by_month': instance.revenueByMonth,
      'bookings_by_month': instance.bookingsByMonth,
      'top_countries': instance.topCountries,
      'top_cities': instance.topCities,
      'user_types': instance.userTypes,
      'subscription_tiers': instance.subscriptionTiers,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };

_$AdminErrorLogImpl _$$AdminErrorLogImplFromJson(Map<String, dynamic> json) =>
    _$AdminErrorLogImpl(
      id: json['id'] as String,
      errorType: json['error_type'] as String,
      errorMessage: json['error_message'] as String,
      stackTrace: json['stack_trace'] as String,
      userId: json['user_id'] as String,
      userEmail: json['user_email'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: $enumDecode(_$ErrorSeverityEnumMap, json['severity']),
      deviceInfo: json['device_info'] as String?,
      appVersion: json['app_version'] as String?,
      isResolved: json['is_resolved'] as bool,
      resolvedBy: json['resolved_by'] as String?,
      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.parse(json['resolved_at'] as String),
      resolutionNotes: json['resolution_notes'] as String?,
    );

Map<String, dynamic> _$$AdminErrorLogImplToJson(_$AdminErrorLogImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'error_type': instance.errorType,
    'error_message': instance.errorMessage,
    'stack_trace': instance.stackTrace,
    'user_id': instance.userId,
    'user_email': instance.userEmail,
    'timestamp': instance.timestamp.toIso8601String(),
    'severity': _$ErrorSeverityEnumMap[instance.severity]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('app_version', instance.appVersion);
  val['is_resolved'] = instance.isResolved;
  writeNotNull('resolved_by', instance.resolvedBy);
  writeNotNull('resolved_at', instance.resolvedAt?.toIso8601String());
  writeNotNull('resolution_notes', instance.resolutionNotes);
  return val;
}

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
      adminId: json['admin_id'] as String,
      adminEmail: json['admin_email'] as String,
      action: json['action'] as String,
      targetType: json['target_type'] as String,
      targetId: json['target_id'] as String,
      details: json['details'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      ipAddress: json['ip_address'] as String,
      userAgent: json['user_agent'] as String,
    );

Map<String, dynamic> _$$AdminActivityLogImplToJson(
        _$AdminActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'admin_id': instance.adminId,
      'admin_email': instance.adminEmail,
      'action': instance.action,
      'target_type': instance.targetType,
      'target_id': instance.targetId,
      'details': instance.details,
      'timestamp': instance.timestamp.toIso8601String(),
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
    };

_$AdRevenueStatsImpl _$$AdRevenueStatsImplFromJson(Map<String, dynamic> json) =>
    _$AdRevenueStatsImpl(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      monthlyRevenue: (json['monthly_revenue'] as num).toDouble(),
      weeklyRevenue: (json['weekly_revenue'] as num).toDouble(),
      dailyRevenue: (json['daily_revenue'] as num).toDouble(),
      totalImpressions: (json['total_impressions'] as num).toInt(),
      totalClicks: (json['total_clicks'] as num).toInt(),
      clickThroughRate: (json['click_through_rate'] as num).toDouble(),
      revenueByAdType: (json['revenue_by_ad_type'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      revenueByUserTier:
          (json['revenue_by_user_tier'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      revenueByCountry:
          (json['revenue_by_country'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$AdRevenueStatsImplToJson(
        _$AdRevenueStatsImpl instance) =>
    <String, dynamic>{
      'total_revenue': instance.totalRevenue,
      'monthly_revenue': instance.monthlyRevenue,
      'weekly_revenue': instance.weeklyRevenue,
      'daily_revenue': instance.dailyRevenue,
      'total_impressions': instance.totalImpressions,
      'total_clicks': instance.totalClicks,
      'click_through_rate': instance.clickThroughRate,
      'revenue_by_ad_type': instance.revenueByAdType,
      'revenue_by_user_tier': instance.revenueByUserTier,
      'revenue_by_country': instance.revenueByCountry,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };

_$MonetizationSettingsImpl _$$MonetizationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$MonetizationSettingsImpl(
      adsEnabledForFreeUsers: json['ads_enabled_for_free_users'] as bool,
      adsEnabledForChildren: json['ads_enabled_for_children'] as bool,
      adsEnabledForStudioUsers: json['ads_enabled_for_studio_users'] as bool,
      adsEnabledForPremiumUsers: json['ads_enabled_for_premium_users'] as bool,
      adFrequencyForFreeUsers:
          (json['ad_frequency_for_free_users'] as num).toDouble(),
      adFrequencyForChildren:
          (json['ad_frequency_for_children'] as num).toDouble(),
      adFrequencyForStudioUsers:
          (json['ad_frequency_for_studio_users'] as num).toDouble(),
      adFrequencyForPremiumUsers:
          (json['ad_frequency_for_premium_users'] as num).toDouble(),
      enabledAdTypes: (json['enabled_ad_types'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      adTypeSettings: Map<String, bool>.from(json['ad_type_settings'] as Map),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$MonetizationSettingsImplToJson(
        _$MonetizationSettingsImpl instance) =>
    <String, dynamic>{
      'ads_enabled_for_free_users': instance.adsEnabledForFreeUsers,
      'ads_enabled_for_children': instance.adsEnabledForChildren,
      'ads_enabled_for_studio_users': instance.adsEnabledForStudioUsers,
      'ads_enabled_for_premium_users': instance.adsEnabledForPremiumUsers,
      'ad_frequency_for_free_users': instance.adFrequencyForFreeUsers,
      'ad_frequency_for_children': instance.adFrequencyForChildren,
      'ad_frequency_for_studio_users': instance.adFrequencyForStudioUsers,
      'ad_frequency_for_premium_users': instance.adFrequencyForPremiumUsers,
      'enabled_ad_types': instance.enabledAdTypes,
      'ad_type_settings': instance.adTypeSettings,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };
