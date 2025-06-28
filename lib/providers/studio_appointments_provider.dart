import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/studio_appointment.dart';
import '../services/studio_appointment_service.dart';

final studioAppointmentServiceProvider =
    Provider<StudioAppointmentService>((ref) => StudioAppointmentService());

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
      StudioAppointmentsNotifier(ref.read(studioAppointmentServiceProvider)),
);
