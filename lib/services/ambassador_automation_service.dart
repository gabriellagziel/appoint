import 'package:appoint/models/ambassador_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Comprehensive Ambassador Automation Service
/// Handles all automated processes: promotion, demotion, tier management, rewards
class AmbassadorAutomationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const int _minimumMonthlyReferrals = 10;
  static const int _basicTierReferrals = 5;
  static const int _premiumTierReferrals = 50;
  static const int _lifetimeTierReferrals = 1000;

  /// Check if user is eligible for automatic ambassador promotion
  Future<bool> checkEligibilityForPromotion(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data()!;

      // Must be adult and not already ambassador
      if (userData['isAdult'] != true) return false;
      if (userData['ambassadorStatus'] == 'approved') return false;

      // Check referral count
      final referralCount = await _getUserReferralCount(userId);
      return referralCount >= _basicTierReferrals;
    } catch (e) {
      debugPrint('Error checking promotion eligibility: $e');
      return false;
    }
  }

  /// Automatically promote user to ambassador
  Future<bool> promoteToAmbassador(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data()!;
      final countryCode = userData['countryCode'] as String?;
      final languageCode = userData['preferredLanguage'] as String?;

      if (countryCode == null || languageCode == null) return false;

      // Check quota availability
      final hasSlots = await _checkQuotaAvailability(countryCode, languageCode);
      if (!hasSlots) return false;

      await _firestore.runTransaction((transaction) async {
        // Update user status
        transaction.update(_firestore.collection('users').doc(userId), {
          'ambassadorStatus': 'approved',
          'role': 'ambassador',
          'ambassadorSince': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Create ambassador profile
        final ambassadorProfile = AmbassadorProfile.newAmbassador(
          userId: userId,
          countryCode: countryCode,
          languageCode: languageCode,
        );

        transaction.set(
          _firestore.collection('ambassador_profiles').doc(userId),
          ambassadorProfile.toJson(),
        );

        // Generate share link
        await _generateShareLink(userId);

        // Award basic tier reward
        await _awardTierReward(userId, AmbassadorTier.basic);
      });

      return true;
    } catch (e) {
      debugPrint('Error promoting to ambassador: $e');
      return false;
    }
  }

  /// Monthly review and demotion check
  Future<void> performMonthlyReview() async {
    try {
      final now = DateTime.now();
      final ambassadorProfiles = await _firestore
          .collection('ambassador_profiles')
          .where('status', isEqualTo: 'approved')
          .where('nextMonthlyReviewAt', isLessThanOrEqualTo: now)
          .get();

      for (final doc in ambassadorProfiles.docs) {
        final profile = AmbassadorProfile.fromJson(doc.data());
        await _reviewAmbassadorPerformance(profile);
      }
    } catch (e) {
      debugPrint('Error performing monthly review: $e');
    }
  }

  /// Review individual ambassador performance
  Future<void> _reviewAmbassadorPerformance(AmbassadorProfile profile) async {
    try {
      final monthlyReferrals = await _getMonthlyReferralCount(profile.userId);

      if (monthlyReferrals < _minimumMonthlyReferrals) {
        await _demoteAmbassador(
            profile.userId, 'insufficient_monthly_referrals');
      } else {
        // Update activity and schedule next review
        await _updateAmbassadorActivity(profile.userId, monthlyReferrals);
        await _checkTierUpgrade(profile.userId);
      }
    } catch (e) {
      debugPrint('Error reviewing ambassador performance: $e');
    }
  }

  /// Demote ambassador for insufficient performance
  Future<void> _demoteAmbassador(String userId, String reason) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Update user status
        transaction.update(_firestore.collection('users').doc(userId), {
          'ambassadorStatus': 'inactive',
          'role': 'client',
          'ambassadorRemovedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update ambassador profile
        transaction
            .update(_firestore.collection('ambassador_profiles').doc(userId), {
          'status': 'inactive',
          'statusChangedAt': FieldValue.serverTimestamp(),
          'lastActivityDate': FieldValue.serverTimestamp(),
        });

        // Log demotion
        transaction.set(_firestore.collection('ambassador_demotions').doc(), {
          'ambassadorId': userId,
          'reason': reason,
          'demotedAt': FieldValue.serverTimestamp(),
          'monthlyReferrals': await _getMonthlyReferralCount(userId),
        });

        // Revoke active rewards (except lifetime)
        await _revokeActiveRewards(userId);
      });
    } catch (e) {
      debugPrint('Error demoting ambassador: $e');
    }
  }

  /// Check and handle tier upgrades
  Future<void> _checkTierUpgrade(String userId) async {
    try {
      final totalReferrals = await _getUserReferralCount(userId);
      final currentProfile = await _getAmbassadorProfile(userId);

      if (currentProfile == null) return;

      var newTier = currentProfile.tier;

      // Determine new tier
      if (totalReferrals >= _lifetimeTierReferrals &&
          currentProfile.tier != AmbassadorTier.lifetime) {
        newTier = AmbassadorTier.lifetime;
      } else if (totalReferrals >= _premiumTierReferrals &&
          currentProfile.tier == AmbassadorTier.basic) {
        newTier = AmbassadorTier.premium;
      }

      // Upgrade tier if changed
      if (newTier != currentProfile.tier) {
        await _upgradeTier(userId, newTier);
        await _awardTierReward(userId, newTier);
      }
    } catch (e) {
      debugPrint('Error checking tier upgrade: $e');
    }
  }

  /// Upgrade ambassador tier
  Future<void> _upgradeTier(String userId, AmbassadorTier newTier) async {
    try {
      await _firestore.collection('ambassador_profiles').doc(userId).update({
        'tier': newTier.name,
        'tierChangedAt': FieldValue.serverTimestamp(),
        'lastActivityDate': FieldValue.serverTimestamp(),
      });

      // Log tier upgrade
      await _firestore.collection('ambassador_tier_upgrades').add({
        'ambassadorId': userId,
        'newTier': newTier.name,
        'upgradedAt': FieldValue.serverTimestamp(),
        'totalReferrals': await _getUserReferralCount(userId),
      });
    } catch (e) {
      debugPrint('Error upgrading tier: $e');
    }
  }

  /// Award tier-specific rewards
  Future<void> _awardTierReward(String userId, AmbassadorTier tier) async {
    try {
      final now = DateTime.now();
      AmbassadorRewardType rewardType;
      DateTime expiresAt;

      switch (tier) {
        case AmbassadorTier.basic:
          rewardType = AmbassadorRewardType.premiumFeatures;
          expiresAt = now.add(const Duration(days: 365)); // 1 year
        case AmbassadorTier.premium:
          rewardType = AmbassadorRewardType.oneYearAccess;
          expiresAt = now.add(const Duration(days: 365));
        case AmbassadorTier.lifetime:
          rewardType = AmbassadorRewardType.lifetimeAccess;
          expiresAt = DateTime(2099, 12, 31); // Far future date
      }

      final reward = AmbassadorReward(
        id: '${userId}_${tier.name}_${now.millisecondsSinceEpoch}',
        type: rewardType,
        tier: tier,
        earnedAt: now,
        expiresAt: expiresAt,
        isActive: true,
        description: rewardType.displayName,
      );

      await _firestore
          .collection('ambassador_rewards')
          .doc(reward.id)
          .set(reward.toJson());

      // Update ambassador profile with new reward
      await _firestore.collection('ambassador_profiles').doc(userId).update({
        'earnedRewards': FieldValue.arrayUnion([reward.toJson()]),
        'lastActivityDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error awarding tier reward: $e');
    }
  }

  /// Generate unique share link for ambassador
  Future<void> _generateShareLink(String userId) async {
    try {
      final shareCode = _generateUniqueCode(userId);
      final shareLink = 'https://app-oint.com/invite/$shareCode';

      await _firestore.collection('ambassador_profiles').doc(userId).update({
        'shareLink': shareLink,
        'shareCode': shareCode,
      });

      // Store share code mapping
      await _firestore.collection('ambassador_share_codes').doc(shareCode).set({
        'ambassadorId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      debugPrint('Error generating share link: $e');
    }
  }

  /// Generate unique share code
  String _generateUniqueCode(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final userHash = userId.hashCode.abs();
    return '${userHash.toString().substring(0, 4)}${timestamp.toString().substring(8)}';
  }

  /// Update ambassador monthly activity
  Future<void> _updateAmbassadorActivity(
      String userId, int monthlyReferrals) async {
    try {
      final nextMonth = DateTime.now().add(const Duration(days: 30));
      final nextReview = DateTime(nextMonth.year, nextMonth.month);

      await _firestore.collection('ambassador_profiles').doc(userId).update({
        'monthlyReferrals': monthlyReferrals,
        'lastActivityDate': FieldValue.serverTimestamp(),
        'lastMonthlyResetAt': FieldValue.serverTimestamp(),
        'nextMonthlyReviewAt': nextReview,
      });
    } catch (e) {
      debugPrint('Error updating ambassador activity: $e');
    }
  }

  /// Track referral for ambassador
  Future<void> trackReferral(String ambassadorId, String referredUserId) async {
    try {
      final referral = AmbassadorReferral(
        id: '${ambassadorId}_${referredUserId}_${DateTime.now().millisecondsSinceEpoch}',
        ambassadorId: ambassadorId,
        referredUserId: referredUserId,
        referredAt: DateTime.now(),
        activatedAt: DateTime.now(),
        isActive: true,
        source: 'share_link',
      );

      await _firestore.runTransaction((transaction) async {
        // Create referral record
        transaction.set(
          _firestore.collection('ambassador_referrals').doc(referral.id),
          referral.toJson(),
        );

        // Update ambassador counts
        transaction.update(
            _firestore.collection('ambassador_profiles').doc(ambassadorId), {
          'totalReferrals': FieldValue.increment(1),
          'activeReferrals': FieldValue.increment(1),
          'monthlyReferrals': FieldValue.increment(1),
          'lastActivityDate': FieldValue.serverTimestamp(),
        });

        // Check for potential tier upgrade
        await _checkTierUpgrade(ambassadorId);
      });
    } catch (e) {
      debugPrint('Error tracking referral: $e');
    }
  }

  /// Helper methods
  Future<int> _getUserReferralCount(String userId) async {
    final snapshot = await _firestore
        .collection('ambassador_referrals')
        .where('ambassadorId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<int> _getMonthlyReferralCount(String userId) async {
    final lastMonth = DateTime.now().subtract(const Duration(days: 30));
    final snapshot = await _firestore
        .collection('ambassador_referrals')
        .where('ambassadorId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .where('referredAt', isGreaterThan: lastMonth)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<AmbassadorProfile?> _getAmbassadorProfile(String userId) async {
    final doc =
        await _firestore.collection('ambassador_profiles').doc(userId).get();
    if (!doc.exists) return null;
    return AmbassadorProfile.fromJson(doc.data()!);
  }

  Future<bool> _checkQuotaAvailability(
      String countryCode, String languageCode) async {
    // Implementation would check against ambassador quotas
    // This is a simplified version
    return true;
  }

  Future<void> _revokeActiveRewards(String userId) async {
    final rewards = await _firestore
        .collection('ambassador_rewards')
        .where('ambassadorId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    for (final doc in rewards.docs) {
      final reward = AmbassadorReward.fromJson(doc.data());
      if (reward.type != AmbassadorRewardType.lifetimeAccess) {
        await doc.reference.update({'isActive': false});
      }
    }
  }
}
