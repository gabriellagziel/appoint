import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'ambassador_profile.freezed.dart';
part 'ambassador_profile.g.dart';

/// Comprehensive Ambassador Profile with all automation features
@freezed
class AmbassadorProfile with _$AmbassadorProfile {
  const factory AmbassadorProfile({
    required String id,
    required String userId,
    required String countryCode,
    required String languageCode,
    required AmbassadorStatus status,
    required AmbassadorTier tier,
    required DateTime assignedAt,
    required DateTime lastActivityDate,
    required int totalReferrals,
    required int activeReferrals,
    required int monthlyReferrals,
    required DateTime lastMonthlyResetAt,
    required List<AmbassadorReward> earnedRewards,
    required AmbassadorMetrics metrics,
    String? shareLink,
    String? qrCodeUrl,
    DateTime? statusChangedAt,
    DateTime? tierChangedAt,
    DateTime? lastNotificationSentAt,
    DateTime? nextMonthlyReviewAt,
    Map<String, dynamic>? customData,
  }) = _AmbassadorProfile;

  factory AmbassadorProfile.fromJson(Map<String, dynamic> json) =>
      _$AmbassadorProfileFromJson(json);

  // Factory for new ambassador
  factory AmbassadorProfile.newAmbassador({
    required String userId,
    required String countryCode,
    required String languageCode,
  }) {
    final now = DateTime.now();
    return AmbassadorProfile(
      id: userId,
      userId: userId,
      countryCode: countryCode,
      languageCode: languageCode,
      status: AmbassadorStatus.approved,
      tier: AmbassadorTier.basic,
      assignedAt: now,
      lastActivityDate: now,
      totalReferrals: 0,
      activeReferrals: 0,
      monthlyReferrals: 0,
      lastMonthlyResetAt: now,
      earnedRewards: [],
      metrics: AmbassadorMetrics.empty(),
      statusChangedAt: now,
      tierChangedAt: now,
      nextMonthlyReviewAt: DateTime(now.year, now.month + 1),
    );
  }
}

/// Ambassador Status with automated transitions
enum AmbassadorStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('inactive')
  inactive,
  @JsonValue('suspended')
  suspended;

  String get displayName {
    switch (this) {
      case AmbassadorStatus.pending:
        return 'Pending Approval';
      case AmbassadorStatus.approved:
        return 'Active Ambassador';
      case AmbassadorStatus.inactive:
        return 'Inactive';
      case AmbassadorStatus.suspended:
        return 'Suspended';
    }
  }

  bool get isActive => this == AmbassadorStatus.approved;
}

/// Ambassador Tiers based on referral count
enum AmbassadorTier {
  @JsonValue('basic')
  basic, // 5+ referrals
  @JsonValue('premium')
  premium, // 50+ referrals
  @JsonValue('lifetime')
  lifetime; // 1,000+ referrals

  String get displayName {
    switch (this) {
      case AmbassadorTier.basic:
        return 'Basic Ambassador';
      case AmbassadorTier.premium:
        return 'Premium Ambassador';
      case AmbassadorTier.lifetime:
        return 'Lifetime Ambassador';
    }
  }

  int get requiredReferrals {
    switch (this) {
      case AmbassadorTier.basic:
        return 5;
      case AmbassadorTier.premium:
        return 50;
      case AmbassadorTier.lifetime:
        return 1000;
    }
  }

  Color get color {
    switch (this) {
      case AmbassadorTier.basic:
        return const Color(0xFF4CAF50);
      case AmbassadorTier.premium:
        return const Color(0xFF2196F3);
      case AmbassadorTier.lifetime:
        return const Color(0xFFFF9800);
    }
  }
}

/// Ambassador Rewards
@freezed
class AmbassadorReward with _$AmbassadorReward {
  const factory AmbassadorReward({
    required String id,
    required AmbassadorRewardType type,
    required AmbassadorTier tier,
    required DateTime earnedAt,
    required DateTime expiresAt,
    required bool isActive,
    String? description,
    Map<String, dynamic>? metadata,
  }) = _AmbassadorReward;

  factory AmbassadorReward.fromJson(Map<String, dynamic> json) =>
      _$AmbassadorRewardFromJson(json);
}

/// Types of Ambassador Rewards
enum AmbassadorRewardType {
  @JsonValue('premium_features')
  premiumFeatures,
  @JsonValue('one_year_access')
  oneYearAccess,
  @JsonValue('lifetime_access')
  lifetimeAccess;

  String get displayName {
    switch (this) {
      case AmbassadorRewardType.premiumFeatures:
        return 'Premium Features Unlocked';
      case AmbassadorRewardType.oneYearAccess:
        return '1 Year Full Access';
      case AmbassadorRewardType.lifetimeAccess:
        return 'Lifetime Access';
    }
  }
}

/// Ambassador Performance Metrics
@freezed
class AmbassadorMetrics with _$AmbassadorMetrics {
  const factory AmbassadorMetrics({
    required int conversionRate,
    required int averageReferralsPerMonth,
    required int streakDays,
    required int longestStreak,
    required DateTime lastReferralDate,
    required Map<String, int> monthlyBreakdown,
    required double engagementScore,
    required int countryRanking,
    required int globalRanking,
  }) = _AmbassadorMetrics;

  factory AmbassadorMetrics.fromJson(Map<String, dynamic> json) =>
      _$AmbassadorMetricsFromJson(json);

  factory AmbassadorMetrics.empty() => AmbassadorMetrics(
        conversionRate: 0,
        averageReferralsPerMonth: 0,
        streakDays: 0,
        longestStreak: 0,
        lastReferralDate: DateTime.now(),
        monthlyBreakdown: {},
        engagementScore: 0,
        countryRanking: 0,
        globalRanking: 0,
      );
}

/// Ambassador Referral Record
@freezed
class AmbassadorReferral with _$AmbassadorReferral {
  const factory AmbassadorReferral({
    required String id,
    required String ambassadorId,
    required String referredUserId,
    required DateTime referredAt,
    required DateTime activatedAt,
    required bool isActive,
    required String source,
    String? conversionDetails,
    Map<String, dynamic>? metadata,
  }) = _AmbassadorReferral;

  factory AmbassadorReferral.fromJson(Map<String, dynamic> json) =>
      _$AmbassadorReferralFromJson(json);
}
