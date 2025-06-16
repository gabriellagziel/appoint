import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userSubscriptionProvider = FutureProvider<bool>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return false;
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return (doc.data()?['premium'] as bool?) ?? false;
});
