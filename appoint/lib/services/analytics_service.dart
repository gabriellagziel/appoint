import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// If you use firebase_analytics, uncomment and wire it:
// import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _fs = FirebaseFirestore.instance;
  // static final FirebaseAnalytics _fa = FirebaseAnalytics.instance; // optional

  static Future<void> log(String name, [Map<String, dynamic>? props]) async {
    try {
      // Prefer Firebase Analytics if available:
      // await _fa.logEvent(name: name, parameters: props);

      // Fallback (or dual-write) to Firestore
      final String? uid = _auth.currentUser?.uid;
      final coll = _fs
          .collection('analytics_events')
          .doc(uid ?? '_anon')
          .collection('events');
      await coll.add({
        'name': name,
        'props': props ?? <String, dynamic>{},
        'ts': FieldValue.serverTimestamp(),
        if (uid != null) 'uid': uid,
      });
    } catch (_) {
      // swallow; analytics should never break UX
    }
  }
}
