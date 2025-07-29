import 'package:appoint/models/appointment.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/appointment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appointmentServiceProvider =
    Provider<AppointmentService>((ref) => AppointmentService());

final appointmentsStreamProvider = StreamProvider<List<Appointment>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value([]);
      }
      return ref.read(appointmentServiceProvider).watchMyAppointments(user.uid);
    },
    loading: () => Stream.value([]),
    error: (_, final __) => Stream.value([]),
  );
});
