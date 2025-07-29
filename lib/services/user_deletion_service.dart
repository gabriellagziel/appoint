import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDeletionService {
  /// Constructor that accepts injected dependencies for testing
  UserDeletionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Deletes the current user account and all associated data
  Future<void> deleteCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    final uid = user.uid;

    try {
      // Delete all user data from Firestore
      await _deleteUserData(uid);

      // Delete the user from Firebase Auth
      await user.delete();

      // Sign out to clear any remaining state
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to delete user account: $e');
    }
  }

  /// Deletes all user data from Firestore collections
  Future<void> _deleteUserData(String uid) async {
    final batch = _firestore.batch();

    // Delete user profile
    batch.delete(_firestore.collection('users').doc(uid));

    // Delete user settings
    batch.delete(
      _firestore
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('notifications'),
    );

    // Delete business profile if exists
    batch.delete(_firestore.collection('business_profiles').doc(uid));

    // Delete business settings if exists
    batch.delete(_firestore.collection('businessSettings').doc(uid));

    // Delete all bookings where user is the client
    final userBookings = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in userBookings.docs) {
      batch.delete(doc.reference);
    }

    // Delete all bookings where user is the business owner
    final businessBookings = await _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: uid)
        .get();
    for (final doc in businessBookings.docs) {
      batch.delete(doc.reference);
    }

    // Delete all chat messages
    final chatMessages = await _firestore
        .collection('messages')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in chatMessages.docs) {
      batch.delete(doc.reference);
    }

    // Delete business chat messages
    final businessMessages = await _firestore
        .collection('messages')
        .where('businessId', isEqualTo: uid)
        .get();
    for (final doc in businessMessages.docs) {
      batch.delete(doc.reference);
    }

    // Delete personal appointments
    final personalAppointments = await _firestore
        .collection('personalAppointments')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in personalAppointments.docs) {
      batch.delete(doc.reference);
    }

    // Delete notifications
    final notifications = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    // Delete payments
    final payments = await _firestore
        .collection('payments')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in payments.docs) {
      batch.delete(doc.reference);
    }

    // Delete ambassador record if exists
    final ambassadorRecords = await _firestore
        .collection('ambassadors')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in ambassadorRecords.docs) {
      batch.delete(doc.reference);
    }

    // Delete family invitations
    final familyInvitations = await _firestore
        .collection('family_invitations')
        .where('parentId', isEqualTo: uid)
        .get();
    for (final doc in familyInvitations.docs) {
      batch.delete(doc.reference);
    }

    final childInvitations = await _firestore
        .collection('family_invitations')
        .where('childId', isEqualTo: uid)
        .get();
    for (final doc in childInvitations.docs) {
      batch.delete(doc.reference);
    }

    // Delete playtime sessions
    final playtimeSessions = await _firestore
        .collection('playtime_sessions')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in playtimeSessions.docs) {
      batch.delete(doc.reference);
    }

    // Delete survey responses
    final surveys = await _firestore.collection('surveys').get();
    for (final surveyDoc in surveys.docs) {
      final responses = await surveyDoc.reference
          .collection('responses')
          .where('userId', isEqualTo: uid)
          .get();
      for (final doc in responses.docs) {
        batch.delete(doc.reference);
      }
    }

    // Commit all deletions
    await batch.commit();
  }
}
