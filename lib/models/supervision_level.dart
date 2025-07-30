enum SupervisionLevel {
  /// Full parental control - all activities monitored and restricted
  /// Suitable for younger children (under 13)
  /// - All actions require parent approval
  /// - Maximum notifications enabled
  /// - Strictest content filtering
  /// - Limited communication capabilities
  full,

  /// Custom supervision level with configurable restrictions
  /// Suitable for teens (13-16) with customizable controls
  /// - Parents can configure specific permissions
  /// - Moderate notifications
  /// - Age-appropriate content filtering
  /// - Supervised communication
  custom,

  /// Free mode with minimal restrictions (16+ only)
  /// - Minimal parental oversight
  /// - Only safety and emergency notifications
  /// - Standard content filtering
  /// - Full communication capabilities
  /// - Can toggle per parent if multiple parents exist
  free,
}

extension SupervisionLevelExtension on SupervisionLevel {
  /// Get the minimum age required for this supervision level
  int get minimumAge {
    switch (this) {
      case SupervisionLevel.full:
        return 0; // No minimum age
      case SupervisionLevel.custom:
        return 8; // Typically for older children
      case SupervisionLevel.free:
        return 16; // Teens only
    }
  }

  /// Get the default supervision level based on child age
  static SupervisionLevel getDefaultForAge(int age) {
    if (age < 10) {
      return SupervisionLevel.full;
    } else if (age < 16) {
      return SupervisionLevel.custom;
    } else {
      return SupervisionLevel.custom; // Parent can choose to enable free mode
    }
  }

  /// Check if this level allows transitioning to another level
  bool canTransitionTo(SupervisionLevel newLevel, int childAge) {
    // Can always become more restrictive
    if (newLevel.index < index) return true;
    
    // Check age requirements for less restrictive levels
    return childAge >= newLevel.minimumAge;
  }

  /// Get a description of what this supervision level includes
  String get description {
    switch (this) {
      case SupervisionLevel.full:
        return 'Complete oversight with all activities monitored and most features requiring approval. Best for younger children.';
      case SupervisionLevel.custom:
        return 'Customizable restrictions that you can adjust based on your child\'s maturity and your family\'s needs.';
      case SupervisionLevel.free:
        return 'Minimal oversight with only safety notifications. Your teen manages their own activities with basic safety guardrails.';
    }
  }

  /// Get the primary color associated with this supervision level
  String get colorHex {
    switch (this) {
      case SupervisionLevel.full:
        return '#E53E3E'; // Red
      case SupervisionLevel.custom:
        return '#ED8936'; // Orange
      case SupervisionLevel.free:
        return '#38A169'; // Green
    }
  }

  /// Get typical permissions for this supervision level
  List<String> get typicalPermissions {
    switch (this) {
      case SupervisionLevel.full:
        return [
          'App usage tracking',
          'Content approval required',
          'Communication monitoring',
          'Location sharing',
          'Screen time limits',
          'Real-time notifications',
        ];
      case SupervisionLevel.custom:
        return [
          'Configurable app permissions',
          'Age-appropriate content filtering',
          'Supervised communication',
          'Optional location sharing',
          'Flexible screen time',
          'Selected notifications',
        ];
      case SupervisionLevel.free:
        return [
          'Independent app usage',
          'Standard content filtering',
          'Private communication',
          'Optional location sharing',
          'Self-managed screen time',
          'Safety notifications only',
        ];
    }
  }

  /// Get recommended notification settings for this level
  Map<String, bool> get recommendedNotifications {
    switch (this) {
      case SupervisionLevel.full:
        return {
          'appUsage': true,
          'playtimeStart': true,
          'newFriends': true,
          'contentCreation': true,
          'inAppPurchases': true,
          'locationChange': true,
          'communication': true,
          'safetyAlerts': true,
          'dailyReports': true,
          'weeklyReports': true,
        };
      case SupervisionLevel.custom:
        return {
          'appUsage': false,
          'playtimeStart': true,
          'newFriends': true,
          'contentCreation': false,
          'inAppPurchases': true,
          'locationChange': true,
          'communication': false,
          'safetyAlerts': true,
          'dailyReports': false,
          'weeklyReports': true,
        };
      case SupervisionLevel.free:
        return {
          'appUsage': false,
          'playtimeStart': false,
          'newFriends': false,
          'contentCreation': false,
          'inAppPurchases': false,
          'locationChange': false,
          'communication': false,
          'safetyAlerts': true,
          'dailyReports': false,
          'weeklyReports': false,
        };
    }
  }
}