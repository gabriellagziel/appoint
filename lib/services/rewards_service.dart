import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardsService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  RewardsService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Points awarded when a referral signs up.
  static const int referralSignupPoints = 10;

  /// Reward tier thresholds.
  static const Map<String, int> rewardTiers = {
    'bronze': 0,
    'silver': 100,
    'gold': 500,
  };

  /// Increment the current user's points when a referral signs up.
  Future<int> addReferralSignupPoints(String referrerId) async {
    return _incrementPoints(referrerId, referralSignupPoints);
  }

  /// Get the current point balance for a user.
  Future<int> getPoints(String userId) async {
    final doc = await _firestore.collection('user_rewards').doc(userId).get();
    return (doc.data()?['points'] as int?) ?? 0;
  }

  /// Stream the point balance for a user.
  Stream<int> watchPoints(String userId) {
    return _firestore
        .collection('user_rewards')
        .doc(userId)
        .snapshots()
        .map((doc) => (doc.data()?['points'] as int?) ?? 0);
  }

  /// Determine the reward tier for a given point balance.
  String tierForPoints(int points) {
    if (points >= rewardTiers['gold']!) return 'gold';
    if (points >= rewardTiers['silver']!) return 'silver';
    return 'bronze';
  }

  Future<int> _incrementPoints(String userId, int points) async {
    final doc = _firestore.collection('user_rewards').doc(userId);
    return _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(doc);
      final current = (snapshot.data()?['points'] as int?) ?? 0;
      final updated = current + points;
      tx.set(doc, {'points': updated}, SetOptions(merge: true));
      return updated;
    });
  }
}
