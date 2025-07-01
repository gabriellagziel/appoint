import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/business_profile.dart';
import 'package:appoint/models/booking.dart';
import 'package:appoint/models/appointment.dart';
import 'package:appoint/models/analytics.dart';
import 'package:appoint/services/firestore_service.dart';
import 'package:appoint/features/booking/services/booking_service.dart';

// Business Profile Provider
final businessProfileProvider =
    StreamProvider.autoDispose<BusinessProfile>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return Stream.value(const BusinessProfile(
      name: 'Default Business',
      description: 'Default business description',
      phone: '+1234567890',
    ));

  return FirebaseFirestore.instance
      .collection('business_profiles')
      .doc(user.uid)
      .snapshots()
      .map((final doc) {
    if (!doc.exists) {
      return const BusinessProfile(
        name: 'Default Business',
        description: 'Default business description',
        phone: '+1234567890',
      );
    }
    return BusinessProfile.fromJson({
      'id': doc.id,
      ...(doc.data() as Map<String, dynamic>),
    });
  });
});

// Bookings Provider
final bookingsProvider =
    StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
  (final ref) => FirebaseFirestore.instance.collection('bookings').snapshots(),
);

// Staff Availability Provider
final staffAvailabilityProvider =
    StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
  (final ref) =>
      FirebaseFirestore.instance.collection('staff_availability').snapshots(),
);

// User-specific bookings
final userBookingsProvider =
    StreamProvider.family<List<Booking>, String>((final ref, final userId) {
  final service = BookingService();
  return service.getUserBookings(userId);
});

// Business-specific bookings
final businessBookingsProvider =
    StreamProvider.family<List<Booking>, String>((final ref, final businessId) {
  final service = BookingService();
  return service.getBusinessBookings(businessId);
});

// Clients Provider
final clientsProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>(
  (final ref) => FirebaseFirestore.instance.collection('clients').snapshots().map(
        (final snapshot) => snapshot.docs
            .map((final doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList(),
      ),
);

// Appointments Provider
final appointmentsProvider = StreamProvider<List<Appointment>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('appointments').map((final snapshot) =>
      snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => Appointment.fromJson({
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              }))
          .toList());
});

// Staff Provider
final staffProvider = StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('staff').map((final snapshot) =>
      snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList());
});

// Services Provider
final servicesProvider = StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream(
          'services')
      .map((final snapshot) => snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList());
});

// Rooms Provider
final roomsProvider = StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('rooms').map((final snapshot) =>
      snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList());
});

// Providers Provider
final businessProvidersProvider =
    StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('providers').map((final snapshot) =>
      snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList());
});

// Analytics Provider
final analyticsProvider = StreamProvider<Analytics>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(Analytics(
    totalUsers: 0,
    totalOrgs: 0,
    activeAppointments: 0,
  ));

  return FirestoreService.getDocumentStream('analytics', user.uid).map((final doc) {
    if (!doc.exists) return Analytics(
      totalUsers: 0,
      totalOrgs: 0,
      activeAppointments: 0,
    );
    return Analytics.fromJson(doc.data() as Map<String, dynamic>);
  });
});

// Dashboard Stats Provider
final dashboardStatsProvider = Provider<Map<String, dynamic>>((final ref) {
  final bookingsAsync = ref.watch(bookingsProvider);
  final clientsAsync = ref.watch(clientsProvider);
  final appointmentsAsync = ref.watch(appointmentsProvider);

  return {
    'totalBookings': bookingsAsync.when(
      data: (final bookings) => bookings.docs.length,
      loading: () => 0,
      error: (final _, final __) => 0,
    ),
    'totalClients': clientsAsync.when(
      data: (final clients) => clients.length,
      loading: () => 0,
      error: (final _, final __) => 0,
    ),
    'totalAppointments': appointmentsAsync.when(
      data: (final appointments) => appointments.length,
      loading: () => 0,
      error: (final _, final __) => 0,
    ),
    'upcomingAppointments': appointmentsAsync.when(
      data: (final appointments) => appointments
          .where(
              (final appointment) => appointment.scheduledAt.isAfter(DateTime.now()))
          .length,
      loading: () => 0,
      error: (final _, final __) => 0,
    ),
  };
});

// Messages Provider
final messagesProvider = StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream(
          'messages')
      .map((final snapshot) => snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList());
});

// External Meetings Provider
final externalMeetingsProvider =
    StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('externalMeetings').map(
      (final snapshot) => snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList());
});

// Appointment Requests Provider
final appointmentRequestsProvider =
    StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('appointmentRequests').map(
      (final snapshot) => snapshot.docs
          .where((final doc) =>
              (doc.data() as Map<String, dynamic>)['businessProfileId'] ==
              user.uid)
          .map((final doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList());
});

// Firebase Auth Provider
final firebaseAuthProvider =
    Provider<FirebaseAuth>((final ref) => FirebaseAuth.instance);
