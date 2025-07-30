import 'package:appoint/models/personal_appointment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('PersonalAppointment', () {
    test('toJson/fromJson round trip', () {
      final appt = PersonalAppointment(
        id: 'a1',
        userId: 'u1',
        title: 'Meeting',
        description: 'Discuss project',
        startTime: DateTime(2024, 1, 1, 10),
        endTime: DateTime(2024, 1, 1, 11),
      );
      json = appt.toJson();
      copy = PersonalAppointment.fromJson(json);
      expect(copy.id, appt.id);
      expect(copy.userId, appt.userId);
      expect(copy.title, appt.title);
      expect(copy.description, appt.description);
      expect(copy.startTime, appt.startTime);
      expect(copy.endTime, appt.endTime);
    });
  });
}
