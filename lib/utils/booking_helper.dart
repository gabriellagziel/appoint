// ignore_for_file: use_of_void_result
import 'dart:async';

import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/appointment.dart';
import 'package:appoint/models/booking.dart';
import 'package:appoint/services/appointment_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingHelper {

  BookingHelper({
    final BookingService? bookingService,
    final AppointmentService? appointmentService,
    final NotificationService? notificationService,
    final FirebaseFirestore? firestore,
  })  : _bookingService = bookingService ?? BookingService(),
        _appointmentService = appointmentService ?? AppointmentService(),
        _notificationService = notificationService ?? NotificationService(),
        _firestore = firestore ?? FirebaseFirestore.instance;
  final BookingService _bookingService;
  final AppointmentService _appointmentService;
  final NotificationService _notificationService;
  final FirebaseFirestore _firestore;

  /// Create a new booking with comprehensive validation and error handling
  Future<BookingResult> createBooking({
    required final String userId,
    required final String staffId,
    required final String serviceId,
    required final String serviceName,
    required final DateTime dateTime,
    required final Duration duration,
    final String? notes,
    final String? studioId,
    final Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Validate booking parameters
      final validationResult = await _validateBooking(
        userId: userId,
        staffId: staffId,
        serviceId: serviceId,
        dateTime: dateTime,
        duration: duration,
      );

      if (!validationResult.isValid) {
        return BookingResult.error(validationResult.errorMessage!);
      }

      // Check for conflicts
      final hasConflict = await _checkBookingConflict(
        staffId: staffId,
        dateTime: dateTime,
        duration: duration,
      );

      if (hasConflict) {
        return BookingResult.error('Time slot is not available');
      }

      // Create booking
      final booking = Booking(
        id: '',
        userId: userId,
        staffId: staffId,
        serviceId: serviceId,
        serviceName: serviceName,
        dateTime: dateTime,
        duration: duration,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _bookingService.submitBooking(booking);
      final createdBooking =
          booking.copyWith(id: booking.id.isEmpty ? 'temp_id' : booking.id);

      // Create corresponding appointment
      final appointment = await _appointmentService.createScheduled(
        creatorId: userId,
        inviteeId: staffId,
        scheduledAt: dateTime,
      );

      // Send notifications (fire and forget)
      // ignore: unawaited_futures
      unawaited(_sendBookingNotifications(createdBooking, appointment));

      // Track booking analytics (fire and forget)
      // ignore: unawaited_futures
      unawaited(_trackBookingAnalytics(createdBooking, studioId));

      return BookingResult.success(createdBooking, appointment);
    } catch (e) {
      return BookingResult.error('Failed to create booking: $e');
    }
  }

  /// Update an existing booking
  Future<BookingResult> updateBooking({
    required final String bookingId,
    final DateTime? newDateTime,
    final Duration? newDuration,
    final String? newNotes,
    final String? newStatus,
  }) async {
    try {
      existingBooking = await _bookingService.getBookingById(bookingId);
      if (existingBooking == null) {
        return BookingResult.error('Booking not found');
      }

      // Validate new time if provided
      if (newDateTime != null) {
        final validationResult = await _validateBooking(
          userId: existingBooking.userId,
          staffId: existingBooking.staffId,
          serviceId: existingBooking.serviceId,
          dateTime: newDateTime,
          duration: newDuration ?? existingBooking.duration,
        );

        if (!validationResult.isValid) {
          return BookingResult.error(validationResult.errorMessage!);
        }

        // Check for conflicts excluding current booking
        final hasConflict = await _checkBookingConflict(
          staffId: existingBooking.staffId,
          dateTime: newDateTime,
          duration: newDuration ?? existingBooking.duration,
          excludeBookingId: bookingId,
        );

        if (hasConflict) {
          return BookingResult.error('New time slot is not available');
        }
      }

      // Update booking
      final updatedBooking = existingBooking.copyWith(
        dateTime: newDateTime ?? existingBooking.dateTime,
        duration: newDuration ?? existingBooking.duration,
        notes: newNotes ?? existingBooking.notes,
      );

      await _bookingService.updateBooking(updatedBooking);

      // Update corresponding appointment if time changed
      if (newDateTime != null) {
        // Find and update appointment
        await _updateAppointmentTime(bookingId, newDateTime);
      }

      return BookingResult.success(updatedBooking, null);
    } catch (e) {
      return BookingResult.error('Failed to update booking: $e');
    }
  }

  /// Cancel a booking
  Future<BookingResult> cancelBooking({
    required final String bookingId,
    final String? reason,
  }) async {
    try {
      booking = await _bookingService.getBookingById(bookingId);
      if (booking == null) {
        return BookingResult.error('Booking not found');
      }

      // Cancel booking
      await _bookingService.cancelBooking(bookingId);

      // Cancel corresponding appointment
      await _cancelAppointment(bookingId);

      // Send cancellation notifications (fire and forget)
      // ignore: unawaited_futures
      unawaited(_sendCancellationNotifications(booking, reason));

      return BookingResult.cancelled(booking);
    } catch (e) {
      return BookingResult.error('Failed to cancel booking: $e');
    }
  }

  /// Get available time slots for a staff member with proper timezone handling
  Future<List<TimeSlot>> getAvailableSlots({
    required final String staffId,
    required final DateTime date,
    final Duration? slotDuration,
  }) async {
    try {
      duration = slotDuration ?? const Duration(minutes: 30);
      final slots = <TimeSlot>[];

      // Get staff availability for the date
      availability = await _getStaffAvailability(staffId, date);
      if (availability.isEmpty) {
        return slots;
      }

      // Generate time slots with proper timezone handling
      localDate = DateTime(date.year, date.month, date.day);
      const businessStartHour = 9; // 9 AM local time
      const businessEndHour = 18; // 6 PM local time

      // Create start and end times in local timezone
      final startTime = DateTime(
        localDate.year,
        localDate.month,
        localDate.day,
        businessStartHour,
      );
      final endTime = DateTime(
        localDate.year,
        localDate.month,
        localDate.day,
        businessEndHour,
      );

      // Generate slots within business hours
      for (var time = startTime;
          time.isBefore(endTime);
          time = time.add(duration)) {
        slotEnd = time.add(duration);

        // Ensure slot doesn't cross midnight
        if (slotEnd.day != time.day) {
          // Adjust slot to end at midnight if it would cross
          final adjustedEnd = DateTime(
            time.year,
            time.month,
            time.day,
            23,
            59,
            59,
          );

          // Only add slot if it's still within business hours
          if (time.hour >= businessStartHour) {
            isAvailable = availability.any((final avail) =>
                avail.startTime.isBefore(time) &&
                avail.endTime.isAfter(adjustedEnd),);

            if (isAvailable) {
              final isBooked = await _isSlotBooked(
                  staffId, time, adjustedEnd.difference(time),);
              if (!isBooked) {
                slots.add(TimeSlot(
                  startTime: time,
                  endTime: adjustedEnd,
                  isAvailable: true,
                ),);
              }
            }
          }
        } else {
          // Normal slot within same day
          isAvailable = availability.any((final avail) =>
              avail.startTime.isBefore(time) && avail.endTime.isAfter(slotEnd),);

          if (isAvailable) {
            isBooked = await _isSlotBooked(staffId, time, duration);
            if (!isBooked) {
              slots.add(TimeSlot(
                startTime: time,
                endTime: slotEnd,
                isAvailable: true,
              ),);
            }
          }
        }
      }

      return slots;
    } catch (e) {
      // Removed debug print: debugPrint('Error getting available slots: $e');
      return [];
    }
  }

  /// Validate booking parameters with enhanced timezone and business hours handling
  Future<ValidationResult> _validateBooking({
    required final String userId,
    required final String staffId,
    required final String serviceId,
    required final DateTime dateTime,
    required final Duration duration,
  }) async {
    // Check if date is in the future (using local time)
    now = DateTime.now();
    if (dateTime.isBefore(now)) {
      return ValidationResult.error('Booking time must be in the future');
    }

    // Check if date is within allowed range (e.g., 30 days)
    maxDate = now.add(const Duration(days: 30));
    if (dateTime.isAfter(maxDate)) {
      return ValidationResult.error(
          'Booking cannot be more than 30 days in advance',);
    }

    // Check if staff exists and is available
    staffExists = await _checkStaffExists(staffId);
    if (!staffExists) {
      return ValidationResult.error('Selected staff member not found');
    }

    // Check if service exists
    serviceExists = await _checkServiceExists(serviceId);
    if (!serviceExists) {
      return ValidationResult.error('Selected service not found');
    }

    // Enhanced business hours validation
    const businessStartHour = 9; // 9 AM local time
    const businessEndHour = 18; // 6 PM local time

    // Check if booking starts within business hours
    if (dateTime.hour < businessStartHour || dateTime.hour >= businessEndHour) {
      return ValidationResult.error(
          'Bookings are only available between 9 AM and 6 PM local time',);
    }

    // Check if booking duration would extend beyond business hours
    bookingEnd = dateTime.add(duration);
    final bookingEndHour = bookingEnd.hour;

    // Handle midnight crossing
    if (bookingEnd.day != dateTime.day) {
      // Booking crosses midnight - check if it starts late enough to be valid
      if (dateTime.hour < businessStartHour) {
        return ValidationResult.error(
            'Bookings cannot start before 9 AM local time',);
      }
    } else {
      // Same day booking - check if it ends within business hours
      if (bookingEndHour > businessEndHour) {
        return ValidationResult.error(
            'Bookings cannot extend beyond 6 PM local time',);
      }
    }

    // Validate booking duration (minimum 15 minutes, maximum 8 hours)
    if (duration.inMinutes < 15) {
      return ValidationResult.error(
          'Booking duration must be at least 15 minutes',);
    }
    if (duration.inHours > 8) {
      return ValidationResult.error('Booking duration cannot exceed 8 hours');
    }

    return ValidationResult.success();
  }

  /// Check for booking conflicts
  Future<bool> _checkBookingConflict({
    required final String staffId,
    required final DateTime dateTime,
    required final Duration duration,
    final String? excludeBookingId,
  }) async {
    endTime = dateTime.add(duration);

    final query = _firestore
        .collection('bookings')
        .where('staffId', isEqualTo: staffId)
        .where('dateTime', isLessThan: endTime)
        .where('dateTime', isGreaterThan: dateTime);

    snapshot = await query.get();

    if (excludeBookingId != null) {
      return snapshot.docs.any((doc) => doc.id != excludeBookingId);
    }

    return snapshot.docs.isNotEmpty;
  }

  /// Get staff availability
  Future<List<AvailabilitySlot>> _getStaffAvailability(
      String staffId, final DateTime date,) async {
    try {
      final snapshot = await _firestore
          .collection('staff_availability')
          .where('staffId', isEqualTo: staffId)
          .where('date', isEqualTo: date.toIso8601String().split('T')[0])
          .get();

      return snapshot.docs.map((doc) {
        data = doc.data();
        return AvailabilitySlot(
          startTime: (data['startTime'] as Timestamp).toDate(),
          endTime: (data['endTime'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      // Removed debug print: debugPrint('Error getting staff availability: $e');
      return [];
    }
  }

  /// Check if a time slot is already booked
  Future<bool> _isSlotBooked(final String staffId, final DateTime startTime,
      Duration duration,) async {
    endTime = startTime.add(duration);

    final snapshot = await _firestore
        .collection('bookings')
        .where('staffId', isEqualTo: staffId)
        .where('dateTime', isLessThan: endTime)
        .where('dateTime', isGreaterThan: startTime)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Check if staff member exists
  Future<bool> _checkStaffExists(String staffId) async {
    doc = await _firestore.collection('staff').doc(staffId).get();
    return doc.exists;
  }

  /// Check if service exists
  Future<bool> _checkServiceExists(String serviceId) async {
    doc = await _firestore.collection('services').doc(serviceId).get();
    return doc.exists;
  }

  /// Send notifications and track analytics (fire and forget)
  Future<void> _sendBookingNotifications(
      Booking booking, final Appointment appointment,) async {
    try {
      // Notify staff member
      await _notificationService.sendNotificationToUser(
        booking.staffId,
        'New Booking',
        'You have a new booking for ${booking.serviceName}',
      );

      // Notify customer
      await _notificationService.sendNotificationToUser(
        booking.userId,
        'Booking Confirmed',
        'Your booking for ${booking.serviceName} has been confirmed',
      );
    } catch (e) {
      // Removed debug print: debugPrint('Error sending notifications and tracking analytics: $e');
    }
  }

  /// Send cancellation notifications
  Future<void> _sendCancellationNotifications(
      Booking booking, final String? reason,) async {
    try {
      final reasonText = reason ?? 'No reason provided';

      // Notify staff member
      await _notificationService.sendNotificationToUser(
        booking.staffId,
        'Booking Cancelled',
        'A booking for ${booking.serviceName} has been cancelled. Reason: $reasonText',
      );

      // Notify customer
      await _notificationService.sendNotificationToUser(
        booking.userId,
        'Booking Cancelled',
        'Your booking for ${booking.serviceName} has been cancelled. Reason: $reasonText',
      );
    } catch (e) {
      // Removed debug print: debugPrint('Error sending cancellation notifications: $e');
    }
  }

  /// Track booking analytics
  Future<void> _trackBookingAnalytics(
      Booking booking, final String? studioId,) async {
    try {
      await _firestore.collection('booking_analytics').add({
        'bookingId': booking.id,
        'userId': booking.userId,
        'staffId': booking.staffId,
        'serviceId': booking.serviceId,
        'studioId': studioId,
        'dateTime': booking.dateTime,
        'duration': booking.duration.inMinutes,
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'app',
      });
    } catch (e) {
      // Removed debug print: debugPrint('Error tracking booking analytics: $e');
    }
  }

  /// Update appointment time
  Future<void> _updateAppointmentTime(
      String bookingId, final DateTime newTime,) async {
    try {
      // Find appointment by booking ID
      final snapshot = await _firestore
          .collection('appointments')
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final appointmentDoc = snapshot.docs.first;
        await appointmentDoc.reference.update({
          'scheduledAt': newTime,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error updating appointment time: $e');
    }
  }

  /// Cancel appointment
  Future<void> _cancelAppointment(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final appointmentDoc = snapshot.docs.first;
        await appointmentDoc.reference.update({
          'status': 'cancelled',
          'cancelledAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error cancelling appointment: $e');
    }
  }
}

/// Result class for booking operations
class BookingResult {

  BookingResult._({
    required this.isSuccess,
    this.booking,
    this.appointment,
    this.errorMessage,
  });

  factory BookingResult.success(
      Booking? booking, final Appointment? appointment,) => BookingResult._(
      isSuccess: true,
      booking: booking,
      appointment: appointment,
    );

  factory BookingResult.error(String message) => BookingResult._(
      isSuccess: false,
      errorMessage: message,
    );

  factory BookingResult.cancelled(Booking booking) => BookingResult._(
      isSuccess: true,
      booking: booking,
    );
  final bool isSuccess;
  final Booking? booking;
  final Appointment? appointment;
  final String? errorMessage;
}

/// Validation result for booking parameters
class ValidationResult {

  ValidationResult._({
    required this.isValid,
    this.errorMessage,
  });

  factory ValidationResult.success() => ValidationResult._(isValid: true);

  factory ValidationResult.error(String message) => ValidationResult._(
      isValid: false,
      errorMessage: message,
    );
  final bool isValid;
  final String? errorMessage;
}

/// Time slot for availability
class TimeSlot {

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
}

/// Availability slot for staff
class AvailabilitySlot {

  AvailabilitySlot({
    required this.startTime,
    required this.endTime,
  });
  final DateTime startTime;
  final DateTime endTime;
}

/// Provider for BookingHelper
final bookingHelperProvider = Provider<BookingHelper>((ref) => BookingHelper());
