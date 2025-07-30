import 'package:appoint/features/studio_business/models/staff_availability.dart';
import 'package:appoint/features/studio_business/services/staff_availability_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffAvailabilityServiceProvider =
    Provider<StaffAvailabilityService>((ref) => StaffAvailabilityService());

final FutureProviderFamily<List<StaffAvailability>, String>
    staffAvailabilityProvider =
    FutureProvider.family<List<StaffAvailability>, String>(
  (ref, final businessProfileId) async {
    final service = ref.read(staffAvailabilityServiceProvider);
    return service.getStaffAvailability(businessProfileId);
  },
);

final FutureProviderFamily<StaffAvailability?, String>
    staffAvailabilityByIdProvider =
    FutureProvider.family<StaffAvailability?, String>(
  (ref, final staffProfileId) async {
    final service = ref.read(staffAvailabilityServiceProvider);
    return service.getStaffAvailabilityById(staffProfileId);
  },
);
