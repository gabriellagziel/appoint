import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/studio_business/models/staff_availability.dart';
import 'package:appoint/features/studio_business/services/staff_availability_service.dart';

final REDACTED_TOKEN =
    Provider<StaffAvailabilityService>((final ref) {
  return StaffAvailabilityService();
});

final staffAvailabilityProvider =
    FutureProvider.family<List<StaffAvailability>, String>(
  (final ref, final businessProfileId) async {
    final service = ref.read(REDACTED_TOKEN);
    return service.getStaffAvailability(businessProfileId);
  },
);

final staffAvailabilityByIdProvider =
    FutureProvider.family<StaffAvailability?, String>(
  (final ref, final staffProfileId) async {
    final service = ref.read(REDACTED_TOKEN);
    return service.getStaffAvailabilityById(staffProfileId);
  },
);
