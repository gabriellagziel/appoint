import 'package:cloud_firestore/cloud_firestore.dart';

class PlaytimeSession {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // in minutes
  final String activityType;
  final String platform;
  final bool isActive;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlaytimeSession({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.duration = 0,
    required this.activityType,
    required this.platform,
    this.isActive = true,
    this.metadata = const {},
    this.createdAt,
    this.updatedAt,
  });

  factory PlaytimeSession.fromJson(Map<String, dynamic> json) {
    return PlaytimeSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: json['endTime'] != null ? (json['endTime'] as Timestamp).toDate() : null,
      duration: json['duration'] as int? ?? 0,
      activityType: json['activityType'] as String,
      platform: json['platform'] as String,
      isActive: json['isActive'] as bool? ?? true,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
      updatedAt: json['updatedAt'] != null ? (json['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'duration': duration,
      'activityType': activityType,
      'platform': platform,
      'isActive': isActive,
      'metadata': metadata,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  PlaytimeSession copyWith({
    String? id,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? activityType,
    String? platform,
    bool? isActive,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlaytimeSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      activityType: activityType ?? this.activityType,
      platform: platform ?? this.platform,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Calculate session duration if session is active
  int get actualDuration {
    if (endTime != null) {
      return duration;
    } else if (isActive) {
      return DateTime.now().difference(startTime).inMinutes;
    } else {
      return duration;
    }
  }

  /// Check if session is currently running
  bool get isCurrentlyActive {
    return isActive && endTime == null;
  }

  /// Get session duration as formatted string
  String get durationFormatted {
    final totalMinutes = actualDuration;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get activity type display name
  String get activityTypeDisplayName {
    switch (activityType) {
      case 'general':
        return 'General Play';
      case 'educational':
        return 'Educational';
      case 'creative':
        return 'Creative';
      case 'social':
        return 'Social';
      case 'physical':
        return 'Physical Activity';
      case 'reading':
        return 'Reading';
      case 'puzzle':
        return 'Puzzles & Games';
      case 'music':
        return 'Music';
      case 'video':
        return 'Video Content';
      default:
        return activityType.replaceAll('_', ' ').split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  /// Get platform display name
  String get platformDisplayName {
    switch (platform.toLowerCase()) {
      case 'android':
        return 'Android';
      case 'ios':
        return 'iOS';
      case 'web':
        return 'Web Browser';
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return platform;
    }
  }

  /// Check if session exceeds recommended duration for age
  bool exceedsRecommendedDuration(int userAge) {
    final recommendedMinutes = getRecommendedDurationForAge(userAge);
    return actualDuration > recommendedMinutes;
  }

  /// Get recommended session duration based on age
  static int getRecommendedDurationForAge(int age) {
    if (age < 6) {
      return 30; // 30 minutes for very young children
    } else if (age < 10) {
      return 60; // 1 hour for children
    } else if (age < 13) {
      return 90; // 1.5 hours for tweens
    } else if (age < 16) {
      return 120; // 2 hours for teens
    } else {
      return 180; // 3 hours for older teens (though less restricted)
    }
  }

  /// Get activity type color for UI display
  static String getActivityTypeColor(String activityType) {
    switch (activityType) {
      case 'educational':
        return '#4CAF50'; // Green
      case 'creative':
        return '#FF9800'; // Orange
      case 'social':
        return '#2196F3'; // Blue
      case 'physical':
        return '#F44336'; // Red
      case 'reading':
        return '#9C27B0'; // Purple
      case 'puzzle':
        return '#607D8B'; // Blue Grey
      case 'music':
        return '#E91E63'; // Pink
      case 'video':
        return '#795548'; // Brown
      default:
        return '#757575'; // Grey
    }
  }

  /// Get all available activity types
  static List<String> get availableActivityTypes => [
    'general',
    'educational',
    'creative',
    'social',
    'physical',
    'reading',
    'puzzle',
    'music',
    'video',
  ];

  /// Check if session data is valid
  bool get isValid {
    return id.isNotEmpty &&
           userId.isNotEmpty &&
           activityType.isNotEmpty &&
           platform.isNotEmpty &&
           duration >= 0 &&
           (endTime == null || endTime!.isAfter(startTime));
  }

  @override
  String toString() {
    return 'PlaytimeSession(id: $id, userId: $userId, duration: ${durationFormatted}, activityType: $activityType, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaytimeSession &&
           other.id == id &&
           other.userId == userId &&
           other.startTime == startTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ startTime.hashCode;
  }
}
