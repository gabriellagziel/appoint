import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:appoint/models/personal_appointment.dart';

class PersonalSchedulerService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PersonalSchedulerService({final FirebaseFirestore? firestore, final FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<PersonalAppointment> get _collection => _firestore
      .collection('personalAppointments')
      .withConverter<PersonalAppointment>(
        fromFirestore: (final snap, final _) => PersonalAppointment.fromJson(snap.data()!),
        toFirestore: (final appt, final _) => appt.toJson(),
      );

  Stream<List<PersonalAppointment>> watchAppointments() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _collection
        .where('userId', isEqualTo: uid)
        .orderBy('startTime')
        .snapshots()
        .map((final snap) => snap.docs.map((final d) => d.data()).toList());
  }

  Future<void> addAppointment(final PersonalAppointment appt) async {
    await _collection.doc(appt.id).set(appt);
  }

  Future<void> updateAppointment(final PersonalAppointment appt) async {
    await _collection.doc(appt.id).set(appt);
  }

  Future<void> deleteAppointment(final String id) async {
    await _collection.doc(id).delete();
  }
}
