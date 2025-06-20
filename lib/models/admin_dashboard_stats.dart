import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_stats.freezed.dart';
part 'admin_dashboard_stats.g.dart';

@freezed
class AdminDashboardStats with _$AdminDashboardStats {
  const factory AdminDashboardStats({
    required int totalUsers,
    required int activeUsers,
    required int totalBookings,
    required int completedBookings,
    required int pendingBookings,
    required double totalRevenue,
    required double adRevenue,
    required double subscriptionRevenue,
    required int totalOrganizations,
    required int activeOrganizations,
    required int totalAmbassadors,
    required int activeAmbassadors,
    required int totalErrors,
    required int criticalErrors,
    required Map<String, int> userGrowthByMonth,
    required Map<String, double> revenueByMonth,
    required Map<String, int> bookingsByMonth,
    required Map<String, int> topCountries,
    required Map<String, int> topCities,
    required Map<String, int> userTypes,
    required Map<String, int> subscriptionTiers,
    required DateTime lastUpdated,
  }) = _AdminDashboardStats;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardStatsFromJson(json);
}

@freezed
class AdminErrorLog with _$AdminErrorLog {
  const factory AdminErrorLog({
    required String id,
    required String errorType,
    required String errorMessage,
    required String stackTrace,
    required String userId,
    required String userEmail,
    required DateTime timestamp,
    required ErrorSeverity severity,
    required String? deviceInfo,
    required String? appVersion,
    required bool isResolved,
    String? resolvedBy,
    DateTime? resolvedAt,
    String? resolutionNotes,
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
    required String id,
    required String adminId,
    required String adminEmail,
    required String action,
    required String targetType,
    required String targetId,
    required Map<String, dynamic> details,
    required DateTime timestamp,
    required String ipAddress,
    required String userAgent,
  }) = _AdminActivityLog;

  factory AdminActivityLog.fromJson(Map<String, dynamic> json) =>
      _$AdminActivityLogFromJson(json);
}

@freezed
class AdRevenueStats with _$AdRevenueStats {
  const factory AdRevenueStats({
    required double totalRevenue,
    required double monthlyRevenue,
    required double weeklyRevenue,
    required double dailyRevenue,
    required int totalImpressions,
    required int totalClicks,
    required double clickThroughRate,
    required Map<String, double> revenueByAdType,
    required Map<String, double> revenueByUserTier,
    required Map<String, double> revenueByCountry,
    required DateTime lastUpdated,
  }) = _AdRevenueStats;

  factory AdRevenueStats.fromJson(Map<String, dynamic> json) =>
      _$AdRevenueStatsFromJson(json);
}

@freezed
class MonetizationSettings with _$MonetizationSettings {
  const factory MonetizationSettings({
    required bool adsEnabledForFreeUsers,
    required bool adsEnabledForChildren,
    required bool adsEnabledForStudioUsers,
    required bool adsEnabledForPremiumUsers,
    required double adFrequencyForFreeUsers,
    required double adFrequencyForChildren,
    required double adFrequencyForStudioUsers,
    required double adFrequencyForPremiumUsers,
    required List<String> enabledAdTypes,
    required Map<String, bool> adTypeSettings,
    required DateTime lastUpdated,
  }) = _MonetizationSettings;

  factory MonetizationSettings.fromJson(Map<String, dynamic> json) =>
      _$MonetizationSettingsFromJson(json);
} 