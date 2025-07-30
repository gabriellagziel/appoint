import 'package:appoint/models/personal_appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalSchedulerService {
  PersonalSchedulerService({
    FirebaseFirestore? firestore,
    final FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<PersonalAppointment> get _collection => _firestore
      .collection('personalAppointments')
      .withConverter<PersonalAppointment>(
        fromFirestore: (snap, final _) =>
            PersonalAppointment.fromJson(snap.data()!),
        toFirestore: (appt, final _) => appt.toJson(),
      );

  Stream<List<PersonalAppointment>> watchAppointments() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _collection
        .where('userId', isEqualTo: uid)
        .orderBy('startTime')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Future<void> addAppointment(PersonalAppointment appt) async {
    await _collection.doc(appt.id).set(appt);
  }

  Future<void> updateAppointment(PersonalAppointment appt) async {
    await _collection.doc(appt.id).set(appt);
  }

  Future<void> deleteAppointment(String id) async {
    await _collection.doc(id).delete();
  }
}
