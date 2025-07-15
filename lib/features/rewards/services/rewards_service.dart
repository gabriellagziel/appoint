import 'package:appoint/features/rewards/models/reward.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardsService {
  RewardsService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Award points to a user
  Future<void> awardPoints(String userId, int points, String reason) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Create points transaction
    final transaction = PointsTransaction(
      id: '',
      userId: userId,
      points: points,
      type: PointsTransactionType.earned,
      reason: reason,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('points_transactions').add(transaction.toJson());

    // Update user's total points
    await _firestore.collection('users').doc(userId).update({
      'points': FieldValue.increment(points),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Check for level up
    await _checkLevelUp(userId);
  }

  /// Get available rewards
  Future<List<Reward>> getAvailableRewards() async {
    final snapshot = await _firestore
        .collection('rewards')
        .where('isAvailable', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      return Reward.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  /// Redeem a reward
  Future<void> redeemReward(String rewardId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Get reward details
    final rewardDoc = await _firestore.collection('rewards').doc(rewardId).get();
    if (!rewardDoc.exists) throw Exception('Reward not found');

    final reward = Reward.fromJson({...rewardDoc.data()!, 'id': rewardId});
    if (!reward.canRedeem) throw Exception('Reward is not available for redemption');

    // Get user's current points
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) throw Exception('User not found');

    final userPoints = userDoc.data()!['points'] as int? ?? 0;
    if (userPoints < reward.pointsCost) {
      throw Exception('Insufficient points');
    }

    // Create redeemed reward
    final redeemedReward = RedeemedReward(
      id: '',
      rewardId: rewardId,
      userId: user.uid,
      redeemedAt: DateTime.now(),
      pointsSpent: reward.pointsCost,
      code: _generateRewardCode(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await _firestore.collection('redeemed_rewards').add(redeemedReward.toJson());

    // Deduct points
    await awardPoints(user.uid, -reward.pointsCost, 'Redeemed reward: ${reward.name}');

    // Update reward redemption count
    await _firestore.collection('rewards').doc(rewardId).update({
      'currentRedemptions': FieldValue.increment(1),
    });
  }

  /// Get user's reward progress
  Future<RewardProgress> getUserProgress() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Get user data
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) throw Exception('User not found');

    final userData = userDoc.data()!;
    final points = userData['points'] as int? ?? 0;
    final level = _calculateLevel(points);

    // Get achievements
    final achievementsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('achievements')
        .get();

    final achievements = achievementsSnapshot.docs.length;
    final totalAchievements = await _getTotalAchievements();

    // Get redeemed rewards count
    final redeemedRewardsSnapshot = await _firestore
        .collection('redeemed_rewards')
        .where('userId', isEqualTo: user.uid)
        .get();

    final rewardsRedeemed = redeemedRewardsSnapshot.docs.length;

    // Get next available reward
    final nextReward = await _getNextAvailableReward(points);

    return RewardProgress(
      userId: user.uid,
      points: points,
      level: level,
      achievementsUnlocked: achievements,
      totalAchievements: totalAchievements,
      rewardsRedeemed: rewardsRedeemed,
      nextReward: nextReward,
    );
  }

  /// Get user's achievements
  Future<List<Achievement>> getUserAchievements() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('achievements')
        .get();

    return snapshot.docs.map((doc) {
      return Achievement.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  /// Get user's redeemed rewards
  Future<List<RedeemedReward>> getUserRedeemedRewards() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final snapshot = await _firestore
        .collection('redeemed_rewards')
        .where('userId', isEqualTo: user.uid)
        .orderBy('redeemedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return RedeemedReward.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  /// Get points history
  Future<List<PointsTransaction>> getPointsHistory() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final snapshot = await _firestore
        .collection('points_transactions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map((doc) {
      return PointsTransaction.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  /// Check and unlock achievements
  Future<void> checkAchievements(String userId) async {
    // Get user's activity data
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data()!;
    final bookingsCount = userData['bookingsCount'] as int? ?? 0;
    final referralsCount = userData['referralsCount'] as int? ?? 0;
    final streakDays = userData['streakDays'] as int? ?? 0;

    // Check booking achievements
    await _checkBookingAchievements(userId, bookingsCount);

    // Check referral achievements
    await _checkReferralAchievements(userId, referralsCount);

    // Check streak achievements
    await _checkStreakAchievements(userId, streakDays);
  }

  /// Check level up
  Future<void> _checkLevelUp(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data()!;
    final points = userData['points'] as int? ?? 0;
    final currentLevel = userData['level'] as int? ?? 1;

    final newLevel = _calculateLevel(points);

    if (newLevel > currentLevel) {
      await _firestore.collection('users').doc(userId).update({
        'level': newLevel,
        'levelUpAt': FieldValue.serverTimestamp(),
      });

      // Award bonus points for level up
      final bonusPoints = (newLevel - currentLevel) * 50;
      await awardPoints(userId, bonusPoints, 'Level up bonus!');
    }
  }

  /// Calculate user level based on points
  int _calculateLevel(int points) {
    int level = 1;
    int requiredPoints = 100;

    while (points >= requiredPoints) {
      level++;
      final requiredPoints = 100 * (1 << (level - 1));
    }

    return level;
  }

  /// Generate unique reward code
  String _generateRewardCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'RW$random';
  }

  /// Get total number of achievements
  Future<int> _getTotalAchievements() async {
    final snapshot = await _firestore.collection('achievements').count().get();
    return snapshot.count ?? 0;
  }

  /// Get next available reward based on points
  Future<Reward?> _getNextAvailableReward(int points) async {
    final rewards = await getAvailableRewards();
    
    // Find the cheapest reward that user can afford
    final affordableRewards = rewards.where((reward) => 
        reward.pointsCost <= points && reward.canRedeem).toList();
    
    if (affordableRewards.isEmpty) return null;
    
    affordableRewards.sort((a, b) => a.pointsCost.compareTo(b.pointsCost));
    return affordableRewards.first;
  }

  /// Check booking achievements
  Future<void> _checkBookingAchievements(String userId, int bookingsCount) async {
    final achievements = [
      {'name': 'First Booking', 'count': 1, 'points': 50},
      {'name': 'Booking Pro', 'count': 10, 'points': 100},
      {'name': 'Booking Master', 'count': 50, 'points': 250},
      {'name': 'Booking Legend', 'count': 100, 'points': 500},
    ];

    for (final achievement in achievements) {
      final count = achievement['count'] as int;
      if (bookingsCount >= count) {
        await _unlockAchievement(userId, achievement['name'] as String, 
            achievement['points'] as int, AchievementType.booking);
      }
    }
  }

  /// Check referral achievements
  Future<void> _checkReferralAchievements(String userId, int referralsCount) async {
    final achievements = [
      {'name': 'First Referral', 'count': 1, 'points': 100},
      {'name': 'Referral Pro', 'count': 5, 'points': 250},
      {'name': 'Referral Master', 'count': 20, 'points': 500},
    ];

    for (final achievement in achievements) {
      final count = achievement['count'] as int;
      if (referralsCount >= count) {
        await _unlockAchievement(userId, achievement['name'] as String, 
            achievement['points'] as int, AchievementType.referral);
      }
    }
  }

  /// Check streak achievements
  Future<void> _checkStreakAchievements(String userId, int streakDays) async {
    final achievements = [
      {'name': 'Week Warrior', 'count': 7, 'points': 100},
      {'name': 'Month Master', 'count': 30, 'points': 500},
      {'name': 'Year Champion', 'count': 365, 'points': 1000},
    ];

    for (final achievement in achievements) {
      final count = achievement['count'] as int;
      if (streakDays >= count) {
        await _unlockAchievement(userId, achievement['name'] as String, 
            achievement['points'] as int, AchievementType.streak);
      }
    }
  }

  /// Unlock achievement for user
  Future<void> _unlockAchievement(String userId, String name, int points, AchievementType type) async {
    // Check if already unlocked
    final existingDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (existingDoc.docs.isNotEmpty) return;

    // Create achievement
    final achievement = Achievement(
      id: '',
      name: name,
      description: 'Unlocked: $name',
      type: type,
      pointsReward: points,
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .add(achievement.toJson());

    // Award points
    await awardPoints(userId, points, 'Achievement unlocked: $name');
  }
} 