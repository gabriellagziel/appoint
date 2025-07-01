import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/studio_appointment.dart';

class StudioAppointmentService {
  final FirebaseFirestore _firestore;
  StudioAppointmentService({final FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('studio_appointments');

  Future<List<StudioAppointment>> fetchAppointments() async {
    final snap = await _col.get();
    return snap.docs
        .map((final d) => StudioAppointment.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<void> addAppointment(final StudioAppointment appt) async {
    final doc = _col.doc(appt.id.isEmpty ? null : appt.id);
    await doc.set(appt.copyWith(id: doc.id).toJson());
  }

  Future<void> updateAppointment(final StudioAppointment appt) async {
    await _col.doc(appt.id).set(appt.toJson());
  }

  Future<void> deleteAppointment(final String id) async {
    await _col.doc(id).delete();
  }
}
