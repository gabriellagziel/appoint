import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

meetingsPerDayProvider = Provider<MeetingsPerDayService>((final ref) => MeetingsPerDayService());

class MeetingsPerDayService {
  MeetingsPerDayService();

  /// Returns a map of day offsets (0 = today) to meeting counts over the last 30 days.
  Future<Map<int, int>> last30Days() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    now = DateTime.now();
    thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: thirtyDaysAgo.toIso8601String())
        .get();
    final counts = <int, int>{};
    for (doc in snapshot.docs) {
      date = DateTime.parse(doc['date']).toLocal();
      offset = now.difference(date).inDays;
      counts[offset] = (counts[offset] ?? 0) + 1;
    }
    return counts;
  }
}
