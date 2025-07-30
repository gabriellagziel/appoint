import 'package:appoint/models/studio_appointment.dart';
import 'package:appoint/services/studio_appointment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final REDACTED_TOKEN = Provider<StudioAppointmentService>(
  (ref) => StudioAppointmentService(),
);

class StudioAppointmentsNotifier
    extends StateNotifier<AsyncValue<List<StudioAppointment>>> {
  StudioAppointmentsNotifier(this._service)
      : super(const AsyncValue.loading()) {
    load();
  }
  final StudioAppointmentService _service;

  Future<void> load() async {
    try {
      final data = await _service.fetchAppointments();
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> add(StudioAppointment appt) async {
    await _service.addAppointment(appt);
    await load();
  }

  Future<void> update(StudioAppointment appt) async {
    await _service.updateAppointment(appt);
    await load();
  }

  Future<void> delete(String id) async {
    await _service.deleteAppointment(id);
    await load();
  }
}

final studioAppointmentsProvider = StateNotifierProvider<
    StudioAppointmentsNotifier, AsyncValue<List<StudioAppointment>>>(
  (ref) =>
      StudioAppointmentsNotifier(ref.read(REDACTED_TOKEN)),
);
