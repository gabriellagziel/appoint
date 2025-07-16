import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appoint/models/studio_appointment.dart';
import 'package:appoint/models/business_profile.dart';

class StudioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Create a new appointment
  Future<void> createAppointment(StudioAppointment appointment) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore.collection('bookings').add({
      'businessId': currentUserId,
      'customerId': appointment.customerId,
      'customerName': appointment.customerName,
      'date': appointment.date.toIso8601String(),
      'time': appointment.time,
      'duration': appointment.duration.inMinutes,
      'service': appointment.service,
      'status': appointment.status,
      'notes': appointment.notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get appointments for the current business
  Stream<List<StudioAppointment>> getAppointments() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: currentUserId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudioAppointment.fromFirestore(doc))
            .toList());
  }

  /// Get today's appointments
  Stream<List<StudioAppointment>> getTodayAppointments() {
    if (currentUserId == null) return Stream.value([]);

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: currentUserId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThan: endOfDay.toIso8601String())
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudioAppointment.fromFirestore(doc))
            .toList());
  }

  /// Update appointment status
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    await _firestore.collection('bookings').doc(appointmentId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('bookings').doc(appointmentId).delete();
  }

  /// Get business profile
  Future<BusinessProfile?> getBusinessProfile() async {
    if (currentUserId == null) return null;

    final doc = await _firestore
        .collection('businesses')
        .doc(currentUserId)
        .get();

    if (doc.exists) {
      return BusinessProfile.fromFirestore(doc);
    }
    return null;
  }

  /// Update business profile
  Future<void> updateBusinessProfile(BusinessProfile profile) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('businesses')
        .doc(currentUserId)
        .set(profile.toFirestore(), SetOptions(merge: true));
  }

  /// Get clients for the business
  Stream<List<Map<String, dynamic>>> getClients() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          final clients = <String, Map<String, dynamic>>{};
          
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final customerId = data['customerId'] as String?;
            final customerName = data['customerName'] as String?;
            
            if (customerId != null && customerName != null) {
              if (!clients.containsKey(customerId)) {
                clients[customerId] = {
                  'id': customerId,
                  'name': customerName,
                  'appointmentCount': 0,
                  'lastAppointment': null,
                };
              }
              clients[customerId]!['appointmentCount'] = 
                  (clients[customerId]!['appointmentCount'] as int) + 1;
              
              final appointmentDate = DateTime.tryParse(data['date'] ?? '');
              if (appointmentDate != null) {
                final lastAppointment = clients[customerId]!['lastAppointment'] as DateTime?;
                if (lastAppointment == null || appointmentDate.isAfter(lastAppointment)) {
                  clients[customerId]!['lastAppointment'] = appointmentDate;
                }
              }
            }
          }
          
          return clients.values.toList();
        });
  }

  /// Get appointment statistics
  Future<Map<String, dynamic>> getAppointmentStats() async {
    if (currentUserId == null) return {};

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final monthlyQuery = await _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: currentUserId)
        .where('date', isGreaterThanOrEqualTo: startOfMonth.toIso8601String())
        .where('date', isLessThan: endOfMonth.toIso8601String())
        .get();

    final totalQuery = await _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: currentUserId)
        .get();

    final confirmedQuery = await _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'confirmed')
        .get();

    final pendingQuery = await _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    return {
      'totalAppointments': totalQuery.docs.length,
      'monthlyAppointments': monthlyQuery.docs.length,
      'confirmedAppointments': confirmedQuery.docs.length,
      'pendingAppointments': pendingQuery.docs.length,
      'cancelledAppointments': totalQuery.docs.length - 
          confirmedQuery.docs.length - pendingQuery.docs.length,
    };
  }

  /// Check if business profile exists
  Future<bool> hasBusinessProfile() async {
    if (currentUserId == null) return false;

    final doc = await _firestore
        .collection('businesses')
        .doc(currentUserId)
        .get();

    return doc.exists;
  }

  /// Create initial business profile
  Future<void> createInitialBusinessProfile(String businessName) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final profile = BusinessProfile(
      id: currentUserId!,
      name: businessName,
      description: '',
      address: '',
      phone: '',
      email: _auth.currentUser?.email ?? '',
      services: [],
      workingHours: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await updateBusinessProfile(profile);
  }
}
