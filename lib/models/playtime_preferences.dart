import 'package:flutter/material.dart';

/// Playtime preferences for parental controls and age restrictions
class PlaytimePreferences {
  final String userId;
  final bool allowOverrideAgeRestriction;
  final List<String> approvedGames;
  final List<String> blockedGames;
  final Map<String, bool> categoryRestrictions;
  final int? maxDailyPlaytime; // minutes
  final int? maxSessionDuration; // minutes
  final List<TimeRange> allowedPlaytimes;
  final bool requireApprovalForNewGames;
  final bool allowVirtualGames;
  final bool allowLiveGames;
  final String safetyLevel; // permissive, moderate, strict
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlaytimePreferences({
    required this.userId,
    this.allowOverrideAgeRestriction = false,
    this.approvedGames = const [],
    this.blockedGames = const [],
    this.categoryRestrictions = const {},
    this.maxDailyPlaytime,
    this.maxSessionDuration,
    this.allowedPlaytimes = const [],
    this.requireApprovalForNewGames = true,
    this.allowVirtualGames = true,
    this.allowLiveGames = false,
    this.safetyLevel = 'moderate',
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlaytimePreferences.fromJson(Map<String, dynamic> json) {
    return PlaytimePreferences(
      userId: json['userId'] as String,
      allowOverrideAgeRestriction: json['allowOverrideAgeRestriction'] as bool? ?? false,
      approvedGames: List<String>.from(json['approvedGames'] as List? ?? []),
      blockedGames: List<String>.from(json['blockedGames'] as List? ?? []),
      categoryRestrictions: Map<String, bool>.from(json['categoryRestrictions'] as Map? ?? {}),
      maxDailyPlaytime: json['maxDailyPlaytime'] as int?,
      maxSessionDuration: json['maxSessionDuration'] as int?,
      allowedPlaytimes: (json['allowedPlaytimes'] as List? ?? [])
          .map((item) => TimeRange.fromJson(item as Map<String, dynamic>))
          .toList(),
      requireApprovalForNewGames: json['requireApprovalForNewGames'] as bool? ?? true,
      allowVirtualGames: json['allowVirtualGames'] as bool? ?? true,
      allowLiveGames: json['allowLiveGames'] as bool? ?? false,
      safetyLevel: json['safetyLevel'] as String? ?? 'moderate',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'allowOverrideAgeRestriction': allowOverrideAgeRestriction,
    'approvedGames': approvedGames,
    'blockedGames': blockedGames,
    'categoryRestrictions': categoryRestrictions,
    'maxDailyPlaytime': maxDailyPlaytime,
    'maxSessionDuration': maxSessionDuration,
    'allowedPlaytimes': allowedPlaytimes.map((range) => range.toJson()).toList(),
    'requireApprovalForNewGames': requireApprovalForNewGames,
    'allowVirtualGames': allowVirtualGames,
    'allowLiveGames': allowLiveGames,
    'safetyLevel': safetyLevel,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  PlaytimePreferences copyWith({
    String? userId,
    bool? allowOverrideAgeRestriction,
    List<String>? approvedGames,
    List<String>? blockedGames,
    Map<String, bool>? categoryRestrictions,
    int? maxDailyPlaytime,
    int? maxSessionDuration,
    List<TimeRange>? allowedPlaytimes,
    bool? requireApprovalForNewGames,
    bool? allowVirtualGames,
    bool? allowLiveGames,
    String? safetyLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlaytimePreferences(
      userId: userId ?? this.userId,
      allowOverrideAgeRestriction: allowOverrideAgeRestriction ?? this.allowOverrideAgeRestriction,
      approvedGames: approvedGames ?? this.approvedGames,
      blockedGames: blockedGames ?? this.blockedGames,
      categoryRestrictions: categoryRestrictions ?? this.categoryRestrictions,
      maxDailyPlaytime: maxDailyPlaytime ?? this.maxDailyPlaytime,
      maxSessionDuration: maxSessionDuration ?? this.maxSessionDuration,
      allowedPlaytimes: allowedPlaytimes ?? this.allowedPlaytimes,
      requireApprovalForNewGames: requireApprovalForNewGames ?? this.requireApprovalForNewGames,
      allowVirtualGames: allowVirtualGames ?? this.allowVirtualGames,
      allowLiveGames: allowLiveGames ?? this.allowLiveGames,
      safetyLevel: safetyLevel ?? this.safetyLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if a specific game is approved
  bool isGameApproved(String gameId) {
    if (blockedGames.contains(gameId)) return false;
    if (approvedGames.contains(gameId)) return true;
    return !requireApprovalForNewGames;
  }

  /// Check if a game category is allowed
  bool isCategoryAllowed(String category) {
    return categoryRestrictions[category] ?? true;
  }

  /// Check if playtime is within allowed hours
  bool isPlaytimeAllowed([DateTime? dateTime]) {
    if (allowedPlaytimes.isEmpty) return true;
    
    final now = dateTime ?? DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    
    return allowedPlaytimes.any((range) => range.contains(currentTime));
  }

  /// Get default preferences for a child
  factory PlaytimePreferences.defaultForChild(String userId) {
    return PlaytimePreferences(
      userId: userId,
      allowOverrideAgeRestriction: false,
      maxDailyPlaytime: 120, // 2 hours
      maxSessionDuration: 60, // 1 hour
      allowedPlaytimes: [
        TimeRange(
          start: const TimeOfDay(hour: 15, minute: 0), // 3 PM
          end: const TimeOfDay(hour: 19, minute: 0),   // 7 PM
        ),
      ],
      requireApprovalForNewGames: true,
      allowVirtualGames: true,
      allowLiveGames: false,
      safetyLevel: 'moderate',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get permissive preferences for an adult
  factory PlaytimePreferences.defaultForAdult(String userId) {
    return PlaytimePreferences(
      userId: userId,
      allowOverrideAgeRestriction: true,
      requireApprovalForNewGames: false,
      allowVirtualGames: true,
      allowLiveGames: true,
      safetyLevel: 'permissive',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Time range for allowed playtime hours
class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeRange({
    required this.start,
    required this.end,
  });

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    return TimeRange(
      start: TimeOfDay(
        hour: json['start']['hour'] as int,
        minute: json['start']['minute'] as int,
      ),
      end: TimeOfDay(
        hour: json['end']['hour'] as int,
        minute: json['end']['minute'] as int,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'start': {
      'hour': start.hour,
      'minute': start.minute,
    },
    'end': {
      'hour': end.hour,
      'minute': end.minute,
    },
  };

  /// Check if a given time falls within this range
  bool contains(TimeOfDay time) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final timeMinutes = time.hour * 60 + time.minute;
    
    if (startMinutes <= endMinutes) {
      // Normal range (doesn't cross midnight)
      return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
    } else {
      // Range crosses midnight
      return timeMinutes >= startMinutes || timeMinutes <= endMinutes;
    }
  }

  /// Get duration in minutes
  int get durationMinutes {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    
    if (startMinutes <= endMinutes) {
      return endMinutes - startMinutes;
    } else {
      // Range crosses midnight
      return (24 * 60) - startMinutes + endMinutes;
    }
  }

  @override
  String toString() {
    return '${start.format(null)} - ${end.format(null)}';
  }
}

/// Extension for TimeOfDay formatting
extension TimeOfDayExtension on TimeOfDay {
  String format(BuildContext? context) {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
