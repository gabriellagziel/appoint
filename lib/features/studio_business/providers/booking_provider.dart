import 'package:appoint/features/studio_business/models/studio_booking.dart';
import 'package:appoint/features/studio_business/services/studio_booking_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studioBookingServiceProvider =
    Provider<StudioBookingService>((ref) => StudioBookingService());

final userBookingsProvider = FutureProvider<List<StudioBooking>>((ref) async {
  final service = ref.read(studioBookingServiceProvider);
  return service.getUserBookings();
});

final FutureProviderFamily<List<StudioBooking>, String>
    businessBookingsProvider =
    FutureProvider.family<List<StudioBooking>, String>(
  (ref, final businessProfileId) async {
    final service = ref.read(studioBookingServiceProvider);
    return service.getBusinessBookings(businessProfileId);
  },
);

final bookingProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<StudioBooking?>>(
  (ref) => BookingNotifier(ref.read(studioBookingServiceProvider)),
);

class BookingNotifier extends StateNotifier<AsyncValue<StudioBooking?>> {
  BookingNotifier(this._service) : super(const AsyncValue.data(null));
  final StudioBookingService _service;

  Future<void> createBooking({
    required final String staffProfileId,
    required final String businessProfileId,
    required final DateTime date,
    required final String startTime,
    required final String endTime,
    required final double cost,
  }) async {
    state = const AsyncValue.loading();
    try {
      final booking = await _service.createBooking(
        staffProfileId: staffProfileId,
        businessProfileId: businessProfileId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        cost: cost,
      );
      state = AsyncValue.data(booking);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> submitBooking({
    required final String staffProfileId,
    required final String businessProfileId,
    required final DateTime date,
    required final String startTime,
    required final String endTime,
    required final double cost,
  }) async {
    state = const AsyncValue.loading();
    try {
      final booking = await _service.createBooking(
        staffProfileId: staffProfileId,
        businessProfileId: businessProfileId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        cost: cost,
      );
      state = AsyncValue.data(booking);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateBookingStatus(
    String bookingId,
    final String status,
  ) async {
    try {
      await _service.updateBookingStatus(bookingId, status);
      // Refresh the booking data
      if (state.value != null && state.value!.id == bookingId) {
        final updatedBooking = StudioBooking(
          id: state.value!.id,
          customerId: state.value!.customerId,
          staffProfileId: state.value!.staffProfileId,
          businessProfileId: state.value!.businessProfileId,
          date: state.value!.date,
          startTime: state.value!.startTime,
          endTime: state.value!.endTime,
          cost: state.value!.cost,
          status: status,
          createdAt: state.value!.createdAt,
          updatedAt: DateTime.now(),
        );
        state = AsyncValue.data(updatedBooking);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }
}
