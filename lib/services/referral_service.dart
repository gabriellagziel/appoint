import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferralService {
  ReferralService({
    FirebaseFirestore? firestore,
    final FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<String> generateReferralCode(String userId) async {
    final docRef = _firestore.collection('referrals').doc(userId);
    final existing = await docRef.get();
    final data = existing.data();
    if (data != null && data['code'] is String) {
      return data['code'] as String;
    }

    String code = '';
    var exists = true;
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    do {
      code =
          List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
      final query = await _firestore
          .collection('referrals')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      exists = query.docs.isNotEmpty;
    } while (exists);

    await docRef.set({
      'userId': userId,
      'code': code,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return code;
  }

  Future<String> generateReferralCodeForCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return generateReferralCode(user.uid);
  }
}
