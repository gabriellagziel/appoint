import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/personal_appointment.dart';
import 'package:appoint/services/personal_scheduler_service.dart';

final REDACTED_TOKEN = Provider<PersonalSchedulerService>(
    (final ref) => PersonalSchedulerService());

final personalAppointmentsProvider =
    StreamProvider<List<PersonalAppointment>>((final ref) {
  return ref.watch(REDACTED_TOKEN).watchAppointments();
});
