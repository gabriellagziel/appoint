import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/studio_appointment.dart';
import 'package:appoint/services/studio_appointment_service.dart';

final REDACTED_TOKEN = Provider<StudioAppointmentService>(
    (final ref) => StudioAppointmentService());

class StudioAppointmentsNotifier
    extends StateNotifier<AsyncValue<List<StudioAppointment>>> {
  final StudioAppointmentService _service;
  StudioAppointmentsNotifier(this._service)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final data = await _service.fetchAppointments();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(final StudioAppointment appt) async {
    await _service.addAppointment(appt);
    await load();
  }

  Future<void> update(final StudioAppointment appt) async {
    await _service.updateAppointment(appt);
    await load();
  }

  Future<void> delete(final String id) async {
    await _service.deleteAppointment(id);
    await load();
  }
}

final studioAppointmentsProvider = StateNotifierProvider<
    StudioAppointmentsNotifier, AsyncValue<List<StudioAppointment>>>(
  (final ref) =>
      StudioAppointmentsNotifier(ref.read(REDACTED_TOKEN)),
);
