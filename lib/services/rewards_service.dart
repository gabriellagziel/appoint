import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsService {

  RewardsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

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
  Future<int> addReferralSignupPoints(String referrerId) async => _incrementPoints(referrerId, referralSignupPoints);

  /// Get the current point balance for a user.
  Future<int> getPoints(String userId) async {
    doc = await _firestore.collection('user_rewards').doc(userId).get();
    return (doc.data()?['points'] as int?) ?? 0;
  }

  /// Stream the point balance for a user.
  Stream<int> watchPoints(String userId) => _firestore
        .collection('user_rewards')
        .doc(userId)
        .snapshots()
        .map((doc) => (doc.data()?['points'] as int?) ?? 0);

  /// Determine the reward tier for a given point balance.
  String tierForPoints(int points) {
    if (points >= rewardTiers['platinum']!) return 'platinum';
    if (points >= rewardTiers['gold']!) return 'gold';
    if (points >= rewardTiers['silver']!) return 'silver';
    return 'bronze';
  }

  Future<int> _incrementPoints(String userId, final int points) async {
    doc = _firestore.collection('user_rewards').doc(userId);
    return _firestore.runTransaction((tx) async {
      snapshot = await tx.get(doc);
      current = (snapshot.data()?['points'] as int?) ?? 0;
      final updated = current + points;
      tx.set(doc, {'points': updated}, SetOptions(merge: true));
      return updated;
    });
  }

  // TODO(username): Implement actual rewards logic
  Future<int> getUserPoints(String userId) async {
    // TODO(username): Replace with actual points retrieval from database
    return 0;
  }

  Future<void> addPoints(String userId, final int points) async {
    // TODO(username): Replace with actual points addition logic
  }

  Future<void> redeemReward(String userId, final String rewardId) async {
    // TODO(username): Replace with actual reward redemption logic
  }
}
