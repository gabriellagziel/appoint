import 'package:appoint/models/hive_adapters.dart';
import 'package:appoint/services/offline_booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Example of how to initialize the offline booking system in main.dart
Future<void> initializeOfflineBookingSystem() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(OfflineBookingAdapter());
  Hive.registerAdapter(OfflineServiceOfferingAdapter());

  // Initialize the offline booking repository
  offlineRepository = OfflineBookingRepository();
  await offlineRepository.initialize();

  // Store the repository instance globally or in your dependency injection
  // For example, you could use Riverpod:
  // ref.read(REDACTED_TOKEN.notifier).state = offlineRepository;
}

// Example Riverpod provider for the offline repository
// REDACTED_TOKEN = StateNotifierProvider<OfflineBookingRepository, OfflineBookingRepository>((ref) {
//   return OfflineBookingRepository();
// });

// Example usage in a widget or service:
class BookingService {

  BookingService(this._repository);
  final OfflineBookingRepository _repository;

  Future<void> createBooking(Booking booking) async {
    try {
      await _repository.addBooking(booking);
      // Handle success
    } catch (e) {
      // Handle error
      debugPrint('Failed to create booking: $e');
    }
  }

  Future<List<Booking>> getBookings() async {
    try {
      return await _repository.getBookings();
    } catch (e) {
      debugPrint('Failed to get bookings: $e');
      return [];
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _repository.cancelBooking(bookingId);
      // Handle success
    } catch (e) {
      // Handle error
      debugPrint('Failed to cancel booking: $e');
    }
  }

  Future<void> syncPendingChanges() async {
    try {
      await _repository.syncPendingChanges();
      // Handle success
    } catch (e) {
      // Handle error
      debugPrint('Failed to sync pending changes: $e');
    }
  }

  bool get isOnline => _repository.isOnline;
  int get pendingOperationsCount => _repository.getPendingOperationsCount();
}
