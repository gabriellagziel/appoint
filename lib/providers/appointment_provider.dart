import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/appointment.dart';
import 'package:appoint/services/appointment_service.dart';
import 'package:appoint/providers/auth_provider.dart';

final appointmentServiceProvider =
    Provider<AppointmentService>((final ref) => AppointmentService());

final appointmentsStreamProvider =
    StreamProvider<List<Appointment>>((final ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (final user) {
      if (user == null) {
        return Stream.value([]);
      }
      return ref.read(appointmentServiceProvider).watchMyAppointments(user.uid);
    },
    loading: () => Stream.value([]),
    error: (final _, final __) => Stream.value([]),
  );
});
