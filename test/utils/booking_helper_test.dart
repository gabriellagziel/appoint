import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/utils/booking_helper.dart';
import 'package:appoint/models/booking.dart';
import 'package:appoint/models/appointment.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/services/appointment_service.dart';
import 'package:appoint/services/notification_service.dart';
import '../fake_firebase_firestore.dart';

class MockBookingService extends BookingService {
  final List<Booking> _bookings = [];

  @override
  Future<void> submitBooking(Booking booking) async {
    _bookings.add(booking);
  }

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    try {
      return _bookings.firstWhere((booking) => booking.id == bookingId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _bookings[index] = booking;
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    _bookings.removeWhere((booking) => booking.id == bookingId);
  }
}

class MockAppointmentService extends AppointmentService {
  final List<Appointment> _appointments = [];

  @override
  Future<Appointment> createScheduled({
    required String creatorId,
    required String inviteeId,
    required DateTime scheduledAt,
  }) async {
    final appointment = Appointment(
      id: 'appointment_${_appointments.length + 1}',
      creatorId: creatorId,
      inviteeId: inviteeId,
      scheduledAt: scheduledAt,
      type: AppointmentType.scheduled,
      status: InviteStatus.pending,
    );
    _appointments.add(appointment);
    return appointment;
  }
}

class MockNotificationService extends NotificationService {
  final List<Map<String, dynamic>> _notifications = [];

  @override
  Future<void> sendNotificationToUser(
    String userId,
    String title,
    String body,
  ) async {
    _notifications.add({
      'userId': userId,
      'title': title,
      'body': body,
    });
  }

  List<Map<String, dynamic>> get notifications => _notifications;
}

void main() {
  group('BookingHelper Tests', () {
    late BookingHelper bookingHelper;
    late FakeFirebaseFirestore fakeFirestore;
    late MockBookingService mockBookingService;
    late MockAppointmentService mockAppointmentService;
    late MockNotificationService mockNotificationService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockBookingService = MockBookingService();
      mockAppointmentService = MockAppointmentService();
      mockNotificationService = MockNotificationService();

      bookingHelper = BookingHelper(
        bookingService: mockBookingService,
        appointmentService: mockAppointmentService,
        notificationService: mockNotificationService,
        firestore: fakeFirestore,
      );
    });

    group('Time Slot Generation', () {
      test('should generate slots within business hours (9 AM - 6 PM)',
          () async {
        // Setup staff availability
        final staffId = 'staff_1';
        final date = DateTime(2024, 1, 15); // Monday

        // Add availability data to fake Firestore
        await fakeFirestore.collection('staff_availability').add({
          'staffId': staffId,
          'date': '2024-01-15',
          'startTime': Timestamp.fromDate(DateTime(2024, 1, 15, 9, 0)),
          'endTime': Timestamp.fromDate(DateTime(2024, 1, 15, 18, 0)),
        });

        final slots = await bookingHelper.getAvailableSlots(
          staffId: staffId,
          date: date,
          slotDuration: const Duration(minutes: 30),
        );

        expect(slots, isNotEmpty);

        // Verify all slots are within business hours
        for (final slot in slots) {
          expect(slot.startTime.hour, greaterThanOrEqualTo(9));
          expect(slot.startTime.hour, lessThan(18));
          expect(slot.endTime.hour, lessThanOrEqualTo(18));
        }
      });

      test('should handle midnight crossing correctly', () async {
        final staffId = 'staff_1';
        final date = DateTime(2024, 1, 15);

        // Add availability that extends to midnight
        await fakeFirestore.collection('staff_availability').add({
          'staffId': staffId,
          'date': '2024-01-15',
          'startTime': Timestamp.fromDate(DateTime(2024, 1, 15, 9, 0)),
          'endTime': Timestamp.fromDate(DateTime(2024, 1, 15, 23, 59, 59)),
        });

        final slots = await bookingHelper.getAvailableSlots(
          staffId: staffId,
          date: date,
          slotDuration: const Duration(hours: 2),
        );

        // Verify slots don't cross midnight
        for (final slot in slots) {
          expect(slot.startTime.day, equals(slot.endTime.day));
          expect(slot.endTime.hour, lessThanOrEqualTo(23));
        }
      });

      test('should not generate slots outside business hours', () async {
        final staffId = 'staff_1';
        final date = DateTime(2024, 1, 15);

        // Add availability for full day
        await fakeFirestore.collection('staff_availability').add({
          'staffId': staffId,
          'date': '2024-01-15',
          'startTime': Timestamp.fromDate(DateTime(2024, 1, 15, 0, 0)),
          'endTime': Timestamp.fromDate(DateTime(2024, 1, 15, 23, 59, 59)),
        });

        final slots = await bookingHelper.getAvailableSlots(
          staffId: staffId,
          date: date,
        );

        // Verify no slots before 9 AM or after 6 PM
        for (final slot in slots) {
          expect(slot.startTime.hour, greaterThanOrEqualTo(9));
          expect(slot.startTime.hour, lessThan(18));
        }
      });
    });

    group('Booking Validation', () {
      test('should validate booking within business hours', () async {
        final dateTime = DateTime(2024, 1, 15, 14, 0); // 2 PM
        final duration = const Duration(hours: 1);

        // Mock staff and service existence
        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: duration,
        );

        expect(result.isSuccess, isTrue);
      });

      test('should reject booking before business hours', () async {
        final dateTime = DateTime(2024, 1, 15, 8, 0); // 8 AM
        final duration = const Duration(hours: 1);

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: duration,
        );

        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('9 AM and 6 PM'));
      });

      test('should reject booking after business hours', () async {
        final dateTime = DateTime(2024, 1, 15, 19, 0); // 7 PM
        final duration = const Duration(hours: 1);

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: duration,
        );

        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('9 AM and 6 PM'));
      });

      test('should reject booking that extends beyond business hours',
          () async {
        final dateTime = DateTime(2024, 1, 15, 17, 0); // 5 PM
        final duration = const Duration(hours: 2); // Would end at 7 PM

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: duration,
        );

        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('6 PM'));
      });

      test('should reject booking in the past', () async {
        final dateTime = DateTime.now().subtract(const Duration(hours: 1));
        final duration = const Duration(hours: 1);

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: duration,
        );

        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('future'));
      });

      test('should reject booking too far in advance', () async {
        final dateTime = DateTime.now().add(const Duration(days: 31));
        final duration = const Duration(hours: 1);

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: duration,
        );

        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('30 days'));
      });

      test('should reject booking with invalid duration', () async {
        final dateTime = DateTime(2024, 1, 15, 14, 0);
        final shortDuration = const Duration(minutes: 10);
        final longDuration = const Duration(hours: 10);

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        // Test too short duration
        final shortResult = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: shortDuration,
        );

        expect(shortResult.isSuccess, isFalse);
        expect(shortResult.errorMessage, contains('15 minutes'));

        // Test too long duration
        final longResult = await bookingHelper.createBooking(
          userId: 'user_1',
          staffId: 'staff_1',
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: longDuration,
        );

        expect(longResult.isSuccess, isFalse);
        expect(longResult.errorMessage, contains('8 hours'));
      });
    });

    group('Timezone Handling', () {
      test('should handle different timezone dates correctly', () async {
        final staffId = 'staff_1';

        // Test with different dates
        final dates = [
          DateTime(2024, 1, 15), // Monday
          DateTime(2024, 6, 15), // Summer
          DateTime(2024, 12, 15), // Winter
        ];

        for (final date in dates) {
          await fakeFirestore.collection('staff_availability').add({
            'staffId': staffId,
            'date':
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            'startTime': Timestamp.fromDate(
                DateTime(date.year, date.month, date.day, 9, 0)),
            'endTime': Timestamp.fromDate(
                DateTime(date.year, date.month, date.day, 18, 0)),
          });

          final slots = await bookingHelper.getAvailableSlots(
            staffId: staffId,
            date: date,
          );

          expect(slots, isNotEmpty);

          // Verify business hours are respected regardless of date
          for (final slot in slots) {
            expect(slot.startTime.hour, greaterThanOrEqualTo(9));
            expect(slot.startTime.hour, lessThan(18));
          }
        }
      });
    });

    group('Conflict Detection', () {
      test('should detect booking conflicts', () async {
        final staffId = 'staff_1';
        final dateTime = DateTime(2024, 1, 15, 14, 0);
        final duration = const Duration(hours: 1);

        // Add existing booking
        await fakeFirestore.collection('bookings').add({
          'staffId': staffId,
          'dateTime': Timestamp.fromDate(dateTime),
          'duration': duration.inMinutes,
        });

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_2',
          staffId: staffId,
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: dateTime,
          duration: duration,
        );

        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('not available'));
      });

      test('should allow non-conflicting bookings', () async {
        final staffId = 'staff_1';
        final existingDateTime = DateTime(2024, 1, 15, 14, 0);
        final newDateTime = DateTime(2024, 1, 15, 16, 0); // 2 hours later
        final duration = const Duration(hours: 1);

        // Add existing booking
        await fakeFirestore.collection('bookings').add({
          'staffId': staffId,
          'dateTime': Timestamp.fromDate(existingDateTime),
          'duration': duration.inMinutes,
        });

        await fakeFirestore
            .collection('staff')
            .doc('staff_1')
            .set({'name': 'John'});
        await fakeFirestore
            .collection('services')
            .doc('service_1')
            .set({'name': 'Haircut'});

        final result = await bookingHelper.createBooking(
          userId: 'user_2',
          staffId: staffId,
          serviceId: 'service_1',
          serviceName: 'Haircut',
          dateTime: newDateTime,
          duration: duration,
        );

        expect(result.isSuccess, isTrue);
      });
    });
  });
}
