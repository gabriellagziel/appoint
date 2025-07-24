import 'package:cloud_firestore/cloud_firestore.dart';

enum UsageLimitType {
  daily,
  weekly,
  monthly,
  perSession,
}

enum UsageLimitScope {
  all, // All activities
  specific, // Specific activity type
  educational, // Educational content only
  entertainment, // Entertainment content only
}

class UsageLimit {
  final String id;
  final String userId;
  final String type; // 'daily', 'weekly', 'monthly', 'per_session'
  final String scope; // 'all', 'educational', 'entertainment', specific activity type
  final int limitMinutes;
  final bool isActive;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final Map<String, dynamic> settings; // Additional settings like break reminders
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy; // Parent ID who set this limit

  const UsageLimit({
    required this.id,
    required this.userId,
    required this.type,
    required this.scope,
    required this.limitMinutes,
    this.isActive = true,
    this.validFrom,
    this.validUntil,
    this.settings = const {},
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  });

  factory UsageLimit.fromJson(Map<String, dynamic> json) {
    return UsageLimit(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      scope: json['scope'] as String,
      limitMinutes: json['limitMinutes'] as int,
      isActive: json['isActive'] as bool? ?? true,
      validFrom: json['validFrom'] != null ? (json['validFrom'] as Timestamp).toDate() : null,
      validUntil: json['validUntil'] != null ? (json['validUntil'] as Timestamp).toDate() : null,
      settings: Map<String, dynamic>.from(json['settings'] as Map? ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      createdBy: json['createdBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'scope': scope,
      'limitMinutes': limitMinutes,
      'isActive': isActive,
      'validFrom': validFrom != null ? Timestamp.fromDate(validFrom!) : null,
      'validUntil': validUntil != null ? Timestamp.fromDate(validUntil!) : null,
      'settings': settings,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };
  }

  UsageLimit copyWith({
    String? id,
    String? userId,
    String? type,
    String? scope,
    int? limitMinutes,
    bool? isActive,
    DateTime? validFrom,
    DateTime? validUntil,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return UsageLimit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      limitMinutes: limitMinutes ?? this.limitMinutes,
      isActive: isActive ?? this.isActive,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  /// Check if this limit is currently valid
  bool get isCurrentlyValid {
    if (!isActive) return false;
    
    final now = DateTime.now();
    
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validUntil != null && now.isAfter(validUntil!)) return false;
    
    return true;
  }

  /// Get formatted limit description
  String get description {
    final limitHours = limitMinutes ~/ 60;
    final remainingMinutes = limitMinutes % 60;
    
    String timeString;
    if (limitHours > 0 && remainingMinutes > 0) {
      timeString = '${limitHours}h ${remainingMinutes}m';
    } else if (limitHours > 0) {
      timeString = '${limitHours}h';
    } else {
      timeString = '${limitMinutes}m';
    }
    
    String scopeString = _getScopeDisplayName();
    String typeString = _getTypeDisplayName();
    
    return '$timeString $scopeString per $typeString';
  }

  /// Get type display name
  String _getTypeDisplayName() {
    switch (type) {
      case 'daily':
        return 'day';
      case 'weekly':
        return 'week';
      case 'monthly':
        return 'month';
      case 'per_session':
        return 'session';
      default:
        return type;
    }
  }

  /// Get scope display name
  String _getScopeDisplayName() {
    switch (scope) {
      case 'all':
        return 'playtime';
      case 'educational':
        return 'educational content';
      case 'entertainment':
        return 'entertainment';
      case 'social':
        return 'social activities';
      case 'creative':
        return 'creative activities';
      case 'physical':
        return 'physical activities';
      default:
        return scope.replaceAll('_', ' ');
    }
  }

  /// Check if this limit applies to a specific activity type
  bool appliesToActivity(String activityType) {
    switch (scope) {
      case 'all':
        return true;
      case 'educational':
        return _isEducationalActivity(activityType);
      case 'entertainment':
        return _isEntertainmentActivity(activityType);
      default:
        return scope == activityType;
    }
  }

  bool _isEducationalActivity(String activityType) {
    return ['educational', 'reading', 'puzzle'].contains(activityType);
  }

  bool _isEntertainmentActivity(String activityType) {
    return ['general', 'video', 'music', 'social'].contains(activityType);
  }

  /// Get recommended limits based on age
  static List<UsageLimit> getRecommendedLimitsForAge(String userId, int age) {
    final now = DateTime.now();
    final limits = <UsageLimit>[];
    
    if (age < 6) {
      // Very young children - 30 minutes daily, 15 minutes per session
      limits.addAll([
        UsageLimit(
          id: 'daily_${userId}_${now.millisecondsSinceEpoch}',
          userId: userId,
          type: 'daily',
          scope: 'all',
          limitMinutes: 30,
          createdAt: now,
          updatedAt: now,
          settings: {
            'breakReminder': true,
            'breakInterval': 15,
            'parentNotification': true,
          },
        ),
        UsageLimit(
          id: 'session_${userId}_${now.millisecondsSinceEpoch}',
          userId: userId,
          type: 'per_session',
          scope: 'all',
          limitMinutes: 15,
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    } else if (age < 10) {
      // Children - 1 hour daily, 30 minutes per session
      limits.addAll([
        UsageLimit(
          id: 'daily_${userId}_${now.millisecondsSinceEpoch}',
          userId: userId,
          type: 'daily',
          scope: 'all',
          limitMinutes: 60,
          createdAt: now,
          updatedAt: now,
          settings: {
            'breakReminder': true,
            'breakInterval': 20,
            'parentNotification': true,
          },
        ),
        UsageLimit(
          id: 'session_${userId}_${now.millisecondsSinceEpoch}',
          userId: userId,
          type: 'per_session',
          scope: 'entertainment',
          limitMinutes: 30,
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    } else if (age < 13) {
      // Tweens - 1.5 hours daily, unlimited educational
      limits.addAll([
        UsageLimit(
          id: 'daily_entertainment_${userId}_${now.millisecondsSinceEpoch}',
          userId: userId,
          type: 'daily',
          scope: 'entertainment',
          limitMinutes: 90,
          createdAt: now,
          updatedAt: now,
          settings: {
            'breakReminder': true,
            'breakInterval': 30,
            'parentNotification': false,
          },
        ),
        UsageLimit(
          id: 'session_${userId}_${now.millisecondsSinceEpoch}',
          userId: userId,
          type: 'per_session',
          scope: 'entertainment',
          limitMinutes: 45,
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    } else if (age < 16) {
      // Teens - 2 hours daily entertainment, flexible sessions
      limits.add(
        UsageLimit(
          id: 'daily_entertainment_${userId}_${now.millisecondsSinceEpoch}',
          userId: userId,
          type: 'daily',
          scope: 'entertainment',
          limitMinutes: 120,
          createdAt: now,
          updatedAt: now,
          settings: {
            'breakReminder': false,
            'parentNotification': false,
          },
        ),
      );
    }
    // 16+ typically has no default limits (free mode available)
    
    return limits;
  }

  /// Check if break reminder should be shown
  bool shouldShowBreakReminder(int sessionMinutes) {
    final breakInterval = settings['breakInterval'] as int?;
    if (breakInterval == null || !(settings['breakReminder'] as bool? ?? false)) {
      return false;
    }
    
    return sessionMinutes > 0 && sessionMinutes % breakInterval == 0;
  }

  /// Check if parent should be notified
  bool get shouldNotifyParent {
    return settings['parentNotification'] as bool? ?? false;
  }

  /// Get time until limit resets
  Duration? getTimeUntilReset() {
    final now = DateTime.now();
    
    switch (type) {
      case 'daily':
        final tomorrow = DateTime(now.year, now.month, now.day + 1);
        return tomorrow.difference(now);
      case 'weekly':
        final nextWeek = now.add(Duration(days: 7 - now.weekday));
        final nextWeekStart = DateTime(nextWeek.year, nextWeek.month, nextWeek.day);
        return nextWeekStart.difference(now);
      case 'monthly':
        final nextMonth = DateTime(now.year, now.month + 1);
        return nextMonth.difference(now);
      case 'per_session':
        return null; // Session limits don't reset on time
      default:
        return null;
    }
  }

  /// Get warning threshold (when to warn user about approaching limit)
  int get warningThresholdMinutes {
    // Warn when 15 minutes left, or 25% of limit remaining, whichever is smaller
    return (limitMinutes * 0.25).round().clamp(5, 15);
  }

  /// Check if usage is approaching the limit
  bool isApproachingLimit(int currentUsage) {
    return (limitMinutes - currentUsage) <= warningThresholdMinutes;
  }

  /// Check if limit is exceeded
  bool isExceeded(int currentUsage) {
    return currentUsage >= limitMinutes;
  }

  /// Get remaining time in minutes
  int getRemainingTime(int currentUsage) {
    return (limitMinutes - currentUsage).clamp(0, limitMinutes);
  }

  /// Get usage percentage
  double getUsagePercentage(int currentUsage) {
    if (limitMinutes == 0) return 0.0;
    return (currentUsage / limitMinutes).clamp(0.0, 1.0);
  }

  @override
  String toString() {
    return 'UsageLimit(id: $id, type: $type, scope: $scope, limit: ${limitMinutes}m, active: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsageLimit &&
           other.id == id &&
           other.userId == userId &&
           other.type == type &&
           other.scope == scope;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ type.hashCode ^ scope.hashCode;
  }
}