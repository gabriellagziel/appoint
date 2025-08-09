import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/playtime/controllers/playtime_controller.dart';
import 'package:appoint/features/playtime/models/playtime_model.dart';

void main() {
  group('PlaytimeController Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with null config', () {
      final controller = container.read(playtimeControllerProvider.notifier);
      expect(controller.config, isNull);
      expect(controller.isValid, isFalse);
    });

    test('should set playtime type', () {
      final controller = container.read(playtimeControllerProvider.notifier);

      controller.setPlaytimeType(PlaytimeType.physical);

      expect(controller.config?.type, equals(PlaytimeType.physical));
      expect(controller.config?.isPhysical, isTrue);
      expect(controller.config?.isVirtual, isFalse);
    });

    test('should validate physical playtime requires location', () {
      final controller = container.read(playtimeControllerProvider.notifier);

      // Set physical type without location
      controller.setPlaytimeType(PlaytimeType.physical);
      expect(controller.isValid, isFalse);
      expect(controller.validationError, contains('Location is required'));

      // Add location
      controller.setLocation('Central Park');
      expect(controller.isValid, isTrue);
      expect(controller.validationError, isNull);
    });

    test('should validate virtual playtime requires platform', () {
      final controller = container.read(playtimeControllerProvider.notifier);

      // Set virtual type without platform
      controller.setPlaytimeType(PlaytimeType.virtual);
      expect(controller.isValid, isFalse);
      expect(controller.validationError, contains('Platform is required'));

      // Add platform
      controller.setPlatform(PlaytimePlatform.discord);
      expect(controller.isValid, isTrue);
      expect(controller.validationError, isNull);
    });

    test('should select game and update config', () {
      final controller = container.read(playtimeControllerProvider.notifier);
      final game = popularGames.first;

      controller.setPlaytimeType(PlaytimeType.physical);
      controller.selectGame(game);

      expect(controller.config?.game, equals(game.name));
      expect(controller.config?.isCompetitive, equals(game.isCompetitive));
      expect(
          controller.config?.isFamilyFriendly, equals(game.isFamilyFriendly));
    });

    test('should handle room code for virtual playtime', () {
      final controller = container.read(playtimeControllerProvider.notifier);

      controller.setPlaytimeType(PlaytimeType.virtual);
      controller.setPlatform(PlaytimePlatform.discord);
      controller.setRoomCode('ABC123');

      expect(controller.config?.roomCode, equals('ABC123'));
      expect(controller.config?.requiresRoomCode, isTrue);
    });

    test('should handle server code for Discord', () {
      final controller = container.read(playtimeControllerProvider.notifier);

      controller.setPlaytimeType(PlaytimeType.virtual);
      controller.setPlatform(PlaytimePlatform.discord);
      controller.setServerCode('XYZ789');

      expect(controller.config?.serverCode, equals('XYZ789'));
      expect(controller.config?.requiresServerCode, isTrue);
    });

    test('should reset config', () {
      final controller = container.read(playtimeControllerProvider.notifier);

      controller.setPlaytimeType(PlaytimeType.physical);
      controller.setLocation('Test Location');
      expect(controller.config, isNotNull);

      controller.reset();
      expect(controller.config, isNull);
    });
  });
}



