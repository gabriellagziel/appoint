import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/analytics.dart';
import 'package:appoint/models/appointment.dart';
import 'package:appoint/models/booking.dart';
import 'package:appoint/models/business_profile.dart';
import 'package:appoint/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Business Profile Provider
final AutoDisposeStreamProvider<BusinessProfile> businessProfileProvider =
    StreamProvider.autoDispose<BusinessProfile>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value(
      const BusinessProfile(
        name: 'Default Business',
        description: 'Default business description',
        phone: '+1234567890',
      ),
    );
  }

  return FirebaseFirestore.instance
      .collection('business_profiles')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
    if (!doc.exists) {
      return const BusinessProfile(
        name: 'Default Business',
        description: 'Default business description',
        phone: '+1234567890',
      );
    }
    return BusinessProfile.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  });
});

// Bookings Provider
final AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>>
    bookingsProvider =
    StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
  (ref) => FirebaseFirestore.instance.collection('bookings').snapshots(),
);

// Staff Availability Provider
final AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>>
    staffAvailabilityProvider =
    StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
  (ref) =>
      FirebaseFirestore.instance.collection('staff_availability').snapshots(),
);

// User-specific bookings
final StreamProviderFamily<List<Booking>, String> userBookingsProvider =
    StreamProvider.family<List<Booking>, String>((ref, final userId) {
  final service = BookingService();
  return service.getUserBookings(userId);
});

// Business-specific bookings
final StreamProviderFamily<List<Booking>, String> businessBookingsProvider =
    StreamProvider.family<List<Booking>, String>((ref, final businessId) {
  final service = BookingService();
  return service.getBusinessBookings(businessId);
});

// Clients Provider
final AutoDisposeStreamProvider<List<Map<String, dynamic>>> clientsProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>(
  (ref) => FirebaseFirestore.instance.collection('clients').snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => {
                'id': doc.id,
                ...doc.data(),
              },
            )
            .toList(),
      ),
);

// Appointments Provider
final appointmentsProvider = StreamProvider<List<Appointment>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('appointments').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => Appointment.fromJson({
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          }),
        )
        .toList(),
  );
});

// Staff Provider
final staffProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('staff').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => {
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          },
        )
        .toList(),
  );
});

// Services Provider
final servicesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('services').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => {
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          },
        )
        .toList(),
  );
});

// Rooms Provider
final roomsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('rooms').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => {
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          },
        )
        .toList(),
  );
});

// Providers Provider
final businessProvidersProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('providers').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => {
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          },
        )
        .toList(),
  );
});

// Analytics Provider
final analyticsProvider = StreamProvider<Analytics>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value(
      Analytics(
        totalUsers: 0,
        totalOrgs: 0,
        activeAppointments: 0,
      ),
    );
  }

  return FirestoreService.getDocumentStream('analytics', user.uid).map((doc) {
    if (!doc.exists) {
      return Analytics(
        totalUsers: 0,
        totalOrgs: 0,
        activeAppointments: 0,
      );
    }
    return Analytics.fromJson(doc.data()! as Map<String, dynamic>);
  });
});

// Dashboard Stats Provider
final dashboardStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final bookingsAsync = ref.watch(bookingsProvider);
  final clientsAsync = ref.watch(clientsProvider);
  final appointmentsAsync = ref.watch(appointmentsProvider);

  return {
    'totalBookings': bookingsAsync.when(
      data: (bookings) => bookings.docs.length,
      loading: () => 0,
      error: (_, final __) => 0,
    ),
    'totalClients': clientsAsync.when(
      data: (clients) => clients.length,
      loading: () => 0,
      error: (_, final __) => 0,
    ),
    'totalAppointments': appointmentsAsync.when(
      data: (appointments) => appointments.length,
      loading: () => 0,
      error: (_, final __) => 0,
    ),
    'upcomingAppointments': appointmentsAsync.when(
      data: (appointments) => appointments
          .where(
            (appointment) => appointment.scheduledAt.isAfter(DateTime.now()),
          )
          .length,
      loading: () => 0,
      error: (_, final __) => 0,
    ),
  };
});

// Messages Provider
final messagesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('messages').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => {
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          },
        )
        .toList(),
  );
});

// External Meetings Provider
final externalMeetingsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('externalMeetings').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => {
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          },
        )
        .toList(),
  );
});

// Appointment Requests Provider
final appointmentRequestsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirestoreService.getCollectionStream('appointmentRequests').map(
    (snapshot) => snapshot.docs
        .where(
          (doc) =>
              (doc.data()! as Map<String, dynamic>)['businessProfileId'] ==
              user.uid,
        )
        .map(
          (doc) => {
            'id': doc.id,
            ...(doc.data()! as Map<String, dynamic>),
          },
        )
        .toList(),
  );
});

// Firebase Auth Provider
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
