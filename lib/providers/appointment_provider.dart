import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/appointment.dart';
import '../services/appointment_service.dart';
import 'auth_provider.dart';

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
    error: (_, __) => Stream.value([]),
  );
});
