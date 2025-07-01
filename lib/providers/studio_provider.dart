import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/studio_service.dart';
import 'package:appoint/models/staff_member.dart';
import 'package:appoint/models/staff_availability.dart';

final studioServiceProvider = Provider<StudioService>((final ref) => StudioService());

final staffListProvider =
    FutureProvider.family<List<StaffMember>, String>((final ref, final studioId) {
  return ref.read(studioServiceProvider).fetchStaff(studioId);
});

final staffAvailabilityProvider =
    FutureProvider.family<StaffAvailability, Map<String, dynamic>>(
        (final ref, final params) {
  return ref
      .read(studioServiceProvider)
      .fetchAvailability(params['staffId'] as String, params['date'] as DateTime);
});
