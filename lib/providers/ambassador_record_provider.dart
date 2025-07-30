import 'package:appoint/models/ambassador_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ambassadorRecordProvider = FutureProvider<AmbassadorRecord?>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  final snap = await FirebaseFirestore.instance
      .collection('ambassadors')
      .where('userId', isEqualTo: uid)
      .limit(1)
      .get();
  if (snap.docs.isEmpty) return null;
  final doc = snap.docs.first;
  return AmbassadorRecord.fromJson({'id': doc.id, ...doc.data()});
});
