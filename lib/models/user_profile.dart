import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.isAdminFreeAccess,
    this.businessMode = false,
    this.businessProfileId,
    this.playtimeSettings,
    this.playtimePermissions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final bool? isAdminFreeAccess;
  // Business mode fields
  final bool businessMode;
  final String? businessProfileId;
  // Playtime-specific fields
  final PlaytimeSettings? playtimeSettings;
  final PlaytimePermissions? playtimePermissions;

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    bool? isAdminFreeAccess,
    bool? businessMode,
    String? businessProfileId,
    PlaytimeSettings? playtimeSettings,
    PlaytimePermissions? playtimePermissions,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      isAdminFreeAccess: isAdminFreeAccess ?? this.isAdminFreeAccess,
      businessMode: businessMode ?? this.businessMode,
      businessProfileId: businessProfileId ?? this.businessProfileId,
      playtimeSettings: playtimeSettings ?? this.playtimeSettings,
      playtimePermissions: playtimePermissions ?? this.playtimePermissions,
    );
  }
}

@JsonSerializable()
class PlaytimeSettings {

  PlaytimeSettings({
    required this.isChild,
    required this.approvedPlaytimeSessions, required this.playtimePreferences, required this.safetySettings, required this.usageStats, this.parentUid,
  });

  factory PlaytimeSettings.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeSettingsFromJson(json);
  final bool isChild;
  final String? parentUid;
  final List<String> approvedPlaytimeSessions;
  final PlaytimePreferences playtimePreferences;
  final SafetySettings safetySettings;
  final UsageStats usageStats;

  Map<String, dynamic> toJson() => _$PlaytimeSettingsToJson(this);
}

@JsonSerializable()
class PlaytimePreferences {

  PlaytimePreferences({
    required this.favoriteGames,
    required this.preferredCategories,
    required this.maxSessionDuration,
    required this.allowPublicSessions,
    required this.allowFriendInvites,
  });

  factory PlaytimePreferences.fromJson(Map<String, dynamic> json) =>
      _$PlaytimePreferencesFromJson(json);
  final List<String> favoriteGames;
  final List<String> preferredCategories;
  final int maxSessionDuration;
  final bool allowPublicSessions;
  final bool allowFriendInvites;

  Map<String, dynamic> toJson() => _$PlaytimePreferencesToJson(this);
}

@JsonSerializable()
class SafetySettings {

  SafetySettings({
    required this.chatEnabled,
    required this.autoApproveSessions,
    required this.requireParentApproval,
    required this.blockedUsers,
    required this.restrictedContent,
  });

  factory SafetySettings.fromJson(Map<String, dynamic> json) =>
      _$SafetySettingsFromJson(json);
  final bool chatEnabled;
  final bool autoApproveSessions;
  final bool requireParentApproval;
  final List<String> blockedUsers;
  final List<String> restrictedContent;

  Map<String, dynamic> toJson() => _$SafetySettingsToJson(this);
}

@JsonSerializable()
class UsageStats {

  UsageStats({
    required this.totalSessions,
    required this.totalPlaytime,
    required this.favoriteBackgrounds, this.lastActive,
  });

  factory UsageStats.fromJson(Map<String, dynamic> json) =>
      _$UsageStatsFromJson(json);
  final int totalSessions;
  final int totalPlaytime;
  final DateTime? lastActive;
  final List<String> favoriteBackgrounds;

  Map<String, dynamic> toJson() => _$UsageStatsToJson(this);
}

@JsonSerializable()
class PlaytimePermissions {

  PlaytimePermissions({
    required this.canCreateSessions,
    required this.canUploadContent,
    required this.canInviteFriends,
    required this.canJoinPublicSessions,
    required this.requiresParentApproval,
  });

  factory PlaytimePermissions.fromJson(Map<String, dynamic> json) =>
      _$PlaytimePermissionsFromJson(json);
  final bool canCreateSessions;
  final bool canUploadContent;
  final bool canInviteFriends;
  final bool canJoinPublicSessions;
  final bool requiresParentApproval;

  Map<String, dynamic> toJson() => _$PlaytimePermissionsToJson(this);
}
