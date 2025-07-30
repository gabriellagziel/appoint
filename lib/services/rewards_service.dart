import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reward_tier.dart';

class RewardsService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  RewardsService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Adds [points] to the currently authenticated user.
  Future<void> addPoints(int points) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final ref = _firestore.collection('rewards').doc(uid);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(ref);
      final current = doc.exists ? (doc.data()?['points'] ?? 0) as int : 0;
      tx.set(ref, {'points': current + points});
    });
  }

  /// Returns a stream of the user's points.
  Stream<int> watchPoints(String uid) {
    return _firestore.collection('rewards').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return 0;
      return (doc.data()?['points'] ?? 0) as int;
    });
  }

  /// Fetches the user's current points once.
  Future<int> getPoints(String uid) async {
    final doc = await _firestore.collection('rewards').doc(uid).get();
    if (!doc.exists) return 0;
    return (doc.data()?['points'] ?? 0) as int;
  }

  /// Predefined reward tiers.
  List<RewardTier> get rewardTiers => const [
        RewardTier(name: 'Bronze', pointsRequired: 100),
        RewardTier(name: 'Silver', pointsRequired: 500),
        RewardTier(name: 'Gold', pointsRequired: 1000),
      ];
}
