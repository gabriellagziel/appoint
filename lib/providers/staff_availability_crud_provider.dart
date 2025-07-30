import 'package:appoint/models/staff_availability.dart';
import 'package:appoint/services/staff_availability_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffAvailabilityServiceProvider = Provider<StaffAvailabilityService>(
  (ref) => StaffAvailabilityService(),
);

class StaffAvailabilityNotifier
    extends StateNotifier<AsyncValue<List<StaffAvailability>>> {
  StaffAvailabilityNotifier(this._service, this.staffId)
      : super(const AsyncValue.loading()) {
    load();
  }
  final StaffAvailabilityService _service;
  final String staffId;

  Future<void> load() async {
    try {
      final data = await _service.fetchAvailability(staffId);
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> save(StaffAvailability avail) async {
    await _service.saveAvailability(avail);
    await load();
  }

  Future<void> delete(DateTime date) async {
    await _service.deleteAvailability(staffId, date);
    await load();
  }
}

final StateNotifierProviderFamily<StaffAvailabilityNotifier,
        AsyncValue<List<StaffAvailability>>, String> staffAvailabilityProvider =
    StateNotifierProvider.family<StaffAvailabilityNotifier,
        AsyncValue<List<StaffAvailability>>, String>(
  (ref, final staffId) => StaffAvailabilityNotifier(
    ref.read(staffAvailabilityServiceProvider),
    staffId,
  ),
);
