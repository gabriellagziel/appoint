import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment.dart';
import 'notification_service.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Appointment> createScheduled({
    required String creatorId,
    required String inviteeId,
    required DateTime scheduledAt,
  }) async {
    final doc = _firestore.collection('appointments').doc();
    final appointment = Appointment(
      id: doc.id,
      creatorId: creatorId,
      inviteeId: inviteeId,
      scheduledAt: scheduledAt,
      type: AppointmentType.scheduled,
    );
    await doc.set(appointment.toMap());
    await NotificationService().sendNotificationToUser(
        inviteeId, 'New Appointment', 'You have a new booking');
    return appointment;
  }

  Future<Appointment> createOpenCallRequest({
    required String creatorId,
    required String inviteeId,
  }) async {
    final doc = _firestore.collection('appointments').doc();
    final callRequestId = _firestore.collection('callRequests').doc().id;
    final appointment = Appointment(
      id: doc.id,
      creatorId: creatorId,
      inviteeId: inviteeId,
      scheduledAt: DateTime.now(),
      type: AppointmentType.openCall,
      callRequestId: callRequestId,
    );
    await doc.set(appointment.toMap());
    await NotificationService().sendNotificationToUser(
        inviteeId, 'New Call Request', 'You have a new call request');
    return appointment;
  }

  Stream<List<Appointment>> watchMyAppointments(String userId) {
    return _firestore
        .collection('appointments')
        .where('creatorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromMap(doc.data(), doc.id))
            .toList());
  }
}
