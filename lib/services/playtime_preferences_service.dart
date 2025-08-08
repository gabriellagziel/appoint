import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for managing parent and user preferences for playtime sessions
class PlaytimePreferencesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get parent preferences for a given parent ID
  static Future<PlaytimePreferences?> getParentPreferences(
      String parentId) async {
    try {
      final doc = await _firestore
          .collection('playtime_preferences')
          .doc(parentId)
          .get();

      if (doc.exists && doc.data() != null) {
        return PlaytimePreferences.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching parent preferences: $e');
      return null;
    }
  }

  /// Update parent preferences
  static Future<void> updateParentPreferences(
    String parentId,
    PlaytimePreferences preferences,
  ) async {
    try {
      await _firestore
          .collection('playtime_preferences')
          .doc(parentId)
          .set(preferences.toJson());
    } catch (e) {
      print('Error updating parent preferences: $e');
      rethrow;
    }
  }

  /// Check if a parent allows age restriction override
  static Future<bool> allowsAgeRestrictionOverride(String parentId) async {
    final preferences = await getParentPreferences(parentId);
    return preferences?.allowOverrideAgeRestriction ?? false;
  }

  /// Check if a game is blocked by parent preferences
  static Future<bool> isGameBlocked(String parentId, String gameId) async {
    final preferences = await getParentPreferences(parentId);
    return preferences?.blockedGames.contains(gameId) ?? false;
  }

  /// Check if a platform is allowed by parent preferences
  static Future<bool> isPlatformAllowed(
      String parentId, String platform) async {
    final preferences = await getParentPreferences(parentId);
    return preferences?.allowedPlatforms.contains(platform) ?? true;
  }

  /// Create default preferences for a new parent
  static Future<void> createDefaultPreferences(String parentId) async {
    final defaultPrefs = PlaytimePreferences(
      parentId: parentId,
      allowOverrideAgeRestriction: false,
      blockedGames: [],
      allowedPlatforms: ['PC', 'Console', 'Mobile'],
      maxSessionDuration: 120, // 2 hours
      allowVirtualSessions: true,
      allowPhysicalSessions: true,
      requirePreApproval: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await updateParentPreferences(parentId, defaultPrefs);
  }
}

/// Model for playtime preferences
class PlaytimePreferences {
  final String parentId;
  final bool allowOverrideAgeRestriction;
  final List<String> blockedGames;
  final List<String> allowedPlatforms;
  final int maxSessionDuration; // in minutes
  final bool allowVirtualSessions;
  final bool allowPhysicalSessions;
  final bool requirePreApproval;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlaytimePreferences({
    required this.parentId,
    required this.allowOverrideAgeRestriction,
    required this.blockedGames,
    required this.allowedPlatforms,
    required this.maxSessionDuration,
    required this.allowVirtualSessions,
    required this.allowPhysicalSessions,
    required this.requirePreApproval,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlaytimePreferences.fromJson(Map<String, dynamic> json) {
    return PlaytimePreferences(
      parentId: json['parentId'] ?? '',
      allowOverrideAgeRestriction: json['allowOverrideAgeRestriction'] ?? false,
      blockedGames: List<String>.from(json['blockedGames'] ?? []),
      allowedPlatforms: List<String>.from(
          json['allowedPlatforms'] ?? ['PC', 'Console', 'Mobile']),
      maxSessionDuration: json['maxSessionDuration'] ?? 120,
      allowVirtualSessions: json['allowVirtualSessions'] ?? true,
      allowPhysicalSessions: json['allowPhysicalSessions'] ?? true,
      requirePreApproval: json['requirePreApproval'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parentId': parentId,
      'allowOverrideAgeRestriction': allowOverrideAgeRestriction,
      'blockedGames': blockedGames,
      'allowedPlatforms': allowedPlatforms,
      'maxSessionDuration': maxSessionDuration,
      'allowVirtualSessions': allowVirtualSessions,
      'allowPhysicalSessions': allowPhysicalSessions,
      'requirePreApproval': requirePreApproval,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PlaytimePreferences copyWith({
    String? parentId,
    bool? allowOverrideAgeRestriction,
    List<String>? blockedGames,
    List<String>? allowedPlatforms,
    int? maxSessionDuration,
    bool? allowVirtualSessions,
    bool? allowPhysicalSessions,
    bool? requirePreApproval,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlaytimePreferences(
      parentId: parentId ?? this.parentId,
      allowOverrideAgeRestriction:
          allowOverrideAgeRestriction ?? this.allowOverrideAgeRestriction,
      blockedGames: blockedGames ?? this.blockedGames,
      allowedPlatforms: allowedPlatforms ?? this.allowedPlatforms,
      maxSessionDuration: maxSessionDuration ?? this.maxSessionDuration,
      allowVirtualSessions: allowVirtualSessions ?? this.allowVirtualSessions,
      allowPhysicalSessions:
          allowPhysicalSessions ?? this.allowPhysicalSessions,
      requirePreApproval: requirePreApproval ?? this.requirePreApproval,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
