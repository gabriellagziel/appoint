import 'package:appoint/models/supervision_level.dart';

class EnhancedFamilyLink {
  final String id;
  final String parentId;
  final String childId;
  final String childDisplayName;
  final String? childPhotoUrl;
  final int childAge;
  final String status; // 'pending_approval', 'active', 'suspended', 'denied'
  final SupervisionLevel supervisionLevel;
  final DateTime invitedAt;
  final List<DateTime> consentedAt;
  final Map<String, bool> permissions;
  final Map<String, bool> notificationSettings;
  final DateTime? lastActivityAt;
  final Map<String, dynamic> usageStats;
  final bool isEmergencyModeEnabled;
  final String? emergencyContact;

  const EnhancedFamilyLink({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.childDisplayName,
    this.childPhotoUrl,
    required this.childAge,
    required this.status,
    required this.supervisionLevel,
    required this.invitedAt,
    required this.consentedAt,
    required this.permissions,
    required this.notificationSettings,
    this.lastActivityAt,
    required this.usageStats,
    this.isEmergencyModeEnabled = false,
    this.emergencyContact,
  });

  factory EnhancedFamilyLink.fromJson(Map<String, dynamic> json) {
    return EnhancedFamilyLink(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      childId: json['childId'] as String,
      childDisplayName: json['childDisplayName'] as String,
      childPhotoUrl: json['childPhotoUrl'] as String?,
      childAge: json['childAge'] as int,
      status: json['status'] as String,
      supervisionLevel: SupervisionLevel.values.firstWhere(
        (level) => level.name == json['supervisionLevel'],
        orElse: () => SupervisionLevel.full,
      ),
      invitedAt: DateTime.parse(json['invitedAt'] as String),
      consentedAt: (json['consentedAt'] as List<dynamic>)
          .map((date) => DateTime.parse(date as String))
          .toList(),
      permissions: Map<String, bool>.from(json['permissions'] as Map),
      notificationSettings: Map<String, bool>.from(json['notificationSettings'] as Map),
      lastActivityAt: json['lastActivityAt'] != null 
          ? DateTime.parse(json['lastActivityAt'] as String)
          : null,
      usageStats: Map<String, dynamic>.from(json['usageStats'] as Map? ?? {}),
      isEmergencyModeEnabled: json['isEmergencyModeEnabled'] as bool? ?? false,
      emergencyContact: json['emergencyContact'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'childId': childId,
      'childDisplayName': childDisplayName,
      'childPhotoUrl': childPhotoUrl,
      'childAge': childAge,
      'status': status,
      'supervisionLevel': supervisionLevel.name,
      'invitedAt': invitedAt.toIso8601String(),
      'consentedAt': consentedAt.map((date) => date.toIso8601String()).toList(),
      'permissions': permissions,
      'notificationSettings': notificationSettings,
      'lastActivityAt': lastActivityAt?.toIso8601String(),
      'usageStats': usageStats,
      'isEmergencyModeEnabled': isEmergencyModeEnabled,
      'emergencyContact': emergencyContact,
    };
  }

  EnhancedFamilyLink copyWith({
    String? id,
    String? parentId,
    String? childId,
    String? childDisplayName,
    String? childPhotoUrl,
    int? childAge,
    String? status,
    SupervisionLevel? supervisionLevel,
    DateTime? invitedAt,
    List<DateTime>? consentedAt,
    Map<String, bool>? permissions,
    Map<String, bool>? notificationSettings,
    DateTime? lastActivityAt,
    Map<String, dynamic>? usageStats,
    bool? isEmergencyModeEnabled,
    String? emergencyContact,
  }) {
    return EnhancedFamilyLink(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      childId: childId ?? this.childId,
      childDisplayName: childDisplayName ?? this.childDisplayName,
      childPhotoUrl: childPhotoUrl ?? this.childPhotoUrl,
      childAge: childAge ?? this.childAge,
      status: status ?? this.status,
      supervisionLevel: supervisionLevel ?? this.supervisionLevel,
      invitedAt: invitedAt ?? this.invitedAt,
      consentedAt: consentedAt ?? this.consentedAt,
      permissions: permissions ?? this.permissions,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      usageStats: usageStats ?? this.usageStats,
      isEmergencyModeEnabled: isEmergencyModeEnabled ?? this.isEmergencyModeEnabled,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }

  /// Get default permissions based on supervision level and child age
  static Map<String, bool> getDefaultPermissions(SupervisionLevel level, int age) {
    final Map<String, bool> permissions = {
      'canUseApp': true,
      'canCreateContent': false,
      'canCommunicate': false,
      'canAccessPlaytime': false,
      'canMakeInAppPurchases': false,
      'canShareLocation': false,
      'canAccessCamera': false,
      'canAccessMicrophone': false,
      'canAccessContacts': false,
      'canInstallApps': false,
      'canAccessBrowser': false,
      'canUseVoiceChat': false,
      'canJoinPublicGroups': false,
      'canReceiveMessagesFromStrangers': false,
    };

    switch (level) {
      case SupervisionLevel.full:
        // Most restrictive - only basic app usage
        permissions['canUseApp'] = true;
        if (age >= 10) {
          permissions['canAccessPlaytime'] = true;
          permissions['canCommunicate'] = true;
        }
        break;

      case SupervisionLevel.custom:
        // Moderate restrictions based on age
        permissions['canUseApp'] = true;
        permissions['canAccessPlaytime'] = true;
        permissions['canCommunicate'] = true;
        
        if (age >= 10) {
          permissions['canCreateContent'] = true;
          permissions['canShareLocation'] = true;
        }
        
        if (age >= 13) {
          permissions['canAccessCamera'] = true;
          permissions['canAccessMicrophone'] = true;
          permissions['canUseVoiceChat'] = true;
        }
        
        if (age >= 16) {
          permissions['canMakeInAppPurchases'] = true;
          permissions['canAccessBrowser'] = true;
          permissions['canJoinPublicGroups'] = true;
        }
        break;

      case SupervisionLevel.free:
        // Only available for 16+ - minimal restrictions
        if (age >= 16) {
          permissions.updateAll((key, value) => true);
          // Still some safety restrictions
          permissions['canReceiveMessagesFromStrangers'] = false;
        } else {
          // Fallback to custom for under 16
          return getDefaultPermissions(SupervisionLevel.custom, age);
        }
        break;
    }

    return permissions;
  }

  /// Get default notification settings based on supervision level
  static Map<String, bool> getDefaultNotificationSettings(SupervisionLevel level) {
    final Map<String, bool> settings = {
      'notifyOnAppUsage': false,
      'notifyOnPlaytimeStart': false,
      'notifyOnNewFriends': false,
      'notifyOnContentCreation': false,
      'notifyOnInAppPurchases': false,
      'notifyOnLocationChange': false,
      'notifyOnCommunication': false,
      'notifyOnSafetyAlerts': true, // Always enabled
      'notifyOnEmergency': true, // Always enabled
      'sendDailyReports': false,
      'sendWeeklyReports': false,
    };

    switch (level) {
      case SupervisionLevel.full:
        // Enable most notifications for full control
        settings.updateAll((key, value) => key.contains('Safety') || key.contains('Emergency') || key.contains('Report') ? value : true);
        settings['sendDailyReports'] = true;
        break;

      case SupervisionLevel.custom:
        // Moderate notifications
        settings['notifyOnPlaytimeStart'] = true;
        settings['notifyOnNewFriends'] = true;
        settings['notifyOnInAppPurchases'] = true;
        settings['notifyOnLocationChange'] = true;
        settings['sendWeeklyReports'] = true;
        break;

      case SupervisionLevel.free:
        // Minimal notifications - only safety and emergency
        // Default values are already set correctly
        break;
    }

    return settings;
  }

  /// Check if this family link allows a specific action
  bool canPerformAction(String action) {
    return permissions[action] ?? false;
  }

  /// Check if parent should be notified about a specific event
  bool shouldNotifyParent(String event) {
    if (supervisionLevel == SupervisionLevel.free) {
      return event.contains('Safety') || event.contains('Emergency');
    }
    return notificationSettings[event] ?? false;
  }

  /// Get display color based on supervision level
  static Color getSupervisionLevelColor(SupervisionLevel level) {
    switch (level) {
      case SupervisionLevel.full:
        return const Color(0xFFE53E3E); // Red
      case SupervisionLevel.custom:
        return const Color(0xFFED8936); // Orange
      case SupervisionLevel.free:
        return const Color(0xFF38A169); // Green
    }
  }

  /// Get usage statistics summary
  Map<String, dynamic> getUsageSummary() {
    return {
      'totalScreenTime': usageStats['totalScreenTime'] ?? 0,
      'playtimeSessions': usageStats['playtimeSessions'] ?? 0,
      'lastActiveToday': lastActivityAt != null && 
          DateTime.now().difference(lastActivityAt!).inDays == 0,
      'weeklyAverage': usageStats['weeklyAverage'] ?? 0,
      'mostUsedFeature': usageStats['mostUsedFeature'] ?? 'Playtime',
    };
  }
}

// Extension for better DateTime handling in family contexts
extension FamilyDateTime on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return isAfter(weekStart) && isBefore(now.add(const Duration(days: 1)));
  }

  String get timeAgoShort {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}