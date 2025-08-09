import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:appoint/services/remote_config_service.dart';
import 'package:appoint/providers/remote_config_provider.dart';

// Generate mocks
@GenerateMocks([FirebaseRemoteConfig])
import 'remote_config_provider_test.mocks.dart';

void main() {
  group('Remote Config Provider Tests', () {
    late ProviderContainer container;
    late MockFirebaseRemoteConfig mockRemoteConfig;

    setUp(() {
      mockRemoteConfig = MockFirebaseRemoteConfig();
      container = ProviderContainer(
        overrides: [
          remoteConfigProvider.overrideWithValue(
            RemoteConfigService(),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('familyUiEnabledProvider returns correct value', () {
      // Arrange
      when(mockRemoteConfig.getBool('family_ui_enabled')).thenReturn(true);

      // Act
      final result = container.read(familyUiEnabledProvider);

      // Assert
      expect(result, isTrue);
    });

    test('familyCalendarEnabledProvider returns correct value', () {
      // Arrange
      when(mockRemoteConfig.getBool('family_calendar_enabled'))
          .thenReturn(false);

      // Act
      final result = container.read(familyCalendarEnabledProvider);

      // Assert
      expect(result, isFalse);
    });

    test('familyReminderAssignmentEnabledProvider returns correct value', () {
      // Arrange
      when(mockRemoteConfig.getBool('family_reminder_assignment_enabled'))
          .thenReturn(true);

      // Act
      final result = container.read(familyReminderAssignmentEnabledProvider);

      // Assert
      expect(result, isTrue);
    });

    test(
        'areFamilyFeaturesEnabledProvider returns true when any feature is enabled',
        () {
      // Arrange
      when(mockRemoteConfig.getBool('family_ui_enabled')).thenReturn(false);
      when(mockRemoteConfig.getBool('family_calendar_enabled'))
          .thenReturn(true);
      when(mockRemoteConfig.getBool('family_reminder_assignment_enabled'))
          .thenReturn(false);

      // Act
      final result = container.read(areFamilyFeaturesEnabledProvider);

      // Assert
      expect(result, isTrue);
    });

    test(
        'areFamilyFeaturesEnabledProvider returns false when all features are disabled',
        () {
      // Arrange
      when(mockRemoteConfig.getBool('family_ui_enabled')).thenReturn(false);
      when(mockRemoteConfig.getBool('family_calendar_enabled'))
          .thenReturn(false);
      when(mockRemoteConfig.getBool('family_reminder_assignment_enabled'))
          .thenReturn(false);

      // Act
      final result = container.read(areFamilyFeaturesEnabledProvider);

      // Assert
      expect(result, isFalse);
    });

    test('remoteConfigRefreshProvider completes successfully', () async {
      // Act & Assert
      expect(
        container.read(remoteConfigRefreshProvider),
        completes,
      );
    });
  });
}
