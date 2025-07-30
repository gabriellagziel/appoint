import 'package:appoint/models/staff_availability.dart';
import 'package:appoint/models/staff_member.dart';
import 'package:appoint/services/studio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studioServiceProvider = Provider<StudioService>((ref) => StudioService());

final FutureProviderFamily<List<StaffMember>, String> staffListProvider =
    FutureProvider.family<List<StaffMember>, String>(
  (ref, final studioId) => ref.read(studioServiceProvider).fetchStaff(studioId),
);

final FutureProviderFamily<StaffAvailability, Map<String, dynamic>>
    staffAvailabilityProvider =
    FutureProvider.family<StaffAvailability, Map<String, dynamic>>(
  (ref, final params) => ref.read(studioServiceProvider).fetchAvailability(
        params['staffId'] as String,
        params['date'] as DateTime,
      ),
);
