// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaytimeSettings _$PlaytimeSettingsFromJson(Map<String, dynamic> json) =>
    PlaytimeSettings(
      isChild: json['isChild'] as bool,
      parentUid: json['parentUid'] as String?,
      approvedPlaytimeSessions:
          (json['approvedPlaytimeSessions'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      playtimePreferences: PlaytimePreferences.fromJson(
          json['playtimePreferences'] as Map<String, dynamic>),
      safetySettings: SafetySettings.fromJson(
          json['safetySettings'] as Map<String, dynamic>),
      usageStats:
          UsageStats.fromJson(json['usageStats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaytimeSettingsToJson(PlaytimeSettings instance) =>
    <String, dynamic>{
      'isChild': instance.isChild,
      'parentUid': instance.parentUid,
      'approvedPlaytimeSessions': instance.approvedPlaytimeSessions,
      'playtimePreferences': instance.playtimePreferences.toJson(),
      'safetySettings': instance.safetySettings.toJson(),
      'usageStats': instance.usageStats.toJson(),
    };

PlaytimePreferences _$PlaytimePreferencesFromJson(Map<String, dynamic> json) =>
    PlaytimePreferences(
      favoriteGames: (json['favoriteGames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      preferredCategories: (json['preferredCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      maxSessionDuration: (json['maxSessionDuration'] as num).toInt(),
      allowPublicSessions: json['allowPublicSessions'] as bool,
      allowFriendInvites: json['allowFriendInvites'] as bool,
    );

Map<String, dynamic> _$PlaytimePreferencesToJson(
        PlaytimePreferences instance) =>
    <String, dynamic>{
      'favoriteGames': instance.favoriteGames,
      'preferredCategories': instance.preferredCategories,
      'maxSessionDuration': instance.maxSessionDuration,
      'allowPublicSessions': instance.allowPublicSessions,
      'allowFriendInvites': instance.allowFriendInvites,
    };

SafetySettings _$SafetySettingsFromJson(Map<String, dynamic> json) =>
    SafetySettings(
      chatEnabled: json['chatEnabled'] as bool,
      autoApproveSessions: json['autoApproveSessions'] as bool,
      requireParentApproval: json['requireParentApproval'] as bool,
      blockedUsers: (json['blockedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      restrictedContent: (json['restrictedContent'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SafetySettingsToJson(SafetySettings instance) =>
    <String, dynamic>{
      'chatEnabled': instance.chatEnabled,
      'autoApproveSessions': instance.autoApproveSessions,
      'requireParentApproval': instance.requireParentApproval,
      'blockedUsers': instance.blockedUsers,
      'restrictedContent': instance.restrictedContent,
    };

UsageStats _$UsageStatsFromJson(Map<String, dynamic> json) => UsageStats(
      totalSessions: (json['totalSessions'] as num).toInt(),
      totalPlaytime: (json['totalPlaytime'] as num).toInt(),
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
      favoriteBackgrounds: (json['favoriteBackgrounds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UsageStatsToJson(UsageStats instance) =>
    <String, dynamic>{
      'totalSessions': instance.totalSessions,
      'totalPlaytime': instance.totalPlaytime,
      'lastActive': instance.lastActive?.toIso8601String(),
      'favoriteBackgrounds': instance.favoriteBackgrounds,
    };

PlaytimePermissions _$PlaytimePermissionsFromJson(Map<String, dynamic> json) =>
    PlaytimePermissions(
      canCreateSessions: json['canCreateSessions'] as bool,
      canUploadContent: json['canUploadContent'] as bool,
      canInviteFriends: json['canInviteFriends'] as bool,
      canJoinPublicSessions: json['canJoinPublicSessions'] as bool,
      requiresParentApproval: json['requiresParentApproval'] as bool,
    );

Map<String, dynamic> _$PlaytimePermissionsToJson(
        PlaytimePermissions instance) =>
    <String, dynamic>{
      'canCreateSessions': instance.canCreateSessions,
      'canUploadContent': instance.canUploadContent,
      'canInviteFriends': instance.canInviteFriends,
      'canJoinPublicSessions': instance.canJoinPublicSessions,
      'requiresParentApproval': instance.requiresParentApproval,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isAdminFreeAccess: json['isAdminFreeAccess'] as bool?,
      playtimeSettings: json['playtimeSettings'] == null
          ? null
          : PlaytimeSettings.fromJson(
              json['playtimeSettings'] as Map<String, dynamic>),
      playtimePermissions: json['playtimePermissions'] == null
          ? null
          : PlaytimePermissions.fromJson(
              json['playtimePermissions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'photoUrl': instance.photoUrl,
      'isAdminFreeAccess': instance.isAdminFreeAccess,
      'playtimeSettings': instance.playtimeSettings?.toJson(),
      'playtimePermissions': instance.playtimePermissions?.toJson(),
    };
