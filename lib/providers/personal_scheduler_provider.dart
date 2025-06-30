import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/personal_appointment.dart';
import '../services/personal_scheduler_service.dart';

final REDACTED_TOKEN =
    Provider<PersonalSchedulerService>((ref) => PersonalSchedulerService());

final personalAppointmentsProvider =
    StreamProvider<List<PersonalAppointment>>((ref) {
  return ref.watch(REDACTED_TOKEN).watchAppointments();
});
