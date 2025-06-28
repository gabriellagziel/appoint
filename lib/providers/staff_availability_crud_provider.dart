import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/staff_availability.dart';
import '../services/staff_availability_service.dart';

final staffAvailabilityServiceProvider =
    Provider<StaffAvailabilityService>((ref) => StaffAvailabilityService());

class StaffAvailabilityNotifier
    extends StateNotifier<AsyncValue<List<StaffAvailability>>> {
  final StaffAvailabilityService _service;
  final String staffId;
  StaffAvailabilityNotifier(this._service, this.staffId)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final data = await _service.fetchAvailability(staffId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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

final staffAvailabilityProvider = StateNotifierProvider.family<
    StaffAvailabilityNotifier, AsyncValue<List<StaffAvailability>>, String>(
  (ref, staffId) => StaffAvailabilityNotifier(
      ref.read(staffAvailabilityServiceProvider), staffId),
);
