import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferralService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ReferralService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<String> generateReferralCode() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Return existing code if already generated
    final existing = await _firestore
        .collection('referral_codes')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      return existing.docs.first.data()['code'] as String;
    }

    String code;
    bool exists = true;
    final random = Random();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    do {
      code =
          List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
      final query = await _firestore
          .collection('referral_codes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      exists = query.docs.isNotEmpty;
    } while (exists);

    await _firestore.collection('referral_codes').add({
      'userId': user.uid,
      'code': code,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return code;
  }
}
