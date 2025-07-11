import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import 'package:appoint/services/appointment_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:appoint/utils/booking_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingService extends Mock implements BookingService {}

class MockAppointmentService extends Mock implements AppointmentService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockBookingService svc;
  late MockAppointmentService appointmentSvc;
  late MockNotificationService notificationSvc;
  late MockFirebaseFirestore firestore;
  late BookingHelper helper;

  setUp(() {
    svc = MockBookingService();
    appointmentSvc = MockAppointmentService();
    notificationSvc = MockNotificationService();
    firestore = MockFirebaseFirestore();
    helper = BookingHelper(
      bookingService: svc,
      appointmentService: appointmentSvc,
      notificationService: notificationSvc,
      firestore: firestore,
    );
  });

  group('cancelBooking', () {
    test('returns success', () async {
      final mockBooking = Booking(
        id: 'B123',
        userId: 'U1',
        staffId: 'S1',
        serviceId: 'SRV1',
        serviceName: 'Haircut',
        dateTime: DateTime.utc(2025, 7, 12, 10),
        duration: const Duration(minutes: 30),
      );

      when(() => svc.getBookingById('B123'))
          .thenAnswer((_) async => mockBooking);
      when(() => svc.cancelBooking('B123')).thenAnswer((_) async {});

      res = await helper.cancelBooking(bookingId: 'B123');
      expect(res.isSuccess, true);
    });
  });
}
