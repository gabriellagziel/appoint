import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_stats.freezed.dart';
part 'admin_dashboard_stats.g.dart';

@freezed
class AdminDashboardStats with _$AdminDashboardStats {
  const factory AdminDashboardStats({
    required final int totalUsers,
    required final int activeUsers,
    required final int totalBookings,
    required final int completedBookings,
    required final int pendingBookings,
    required final double totalRevenue,
    required final double adRevenue,
    required final double subscriptionRevenue,
    required final int totalOrganizations,
    required final int activeOrganizations,
    required final int totalAmbassadors,
    required final int activeAmbassadors,
    required final int totalErrors,
    required final int criticalErrors,
    required final Map<String, int> userGrowthByMonth,
    required final Map<String, double> revenueByMonth,
    required final Map<String, int> bookingsByMonth,
    required final Map<String, int> topCountries,
    required final Map<String, int> topCities,
    required final Map<String, int> userTypes,
    required final Map<String, int> subscriptionTiers,
    required final DateTime lastUpdated,
  }) = _AdminDashboardStats;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardStatsFromJson(json);
}

@freezed
class AdminErrorLog with _$AdminErrorLog {
  const factory AdminErrorLog({
    required final String id,
    required final String errorType,
    required final String errorMessage,
    required final String stackTrace,
    required final String userId,
    required final String userEmail,
    required final DateTime timestamp,
    required final ErrorSeverity severity,
    required final String? deviceInfo,
    required final String? appVersion,
    required final bool isResolved,
    final String? resolvedBy,
    final DateTime? resolvedAt,
    final String? resolutionNotes,
  }) = _AdminErrorLog;

  factory AdminErrorLog.fromJson(Map<String, dynamic> json) =>
      _$AdminErrorLogFromJson(json);
}

enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

@freezed
class AdminActivityLog with _$AdminActivityLog {
  const factory AdminActivityLog({
    required final String id,
    required final String adminId,
    required final String adminEmail,
    required final String action,
    required final String targetType,
    required final String targetId,
    required final Map<String, dynamic> details,
    required final DateTime timestamp,
    required final String ipAddress,
    required final String userAgent,
  }) = _AdminActivityLog;

  factory AdminActivityLog.fromJson(Map<String, dynamic> json) =>
      _$AdminActivityLogFromJson(json);
}

@freezed
class AdRevenueStats with _$AdRevenueStats {
  const factory AdRevenueStats({
    required final double totalRevenue,
    required final double monthlyRevenue,
    required final double weeklyRevenue,
    required final double dailyRevenue,
    required final int totalImpressions,
    required final int totalClicks,
    required final double clickThroughRate,
    required final Map<String, double> revenueByAdType,
    required final Map<String, double> revenueByUserTier,
    required final Map<String, double> revenueByCountry,
    required final DateTime lastUpdated,
  }) = _AdRevenueStats;

  factory AdRevenueStats.fromJson(Map<String, dynamic> json) =>
      _$AdRevenueStatsFromJson(json);
}

@freezed
class MonetizationSettings with _$MonetizationSettings {
  const factory MonetizationSettings({
    required final bool adsEnabledForFreeUsers,
    required final bool adsEnabledForChildren,
    required final bool adsEnabledForStudioUsers,
    required final bool adsEnabledForPremiumUsers,
    required final double adFrequencyForFreeUsers,
    required final double adFrequencyForChildren,
    required final double adFrequencyForStudioUsers,
    required final double adFrequencyForPremiumUsers,
    required final List<String> enabledAdTypes,
    required final Map<String, bool> adTypeSettings,
    required final DateTime lastUpdated,
  }) = _MonetizationSettings;

  factory MonetizationSettings.fromJson(Map<String, dynamic> json) =>
      _$MonetizationSettingsFromJson(json);
}
