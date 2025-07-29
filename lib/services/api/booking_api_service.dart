import 'package:appoint/models/booking.dart';
import 'package:appoint/models/business.dart';
import 'package:appoint/models/service.dart';
import 'package:appoint/services/api/api_client.dart';

class BookingApiService {
  BookingApiService._();
  static final BookingApiService _instance = BookingApiService._();
  static BookingApiService get instance => _instance;

  // Get available time slots for a service
  Future<List<DateTime>> getAvailableSlots({
    required String serviceId,
    required String businessId,
    required DateTime date,
  }) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/bookings/available-slots',
        queryParameters: {
          'serviceId': serviceId,
          'businessId': businessId,
          'date': date.toIso8601String(),
        },
      );

      final slots = response['slots'] as List;
      return slots.map((slot) => DateTime.parse(slot as String)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create a new booking
  Future<Booking> createBooking({
    required String serviceId,
    required String businessId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    List<String>? familyMemberIds,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/bookings',
        data: {
          'serviceId': serviceId,
          'businessId': businessId,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'notes': notes,
          'familyMemberIds': familyMemberIds,
        },
      );

      return Booking.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get user's bookings
  Future<List<Booking>> getUserBookings({
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/bookings',
        queryParameters: queryParams,
      );

      final bookings = response['bookings'] as List;
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get booking details
  Future<Booking> getBooking(String bookingId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/bookings/$bookingId',
      );

      return Booking.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update booking
  Future<Booking> updateBooking({
    required String bookingId,
    DateTime? startTime,
    DateTime? endTime,
    String? notes,
    String? status,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (startTime != null) data['startTime'] = startTime.toIso8601String();
      if (endTime != null) data['endTime'] = endTime.toIso8601String();
      if (notes != null) data['notes'] = notes;
      if (status != null) data['status'] = status;

      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/bookings/$bookingId',
        data: data,
      );

      return Booking.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/bookings/$bookingId/cancel',
        data: {'reason': reason},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Reschedule booking
  Future<Booking> rescheduleBooking({
    required String bookingId,
    required DateTime newStartTime,
    required DateTime newEndTime,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/bookings/$bookingId/reschedule',
        data: {
          'startTime': newStartTime.toIso8601String(),
          'endTime': newEndTime.toIso8601String(),
        },
      );

      return Booking.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get booking history
  Future<List<Booking>> getBookingHistory({
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/bookings/history',
        queryParameters: queryParams,
      );

      final bookings = response['bookings'] as List;
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get upcoming bookings
  Future<List<Booking>> getUpcomingBookings({int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/bookings/upcoming',
        queryParameters: queryParams,
      );

      final bookings = response['bookings'] as List;
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Rate a booking
  Future<void> rateBooking({
    required String bookingId,
    required int rating,
    String? review,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/bookings/$bookingId/rate',
        data: {
          'rating': rating,
          'review': review,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get booking statistics
  Future<Map<String, dynamic>> getBookingStats({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/bookings/stats',
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get family bookings
  Future<List<Booking>> getFamilyBookings({
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/bookings/family',
        queryParameters: queryParams,
      );

      final bookings = response['bookings'] as List;
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Book for family member
  Future<Booking> bookForFamilyMember({
    required String familyMemberId,
    required String serviceId,
    required String businessId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/bookings/family',
        data: {
          'familyMemberId': familyMemberId,
          'serviceId': serviceId,
          'businessId': businessId,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'notes': notes,
        },
      );

      return Booking.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
