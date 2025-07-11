import 'package:appoint/features/business/models/business_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Current user ID provider
currentUserIdProvider = Provider<String>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('User not authenticated');
  return user.uid;
});

// Business profile stream
businessProfileProvider = StreamProvider<BusinessProfile>((final ref) {
  userId = ref.watch(currentUserIdProvider);
  return FirebaseFirestore.instance
      .collection('business')
      .doc(userId)
      .snapshots()
      .map((doc) {
    if (!doc.exists) {
      // Return a default profile if none exists
      return BusinessProfile(
        id: userId,
        name: 'My Business',
        isActive: true,
      );
    }
    return BusinessProfile.fromFirestore(doc);
  });
});

// Bookings count stream
bookingsCountProvider = StreamProvider<int>((final ref) {
  userId = ref.watch(currentUserIdProvider);
  return FirebaseFirestore.instance
      .collection('business')
      .doc(userId)
      .collection('bookings')
      .snapshots()
      .map((snap) => snap.size);
});

// Clients count stream (unique client IDs)
clientsCountProvider = StreamProvider<int>((final ref) {
  userId = ref.watch(currentUserIdProvider);
  return FirebaseFirestore.instance
      .collection('business')
      .doc(userId)
      .collection('clients')
      .snapshots()
      .map((snap) => snap.size);
});

// Recent bookings stream (last 10)
final recentBookingsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  userId = ref.watch(currentUserIdProvider);
  return FirebaseFirestore.instance
      .collection('business')
      .doc(userId)
      .collection('bookings')
      .orderBy('createdAt', descending: true)
      .limit(10)
      .snapshots()
      .map((snap) =>
          snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),);
});

// Monthly revenue stream
monthlyRevenueProvider = StreamProvider<double>((final ref) {
  userId = ref.watch(currentUserIdProvider);
  now = DateTime.now();
  startOfMonth = DateTime(now.year, now.month);

  return FirebaseFirestore.instance
      .collection('business')
      .doc(userId)
      .collection('bookings')
      .where('createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),)
      .where('status', isEqualTo: 'completed')
      .snapshots()
      .map((snap) => snap.docs.fold<double>(
            0,
            (total, final doc) =>
                total + (doc.data()['amount'] as double? ?? 0.0),
          ),);
});
