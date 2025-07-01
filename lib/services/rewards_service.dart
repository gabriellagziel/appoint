import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsService {
  final FirebaseFirestore _firestore;

  RewardsService({final FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Points awarded when a referral signs up.
  static const int referralSignupPoints = 10;

  /// Reward tier thresholds.
  static const Map<String, int> rewardTiers = {
    'bronze': 0,
    'silver': 100,
    'gold': 500,
    'platinum': 1000,
  };

  /// Increment the current user's points when a referral signs up.
  Future<int> addReferralSignupPoints(final String referrerId) async {
    return _incrementPoints(referrerId, referralSignupPoints);
  }

  /// Get the current point balance for a user.
  Future<int> getPoints(final String userId) async {
    final doc = await _firestore.collection('user_rewards').doc(userId).get();
    return (doc.data()?['points'] as int?) ?? 0;
  }

  /// Stream the point balance for a user.
  Stream<int> watchPoints(final String userId) {
    return _firestore
        .collection('user_rewards')
        .doc(userId)
        .snapshots()
        .map((final doc) => (doc.data()?['points'] as int?) ?? 0);
  }

  /// Determine the reward tier for a given point balance.
  String tierForPoints(final int points) {
    if (points >= rewardTiers['platinum']!) return 'platinum';
    if (points >= rewardTiers['gold']!) return 'gold';
    if (points >= rewardTiers['silver']!) return 'silver';
    return 'bronze';
  }

  Future<int> _incrementPoints(final String userId, final int points) async {
    final doc = _firestore.collection('user_rewards').doc(userId);
    return _firestore.runTransaction((final tx) async {
      final snapshot = await tx.get(doc);
      final current = (snapshot.data()?['points'] as int?) ?? 0;
      final updated = current + points;
      tx.set(doc, {'points': updated}, SetOptions(merge: true));
      return updated;
    });
  }

  // TODO: Implement actual rewards logic
  Future<int> getUserPoints(final String userId) async {
    // TODO: Replace with actual points retrieval from database
    return 0;
  }

  Future<void> addPoints(final String userId, final int points) async {
    // TODO: Replace with actual points addition logic
  }

  Future<void> redeemReward(final String userId, final String rewardId) async {
    // TODO: Replace with actual reward redemption logic
  }
}
