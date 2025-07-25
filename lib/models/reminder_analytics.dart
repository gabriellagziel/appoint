import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_analytics.freezed.dart';
part 'reminder_analytics.g.dart';

@freezed
class ReminderAnalytics with _$ReminderAnalytics {
  const factory ReminderAnalytics({
    required String id,
    required String userId,
    required String reminderId,
    required ReminderAnalyticsEvent eventType,
    required DateTime timestamp,
    Map<String, dynamic>? eventData,
    String? deviceInfo,
    String? userAgent,
    String? sessionId,
  }) = _ReminderAnalytics;

  factory ReminderAnalytics.fromJson(Map<String, dynamic> json) => 
      _$ReminderAnalyticsFromJson(json);

  factory ReminderAnalytics.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReminderAnalytics.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class ReminderStats with _$ReminderStats {
  const factory ReminderStats({
    required String userId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required int totalReminders,
    required int completedReminders,
    required int missedReminders,
    required int snoozedReminders,
    required int locationBasedReminders,
    required int timeBasedReminders,
    required int meetingRelatedReminders,
    required double completionRate,
    required Duration averageCompletionTime,
    required Map<String, int> remindersByPriority,
    required Map<String, int> remindersByType,
    required Map<String, int> remindersByStatus,
    Map<String, dynamic>? metadata,
  }) = _ReminderStats;

  factory ReminderStats.fromJson(Map<String, dynamic> json) => 
      _$ReminderStatsFromJson(json);
}

@freezed
class AdminReminderStats with _$AdminReminderStats {
  const factory AdminReminderStats({
    required DateTime generatedAt,
    required DateTime periodStart,
    required DateTime periodEnd,
    required int totalUsers,
    required int activeReminderUsers,
    required int totalReminders,
    required int locationBasedUsage,
    required int timeBasedUsage,
    required double overallCompletionRate,
    required Map<String, int> remindersByPlan,
    required Map<String, int> locationUsageByPlan,
    required Map<String, double> completionRatesByPlan,
    required List<TopReminderUser> topUsers,
    Map<String, dynamic>? additionalMetrics,
  }) = _AdminReminderStats;

  factory AdminReminderStats.fromJson(Map<String, dynamic> json) => 
      _$AdminReminderStatsFromJson(json);
}

@freezed
class TopReminderUser with _$TopReminderUser {
  const factory TopReminderUser({
    required String userId,
    required String email,
    required int reminderCount,
    required double completionRate,
    required String planType,
  }) = _TopReminderUser;

  factory TopReminderUser.fromJson(Map<String, dynamic> json) => 
      _$TopReminderUserFromJson(json);
}

enum ReminderAnalyticsEvent {
  @JsonValue('reminder_created')
  reminderCreated,
  @JsonValue('reminder_triggered')
  reminderTriggered,
  @JsonValue('reminder_completed')
  reminderCompleted,
  @JsonValue('reminder_snoozed')
  reminderSnoozed,
  @JsonValue('reminder_dismissed')
  reminderDismissed,
  @JsonValue('reminder_deleted')
  reminderDeleted,
  @JsonValue('location_reminder_geofence_entered')
  locationReminderGeofenceEntered,
  @JsonValue('location_reminder_geofence_exited')
  locationReminderGeofenceExited,
  @JsonValue('notification_delivered')
  notificationDelivered,
  @JsonValue('notification_opened')
  notificationOpened,
  @JsonValue('map_access_denied')
  mapAccessDenied,
  @JsonValue('upgrade_prompt_shown')
  upgradePromptShown,
  @JsonValue('upgrade_prompt_dismissed')
  upgradePromptDismissed,
  @JsonValue('upgrade_prompt_clicked')
  upgradePromptClicked,
}

extension ReminderAnalyticsEventExtension on ReminderAnalyticsEvent {
  String get displayName {
    switch (this) {
      case ReminderAnalyticsEvent.reminderCreated:
        return 'Reminder Created';
      case ReminderAnalyticsEvent.reminderTriggered:
        return 'Reminder Triggered';
      case ReminderAnalyticsEvent.reminderCompleted:
        return 'Reminder Completed';
      case ReminderAnalyticsEvent.reminderSnoozed:
        return 'Reminder Snoozed';
      case ReminderAnalyticsEvent.reminderDismissed:
        return 'Reminder Dismissed';
      case ReminderAnalyticsEvent.reminderDeleted:
        return 'Reminder Deleted';
      case ReminderAnalyticsEvent.locationReminderGeofenceEntered:
        return 'Location Geofence Entered';
      case ReminderAnalyticsEvent.locationReminderGeofenceExited:
        return 'Location Geofence Exited';
      case ReminderAnalyticsEvent.notificationDelivered:
        return 'Notification Delivered';
      case ReminderAnalyticsEvent.notificationOpened:
        return 'Notification Opened';
      case ReminderAnalyticsEvent.mapAccessDenied:
        return 'Map Access Denied';
      case ReminderAnalyticsEvent.upgradePromptShown:
        return 'Upgrade Prompt Shown';
      case ReminderAnalyticsEvent.upgradePromptDismissed:
        return 'Upgrade Prompt Dismissed';
      case ReminderAnalyticsEvent.upgradePromptClicked:
        return 'Upgrade Prompt Clicked';
    }
  }

  bool get isConversionEvent {
    switch (this) {
      case ReminderAnalyticsEvent.reminderCompleted:
      case ReminderAnalyticsEvent.upgradePromptClicked:
        return true;
      default:
        return false;
    }
  }
}

// Helper class for generating reminder insights
class ReminderInsights {
  static String generateUserInsight(ReminderStats stats) {
    if (stats.totalReminders == 0) {
      return "You haven't created any reminders yet. Start organizing your day!";
    }

    final completionRate = (stats.completionRate * 100).round();
    final bestType = stats.remindersByType.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    if (completionRate >= 90) {
      return "Excellent! You completed $completionRate% of your reminders this week. You're crushing your goals! 🎯";
    } else if (completionRate >= 70) {
      return "Great job! You completed $completionRate% of your reminders. You seem to work best with $bestType reminders.";
    } else if (completionRate >= 50) {
      return "You completed $completionRate% of your reminders. Try setting fewer, more focused reminders to improve your completion rate.";
    } else {
      return "You completed $completionRate% of your reminders. Consider using simpler reminders or adjusting your notification settings.";
    }
  }

  static Map<String, dynamic> calculateTrends(
    ReminderStats currentPeriod,
    ReminderStats previousPeriod,
  ) {
    final completionTrend = currentPeriod.completionRate - previousPeriod.completionRate;
    final totalTrend = currentPeriod.totalReminders - previousPeriod.totalReminders;

    return {
      'completionRateTrend': completionTrend,
      'totalRemindersTrend': totalTrend,
      'isImproving': completionTrend > 0,
      'isMoreActive': totalTrend > 0,
    };
  }
}