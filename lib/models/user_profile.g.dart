// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
      isAdminFreeAccess: json['is_admin_free_access'] as bool?,
      businessMode: json['business_mode'] as bool? ?? false,
      businessProfileId: json['business_profile_id'] as String?,
      playtimeSettings: json['playtime_settings'] == null
          ? null
          : PlaytimeSettings.fromJson(
              json['playtime_settings'] as Map<String, dynamic>),
      playtimePermissions: json['playtime_permissions'] == null
          ? null
          : PlaytimePermissions.fromJson(
              json['playtime_permissions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('phone', instance.phone);
  writeNotNull('photo_url', instance.photoUrl);
  writeNotNull('is_admin_free_access', instance.isAdminFreeAccess);
  val['business_mode'] = instance.businessMode;
  writeNotNull('business_profile_id', instance.businessProfileId);
  writeNotNull('playtime_settings', instance.playtimeSettings);
  writeNotNull('playtime_permissions', instance.playtimePermissions);
  return val;
}

PlaytimeSettings _$PlaytimeSettingsFromJson(Map<String, dynamic> json) =>
    PlaytimeSettings(
      isChild: json['is_child'] as bool,
      approvedPlaytimeSessions:
          (json['approved_playtime_sessions'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      playtimePreferences: PlaytimePreferences.fromJson(
          json['playtime_preferences'] as Map<String, dynamic>),
      safetySettings: SafetySettings.fromJson(
          json['safety_settings'] as Map<String, dynamic>),
      usageStats:
          UsageStats.fromJson(json['usage_stats'] as Map<String, dynamic>),
      parentUid: json['parent_uid'] as String?,
    );

Map<String, dynamic> _$PlaytimeSettingsToJson(PlaytimeSettings instance) {
  final val = <String, dynamic>{
    'is_child': instance.isChild,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('parent_uid', instance.parentUid);
  val['approved_playtime_sessions'] = instance.approvedPlaytimeSessions;
  val['playtime_preferences'] = instance.playtimePreferences;
  val['safety_settings'] = instance.safetySettings;
  val['usage_stats'] = instance.usageStats;
  return val;
}

PlaytimePreferences _$PlaytimePreferencesFromJson(Map<String, dynamic> json) =>
    PlaytimePreferences(
      favoriteGames: (json['favorite_games'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      preferredCategories: (json['preferred_categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      maxSessionDuration: (json['max_session_duration'] as num).toInt(),
      allowPublicSessions: json['allow_public_sessions'] as bool,
      allowFriendInvites: json['allow_friend_invites'] as bool,
    );

Map<String, dynamic> _$PlaytimePreferencesToJson(
        PlaytimePreferences instance) =>
    <String, dynamic>{
      'favorite_games': instance.favoriteGames,
      'preferred_categories': instance.preferredCategories,
      'max_session_duration': instance.maxSessionDuration,
      'allow_public_sessions': instance.allowPublicSessions,
      'allow_friend_invites': instance.allowFriendInvites,
    };

SafetySettings _$SafetySettingsFromJson(Map<String, dynamic> json) =>
    SafetySettings(
      chatEnabled: json['chat_enabled'] as bool,
      autoApproveSessions: json['auto_approve_sessions'] as bool,
      requireParentApproval: json['require_parent_approval'] as bool,
      blockedUsers: (json['blocked_users'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      restrictedContent: (json['restricted_content'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SafetySettingsToJson(SafetySettings instance) =>
    <String, dynamic>{
      'chat_enabled': instance.chatEnabled,
      'auto_approve_sessions': instance.autoApproveSessions,
      'require_parent_approval': instance.requireParentApproval,
      'blocked_users': instance.blockedUsers,
      'restricted_content': instance.restrictedContent,
    };

UsageStats _$UsageStatsFromJson(Map<String, dynamic> json) => UsageStats(
      totalSessions: (json['total_sessions'] as num).toInt(),
      totalPlaytime: (json['total_playtime'] as num).toInt(),
      favoriteBackgrounds: (json['favorite_backgrounds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastActive: json['last_active'] == null
          ? null
          : DateTime.parse(json['last_active'] as String),
    );

Map<String, dynamic> _$UsageStatsToJson(UsageStats instance) {
  final val = <String, dynamic>{
    'total_sessions': instance.totalSessions,
    'total_playtime': instance.totalPlaytime,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('last_active', instance.lastActive?.toIso8601String());
  val['favorite_backgrounds'] = instance.favoriteBackgrounds;
  return val;
}

PlaytimePermissions _$PlaytimePermissionsFromJson(Map<String, dynamic> json) =>
    PlaytimePermissions(
      canCreateSessions: json['can_create_sessions'] as bool,
      canUploadContent: json['can_upload_content'] as bool,
      canInviteFriends: json['can_invite_friends'] as bool,
      canJoinPublicSessions: json['can_join_public_sessions'] as bool,
      requiresParentApproval: json['requires_parent_approval'] as bool,
    );

Map<String, dynamic> _$PlaytimePermissionsToJson(
        PlaytimePermissions instance) =>
    <String, dynamic>{
      'can_create_sessions': instance.canCreateSessions,
      'can_upload_content': instance.canUploadContent,
      'can_invite_friends': instance.canInviteFriends,
      'can_join_public_sessions': instance.canJoinPublicSessions,
      'requires_parent_approval': instance.requiresParentApproval,
    };
