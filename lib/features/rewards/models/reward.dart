import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward {
  const Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsCost,
    required this.type,
    required this.isAvailable,
    this.imageUrl,
    this.discountPercentage,
    this.originalPrice,
    this.maxRedemptions,
    this.currentRedemptions = 0,
    this.expiryDate,
    this.metadata,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  final String id;
  final String name;
  final String description;
  final int pointsCost;
  final RewardType type;
  final bool isAvailable;
  final String? imageUrl;
  final double? discountPercentage;
  final double? originalPrice;
  final int? maxRedemptions;
  final int currentRedemptions;
  final DateTime? expiryDate;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$RewardToJson(this);

  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);
  bool get isLimited =>
      maxRedemptions != null && currentRedemptions >= maxRedemptions!;
  bool get canRedeem => isAvailable && !isExpired && !isLimited;
}

@JsonSerializable()
class UserRewards {
  const UserRewards({
    required this.userId,
    required this.points,
    required this.level,
    required this.achievements,
    required this.redeemedRewards,
    required this.pointsHistory,
  });

  factory UserRewards.fromJson(Map<String, dynamic> json) =>
      _$UserRewardsFromJson(json);

  final String userId;
  final int points;
  final int level;
  final List<Achievement> achievements;
  final List<RedeemedReward> redeemedRewards;
  final List<PointsTransaction> pointsHistory;

  Map<String, dynamic> toJson() => _$UserRewardsToJson(this);

  int get pointsToNextLevel {
    final nextLevelPoints = _calculatePointsForLevel(level + 1);
    return nextLevelPoints - points;
  }

  double get levelProgress {
    final currentLevelPoints = _calculatePointsForLevel(level);
    final nextLevelPoints = _calculatePointsForLevel(level + 1);
    final pointsInCurrentLevel = points - currentLevelPoints;
    final pointsNeededForLevel = nextLevelPoints - currentLevelPoints;
    return pointsInCurrentLevel / pointsNeededForLevel;
  }
}

@JsonSerializable()
class Achievement {
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.pointsReward,
    required this.isUnlocked,
    this.unlockedAt,
    this.progress,
    this.maxProgress,
    this.icon,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  final String id;
  final String name;
  final String description;
  final AchievementType type;
  final int pointsReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int? progress;
  final int? maxProgress;
  final String? icon;

  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  double get progressPercentage {
    if (maxProgress == null || maxProgress == 0) return 0;
    return (progress ?? 0) / maxProgress!;
  }
}

@JsonSerializable()
class RedeemedReward {
  const RedeemedReward({
    required this.id,
    required this.rewardId,
    required this.userId,
    required this.redeemedAt,
    required this.pointsSpent,
    this.code,
    this.expiresAt,
    this.isUsed = false,
    this.usedAt,
  });

  factory RedeemedReward.fromJson(Map<String, dynamic> json) =>
      _$RedeemedRewardFromJson(json);

  final String id;
  final String rewardId;
  final String userId;
  final DateTime redeemedAt;
  final int pointsSpent;
  final String? code;
  final DateTime? expiresAt;
  final bool isUsed;
  final DateTime? usedAt;

  Map<String, dynamic> toJson() => _$RedeemedRewardToJson(this);

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

@JsonSerializable()
class PointsTransaction {
  const PointsTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.type,
    required this.reason,
    required this.timestamp,
    this.metadata,
  });

  factory PointsTransaction.fromJson(Map<String, dynamic> json) =>
      _$PointsTransactionFromJson(json);

  final String id;
  final String userId;
  final int points;
  final PointsTransactionType type;
  final String reason;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$PointsTransactionToJson(this);
}

@JsonSerializable()
class RewardProgress {
  const RewardProgress({
    required this.userId,
    required this.points,
    required this.level,
    required this.achievementsUnlocked,
    required this.totalAchievements,
    required this.rewardsRedeemed,
    required this.nextReward,
  });

  factory RewardProgress.fromJson(Map<String, dynamic> json) =>
      _$RewardProgressFromJson(json);

  final String userId;
  final int points;
  final int level;
  final int achievementsUnlocked;
  final int totalAchievements;
  final int rewardsRedeemed;
  final Reward? nextReward;

  int get pointsToNextLevel {
    final nextLevelPoints = _calculatePointsForLevel(level + 1);
    return nextLevelPoints - points;
  }

  double get levelProgress {
    final currentLevelPoints = _calculatePointsForLevel(level);
    final nextLevelPoints = _calculatePointsForLevel(level + 1);
    final pointsInCurrentLevel = points - currentLevelPoints;
    final pointsNeededForLevel = nextLevelPoints - currentLevelPoints;
    return pointsInCurrentLevel / pointsNeededForLevel;
  }

  int _calculatePointsForLevel(int level) {
    // Simple level progression: each level requires 100 more points than the previous
    return level * 100;
  }

  Map<String, dynamic> toJson() => _$RewardProgressToJson(this);

  double get achievementProgress => achievementsUnlocked / totalAchievements;
}

enum RewardType {
  @JsonValue('discount')
  discount,
  @JsonValue('free_service')
  freeService,
  @JsonValue('premium_feature')
  premiumFeature,
  @JsonValue('physical_item')
  physicalItem,
  @JsonValue('subscription_extension')
  subscriptionExtension,
}

enum AchievementType {
  @JsonValue('booking')
  booking,
  @JsonValue('referral')
  referral,
  @JsonValue('streak')
  streak,
  @JsonValue('social')
  social,
  @JsonValue('milestone')
  milestone,
}

enum PointsTransactionType {
  @JsonValue('earned')
  earned,
  @JsonValue('spent')
  spent,
  @JsonValue('bonus')
  bonus,
  @JsonValue('penalty')
  penalty,
}

// Helper functions for level calculations
int _calculatePointsForLevel(int level) {
  // Exponential growth: 100 * 2^(level-1)
  return 100 * (1 << (level - 1));
}
