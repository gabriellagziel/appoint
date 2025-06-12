import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/studio_service.dart';
import '../models/staff_member.dart';
import '../models/staff_availability.dart';

final studioServiceProvider = Provider<StudioService>((ref) => StudioService());

final staffListProvider =
    FutureProvider.family<List<StaffMember>, String>((ref, studioId) {
  return ref.read(studioServiceProvider).fetchStaff(studioId);
});

final staffAvailabilityProvider =
    FutureProvider.family<StaffAvailability, Map<String, dynamic>>(
        (ref, params) {
  return ref
      .read(studioServiceProvider)
      .fetchAvailability(params['staffId'] as String, params['date'] as DateTime);
});
