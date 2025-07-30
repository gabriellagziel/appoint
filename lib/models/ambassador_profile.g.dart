// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambassador_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AmbassadorProfileImpl _$$AmbassadorProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$AmbassadorProfileImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      countryCode: json['country_code'] as String,
      languageCode: json['language_code'] as String,
      status: $enumDecode(_$AmbassadorStatusEnumMap, json['status']),
      tier: $enumDecode(_$AmbassadorTierEnumMap, json['tier']),
      assignedAt: DateTime.parse(json['assigned_at'] as String),
      lastActivityDate: DateTime.parse(json['last_activity_date'] as String),
      totalReferrals: (json['total_referrals'] as num).toInt(),
      activeReferrals: (json['active_referrals'] as num).toInt(),
      monthlyReferrals: (json['monthly_referrals'] as num).toInt(),
      lastMonthlyResetAt:
          DateTime.parse(json['last_monthly_reset_at'] as String),
      earnedRewards: (json['earned_rewards'] as List<dynamic>)
          .map((e) => AmbassadorReward.fromJson(e as Map<String, dynamic>))
          .toList(),
      metrics:
          AmbassadorMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
      shareLink: json['share_link'] as String?,
      qrCodeUrl: json['qr_code_url'] as String?,
      statusChangedAt: json['status_changed_at'] == null
          ? null
          : DateTime.parse(json['status_changed_at'] as String),
      tierChangedAt: json['tier_changed_at'] == null
          ? null
          : DateTime.parse(json['tier_changed_at'] as String),
      lastNotificationSentAt: json['last_notification_sent_at'] == null
          ? null
          : DateTime.parse(json['last_notification_sent_at'] as String),
      nextMonthlyReviewAt: json['next_monthly_review_at'] == null
          ? null
          : DateTime.parse(json['next_monthly_review_at'] as String),
      customData: json['custom_data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AmbassadorProfileImplToJson(
    _$AmbassadorProfileImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'user_id': instance.userId,
    'country_code': instance.countryCode,
    'language_code': instance.languageCode,
    'status': _$AmbassadorStatusEnumMap[instance.status]!,
    'tier': _$AmbassadorTierEnumMap[instance.tier]!,
    'assigned_at': instance.assignedAt.toIso8601String(),
    'last_activity_date': instance.lastActivityDate.toIso8601String(),
    'total_referrals': instance.totalReferrals,
    'active_referrals': instance.activeReferrals,
    'monthly_referrals': instance.monthlyReferrals,
    'last_monthly_reset_at': instance.lastMonthlyResetAt.toIso8601String(),
    'earned_rewards': instance.earnedRewards,
    'metrics': instance.metrics,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('share_link', instance.shareLink);
  writeNotNull('qr_code_url', instance.qrCodeUrl);
  writeNotNull(
      'status_changed_at', instance.statusChangedAt?.toIso8601String());
  writeNotNull('tier_changed_at', instance.tierChangedAt?.toIso8601String());
  writeNotNull('last_notification_sent_at',
      instance.lastNotificationSentAt?.toIso8601String());
  writeNotNull('next_monthly_review_at',
      instance.nextMonthlyReviewAt?.toIso8601String());
  writeNotNull('custom_data', instance.customData);
  return val;
}

const _$AmbassadorStatusEnumMap = {
  AmbassadorStatus.pending: 'pending',
  AmbassadorStatus.approved: 'approved',
  AmbassadorStatus.inactive: 'inactive',
  AmbassadorStatus.suspended: 'suspended',
};

const _$AmbassadorTierEnumMap = {
  AmbassadorTier.basic: 'basic',
  AmbassadorTier.premium: 'premium',
  AmbassadorTier.lifetime: 'lifetime',
};

_$AmbassadorRewardImpl _$$AmbassadorRewardImplFromJson(
        Map<String, dynamic> json) =>
    _$AmbassadorRewardImpl(
      id: json['id'] as String,
      type: $enumDecode(_$AmbassadorRewardTypeEnumMap, json['type']),
      tier: $enumDecode(_$AmbassadorTierEnumMap, json['tier']),
      earnedAt: DateTime.parse(json['earned_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      isActive: json['is_active'] as bool,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AmbassadorRewardImplToJson(
    _$AmbassadorRewardImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': _$AmbassadorRewardTypeEnumMap[instance.type]!,
    'tier': _$AmbassadorTierEnumMap[instance.tier]!,
    'earned_at': instance.earnedAt.toIso8601String(),
    'expires_at': instance.expiresAt.toIso8601String(),
    'is_active': instance.isActive,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('metadata', instance.metadata);
  return val;
}

const _$AmbassadorRewardTypeEnumMap = {
  AmbassadorRewardType.premiumFeatures: 'premium_features',
  AmbassadorRewardType.oneYearAccess: 'one_year_access',
  AmbassadorRewardType.lifetimeAccess: 'lifetime_access',
};

_$AmbassadorMetricsImpl _$$AmbassadorMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$AmbassadorMetricsImpl(
      conversionRate: (json['conversion_rate'] as num).toInt(),
      averageReferralsPerMonth:
          (json['average_referrals_per_month'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
      longestStreak: (json['longest_streak'] as num).toInt(),
      lastReferralDate: DateTime.parse(json['last_referral_date'] as String),
      monthlyBreakdown: Map<String, int>.from(json['monthly_breakdown'] as Map),
      engagementScore: (json['engagement_score'] as num).toDouble(),
      countryRanking: (json['country_ranking'] as num).toInt(),
      globalRanking: (json['global_ranking'] as num).toInt(),
    );

Map<String, dynamic> _$$AmbassadorMetricsImplToJson(
        _$AmbassadorMetricsImpl instance) =>
    <String, dynamic>{
      'conversion_rate': instance.conversionRate,
      'average_referrals_per_month': instance.averageReferralsPerMonth,
      'streak_days': instance.streakDays,
      'longest_streak': instance.longestStreak,
      'last_referral_date': instance.lastReferralDate.toIso8601String(),
      'monthly_breakdown': instance.monthlyBreakdown,
      'engagement_score': instance.engagementScore,
      'country_ranking': instance.countryRanking,
      'global_ranking': instance.globalRanking,
    };

_$AmbassadorReferralImpl _$$AmbassadorReferralImplFromJson(
        Map<String, dynamic> json) =>
    _$AmbassadorReferralImpl(
      id: json['id'] as String,
      ambassadorId: json['ambassador_id'] as String,
      referredUserId: json['referred_user_id'] as String,
      referredAt: DateTime.parse(json['referred_at'] as String),
      activatedAt: DateTime.parse(json['activated_at'] as String),
      isActive: json['is_active'] as bool,
      source: json['source'] as String,
      conversionDetails: json['conversion_details'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AmbassadorReferralImplToJson(
    _$AmbassadorReferralImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'ambassador_id': instance.ambassadorId,
    'referred_user_id': instance.referredUserId,
    'referred_at': instance.referredAt.toIso8601String(),
    'activated_at': instance.activatedAt.toIso8601String(),
    'is_active': instance.isActive,
    'source': instance.source,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('conversion_details', instance.conversionDetails);
  writeNotNull('metadata', instance.metadata);
  return val;
}
