import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSubscriptionProvider = FutureProvider<bool>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return false;
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = doc.data();
  if (data == null) return false;
  final isAdminFreeAccess = data['isAdminFreeAccess'] as bool? ?? false;
  final isPremium = data['premium'] as bool? ?? false;
  return isAdminFreeAccess || isPremium;
});
