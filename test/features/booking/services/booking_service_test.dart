import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mock_firestore.dart';

void main() {
  late MockFirebaseFirestore firestore;
  late BookingService svc;

  setUpAll(setupFirestoreMocks);

  setUp(() {
    firestore = MockFirebaseFirestore();
    svc = BookingService(firestore: firestore);
  });

  group('cancelBooking', () {
    test('deletes booking document', () async {
      col = MockCollectionRef();
      doc = MockDocRef();
      when(() => firestore.collection('appointments')).thenReturn(col);
      when(() => col.doc('B1')).thenReturn(doc);
      when(doc.delete).thenAnswer((_) async {});

      await svc.cancelBooking('B1');

      verify(doc.delete).called(1);
    });
  });

  group('updateBooking', () {
    test('updates booking dateTime', () async {
      col = MockCollectionRef();
      doc = MockDocRef();
      when(() => firestore.collection('appointments')).thenReturn(col);
      when(() => col.doc('B2')).thenReturn(doc);
      when(() => doc.update(any())).thenAnswer((_) async {});

      final booking = Booking(
        id: 'B2',
        userId: 'U1',
        staffId: 'S1',
        serviceId: 'SRV1',
        serviceName: 'Haircut',
        dateTime: DateTime.utc(2025, 7, 12, 10),
        duration: const Duration(minutes: 30),
      );

      await svc.updateBooking(booking);

      verify(() => doc.update(any())).called(1);
    });
  });
}
