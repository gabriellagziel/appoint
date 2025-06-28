import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferralService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ReferralService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Generates a referral code for the currently signed in user.
  /// If a code already exists it will be returned instead of creating a new one.
  Future<String> generateReferralCode() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    final docRef = _firestore.collection('referralCodes').doc(user.uid);
    final existing = await docRef.get();
    if (existing.exists && existing.data()?['code'] != null) {
      return existing.data()!['code'] as String;
    }

    String code;
    do {
      code = _randomCode();
      final query = await _firestore
          .collection('referralCodes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (query.docs.isEmpty) break;
    } while (true);

    await docRef.set({
      'code': code,
      'usageCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return code;
  }

  /// Listens to changes in the current user's referral usage count.
  Stream<int> listenToReferralUsage() {
    final user = _auth.currentUser;
    if (user == null) return const Stream<int>.empty();
    return _firestore
        .collection('referralCodes')
        .doc(user.uid)
        .snapshots()
        .map((snap) => (snap.data()?['usageCount'] ?? 0) as int);
  }

  String _randomCode([int length = 6]) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }
}
