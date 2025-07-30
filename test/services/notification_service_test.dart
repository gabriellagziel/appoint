import 'package:appoint/services/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('NotificationService', () {
    late NotificationService notificationService;

    setUp(() {
      notificationService = NotificationService();
    });

    test('should initialize correctly', () {
      expect(notificationService, isNotNull);
    });

    test('should have required methods', () {
      expect(notificationService.saveTokenForUser, isA<Function>());
      expect(notificationService.sendNotification, isA<Function>());
      expect(notificationService.requestPermission, isA<Function>());
    });
  });
}
