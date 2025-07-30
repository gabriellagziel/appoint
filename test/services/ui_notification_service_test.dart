import 'package:appoint/services/ui_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockNotificationService', () {
    late MockNotificationService notificationService;

    setUp(() {
      notificationService = MockNotificationService();
    });

    test('should track info messages', () {
      notificationService.showInfo('Test info message');

      expect(notificationService.infoMessages.length, equals(1));
      expect(
        notificationService.infoMessages.first,
        equals('Test info message'),
      );
    });

    test('should track warning messages', () {
      notificationService.showWarning('Test warning message');

      expect(notificationService.warningMessages.length, equals(1));
      expect(
        notificationService.warningMessages.first,
        equals('Test warning message'),
      );
    });

    test('should track error messages', () {
      notificationService.showError('Test error message');

      expect(notificationService.errorMessages.length, equals(1));
      expect(
        notificationService.errorMessages.first,
        equals('Test error message'),
      );
    });

    test('should track success messages', () {
      notificationService.showSuccess('Test success message');

      expect(notificationService.successMessages.length, equals(1));
      expect(
        notificationService.successMessages.first,
        equals('Test success message'),
      );
    });

    test('should track multiple messages', () {
      notificationService.showInfo('Info 1');
      notificationService.showWarning('Warning 1');
      notificationService.showError('Error 1');
      notificationService.showSuccess('Success 1');
      notificationService.showInfo('Info 2');

      expect(notificationService.infoMessages.length, equals(2));
      expect(notificationService.warningMessages.length, equals(1));
      expect(notificationService.errorMessages.length, equals(1));
      expect(notificationService.successMessages.length, equals(1));
    });

    test('should clear all messages', () {
      notificationService.showInfo('Info message');
      notificationService.showWarning('Warning message');
      notificationService.showError('Error message');
      notificationService.showSuccess('Success message');

      notificationService.clear();

      expect(notificationService.infoMessages.length, equals(0));
      expect(notificationService.warningMessages.length, equals(0));
      expect(notificationService.errorMessages.length, equals(0));
      expect(notificationService.successMessages.length, equals(0));
    });

    test('should return unmodifiable lists', () {
      notificationService.showInfo('Test message');

      expect(
        () {
          notificationService.infoMessages.add('Another message');
        },
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  group('ScaffoldNotificationService', () {
    test('should create with messenger key', () {
      messengerKey = GlobalKey<ScaffoldMessengerState>();
      service = ScaffoldNotificationService(messengerKey);

      expect(service, isA<UINotificationService>());
    });

    // Note: Testing actual SnackBar display would require widget tests
    // These methods are tested in integration tests
  });
}
