import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    String? email,
    String? phone,
    String? photoUrl,
    bool? isAdminFreeAccess,
    // Playtime-specific fields
    PlaytimeSettings? playtimeSettings,
    PlaytimePermissions? playtimePermissions,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@JsonSerializable()
class PlaytimeSettings {
  final bool isChild;
  final String? parentUid;
  final List<String> approvedPlaytimeSessions;
  final PlaytimePreferences playtimePreferences;
  final SafetySettings safetySettings;
  final UsageStats usageStats;

  PlaytimeSettings({
    required this.isChild,
    this.parentUid,
    required this.approvedPlaytimeSessions,
    required this.playtimePreferences,
    required this.safetySettings,
    required this.usageStats,
  });

  factory PlaytimeSettings.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PlaytimeSettingsToJson(this);
}

@JsonSerializable()
class PlaytimePreferences {
  final List<String> favoriteGames;
  final List<String> preferredCategories;
  final int maxSessionDuration;
  final bool allowPublicSessions;
  final bool allowFriendInvites;

  PlaytimePreferences({
    required this.favoriteGames,
    required this.preferredCategories,
    required this.maxSessionDuration,
    required this.allowPublicSessions,
    required this.allowFriendInvites,
  });

  factory PlaytimePreferences.fromJson(Map<String, dynamic> json) =>
      _$PlaytimePreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PlaytimePreferencesToJson(this);
}

@JsonSerializable()
class SafetySettings {
  final bool chatEnabled;
  final bool autoApproveSessions;
  final bool requireParentApproval;
  final List<String> blockedUsers;
  final List<String> restrictedContent;

  SafetySettings({
    required this.chatEnabled,
    required this.autoApproveSessions,
    required this.requireParentApproval,
    required this.blockedUsers,
    required this.restrictedContent,
  });

  factory SafetySettings.fromJson(Map<String, dynamic> json) =>
      _$SafetySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SafetySettingsToJson(this);
}

@JsonSerializable()
class UsageStats {
  final int totalSessions;
  final int totalPlaytime;
  final DateTime? lastActive;
  final List<String> favoriteBackgrounds;

  UsageStats({
    required this.totalSessions,
    required this.totalPlaytime,
    this.lastActive,
    required this.favoriteBackgrounds,
  });

  factory UsageStats.fromJson(Map<String, dynamic> json) =>
      _$UsageStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UsageStatsToJson(this);
}

@JsonSerializable()
class PlaytimePermissions {
  final bool canCreateSessions;
  final bool canUploadContent;
  final bool canInviteFriends;
  final bool canJoinPublicSessions;
  final bool requiresParentApproval;

  PlaytimePermissions({
    required this.canCreateSessions,
    required this.canUploadContent,
    required this.canInviteFriends,
    required this.canJoinPublicSessions,
    required this.requiresParentApproval,
  });

  factory PlaytimePermissions.fromJson(Map<String, dynamic> json) =>
      _$PlaytimePermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PlaytimePermissionsToJson(this);
}
