import 'package:appoint/models/personal_appointment.dart';
import 'package:appoint/services/personal_scheduler_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final REDACTED_TOKEN = Provider<PersonalSchedulerService>(
  (ref) => PersonalSchedulerService(),
);

final personalAppointmentsProvider = StreamProvider<List<PersonalAppointment>>(
    (ref) => ref.watch(REDACTED_TOKEN).watchAppointments());
