// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pointsCost: (json['points_cost'] as num).toInt(),
      type: $enumDecode(_$RewardTypeEnumMap, json['type']),
      isAvailable: json['is_available'] as bool,
      imageUrl: json['image_url'] as String?,
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      maxRedemptions: (json['max_redemptions'] as num?)?.toInt(),
      currentRedemptions: (json['current_redemptions'] as num?)?.toInt() ?? 0,
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RewardToJson(Reward instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'points_cost': instance.pointsCost,
    'type': _$RewardTypeEnumMap[instance.type]!,
    'is_available': instance.isAvailable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image_url', instance.imageUrl);
  writeNotNull('discount_percentage', instance.discountPercentage);
  writeNotNull('original_price', instance.originalPrice);
  writeNotNull('max_redemptions', instance.maxRedemptions);
  val['current_redemptions'] = instance.currentRedemptions;
  writeNotNull('expiry_date', instance.expiryDate?.toIso8601String());
  writeNotNull('metadata', instance.metadata);
  return val;
}

const _$RewardTypeEnumMap = {
  RewardType.discount: 'discount',
  RewardType.freeService: 'free_service',
  RewardType.premiumFeature: 'premium_feature',
  RewardType.physicalItem: 'physical_item',
  RewardType.subscriptionExtension: 'subscription_extension',
};

UserRewards _$UserRewardsFromJson(Map<String, dynamic> json) => UserRewards(
      userId: json['user_id'] as String,
      points: (json['points'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      redeemedRewards: (json['redeemed_rewards'] as List<dynamic>)
          .map((e) => RedeemedReward.fromJson(e as Map<String, dynamic>))
          .toList(),
      pointsHistory: (json['points_history'] as List<dynamic>)
          .map((e) => PointsTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserRewardsToJson(UserRewards instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'points': instance.points,
      'level': instance.level,
      'achievements': instance.achievements,
      'redeemed_rewards': instance.redeemedRewards,
      'points_history': instance.pointsHistory,
    };

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$AchievementTypeEnumMap, json['type']),
      pointsReward: (json['points_reward'] as num).toInt(),
      isUnlocked: json['is_unlocked'] as bool,
      unlockedAt: json['unlocked_at'] == null
          ? null
          : DateTime.parse(json['unlocked_at'] as String),
      progress: (json['progress'] as num?)?.toInt(),
      maxProgress: (json['max_progress'] as num?)?.toInt(),
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$AchievementToJson(Achievement instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'type': _$AchievementTypeEnumMap[instance.type]!,
    'points_reward': instance.pointsReward,
    'is_unlocked': instance.isUnlocked,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('unlocked_at', instance.unlockedAt?.toIso8601String());
  writeNotNull('progress', instance.progress);
  writeNotNull('max_progress', instance.maxProgress);
  writeNotNull('icon', instance.icon);
  return val;
}

const _$AchievementTypeEnumMap = {
  AchievementType.booking: 'booking',
  AchievementType.referral: 'referral',
  AchievementType.streak: 'streak',
  AchievementType.social: 'social',
  AchievementType.milestone: 'milestone',
};

RedeemedReward _$RedeemedRewardFromJson(Map<String, dynamic> json) =>
    RedeemedReward(
      id: json['id'] as String,
      rewardId: json['reward_id'] as String,
      userId: json['user_id'] as String,
      redeemedAt: DateTime.parse(json['redeemed_at'] as String),
      pointsSpent: (json['points_spent'] as num).toInt(),
      code: json['code'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      isUsed: json['is_used'] as bool? ?? false,
      usedAt: json['used_at'] == null
          ? null
          : DateTime.parse(json['used_at'] as String),
    );

Map<String, dynamic> _$RedeemedRewardToJson(RedeemedReward instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'reward_id': instance.rewardId,
    'user_id': instance.userId,
    'redeemed_at': instance.redeemedAt.toIso8601String(),
    'points_spent': instance.pointsSpent,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('expires_at', instance.expiresAt?.toIso8601String());
  val['is_used'] = instance.isUsed;
  writeNotNull('used_at', instance.usedAt?.toIso8601String());
  return val;
}

PointsTransaction _$PointsTransactionFromJson(Map<String, dynamic> json) =>
    PointsTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      points: (json['points'] as num).toInt(),
      type: $enumDecode(_$PointsTransactionTypeEnumMap, json['type']),
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PointsTransactionToJson(PointsTransaction instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'user_id': instance.userId,
    'points': instance.points,
    'type': _$PointsTransactionTypeEnumMap[instance.type]!,
    'reason': instance.reason,
    'timestamp': instance.timestamp.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('metadata', instance.metadata);
  return val;
}

const _$PointsTransactionTypeEnumMap = {
  PointsTransactionType.earned: 'earned',
  PointsTransactionType.spent: 'spent',
  PointsTransactionType.bonus: 'bonus',
  PointsTransactionType.penalty: 'penalty',
};

RewardProgress _$RewardProgressFromJson(Map<String, dynamic> json) =>
    RewardProgress(
      userId: json['user_id'] as String,
      points: (json['points'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      achievementsUnlocked: (json['achievements_unlocked'] as num).toInt(),
      totalAchievements: (json['total_achievements'] as num).toInt(),
      rewardsRedeemed: (json['rewards_redeemed'] as num).toInt(),
      nextReward: json['next_reward'] == null
          ? null
          : Reward.fromJson(json['next_reward'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RewardProgressToJson(RewardProgress instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'points': instance.points,
    'level': instance.level,
    'achievements_unlocked': instance.achievementsUnlocked,
    'total_achievements': instance.totalAchievements,
    'rewards_redeemed': instance.rewardsRedeemed,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('next_reward', instance.nextReward);
  return val;
}
