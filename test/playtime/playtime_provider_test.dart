import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/providers/playtime_provider.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:appoint/models/playtime_background.dart';
import 'package:appoint/services/playtime_service.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('Playtime Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(overrides: [
        allGamesProvider
            .overrideWith((final ref) => Stream.value(<PlaytimeGame>[])),
        allSessionsProvider
            .overrideWith((final ref) => Stream.value(<PlaytimeSession>[])),
        allBackgroundsProvider
            .overrideWith((final ref) => Stream.value(<PlaytimeBackground>[])),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('playtimeServiceProvider should provide PlaytimeService', () {
      final service = container.read(playtimeServiceProvider);
      expect(service, isA<PlaytimeService>());
    });

    test('allGamesProvider should provide list of games', () async {
      expect(container.read(allGamesProvider),
          isA<AsyncValue<List<PlaytimeGame>>>());
    }, skip: true);

    test('allSessionsProvider should provide list of sessions', () async {
      expect(container.read(allSessionsProvider),
          isA<AsyncValue<List<PlaytimeSession>>>());
    }, skip: true);

    test('allBackgroundsProvider should provide list of backgrounds', () async {
      expect(container.read(allBackgroundsProvider),
          isA<AsyncValue<List<PlaytimeBackground>>>());
    }, skip: true);
  });
}
