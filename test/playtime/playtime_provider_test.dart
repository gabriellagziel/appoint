import 'package:appoint/models/playtime_background.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:appoint/providers/playtime_provider.dart';
import 'package:appoint/services/playtime_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Playtime Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          allGamesProvider
              .overrideWith((ref) => Stream.value(<PlaytimeGame>[])),
          allSessionsProvider
              .overrideWith((ref) => Stream.value(<PlaytimeSession>[])),
          allBackgroundsProvider
              .overrideWith((ref) => Stream.value(<PlaytimeBackground>[])),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('playtimeServiceProvider should provide PlaytimeService', () {
      late PlaytimeService service;
      service = container.read(playtimeServiceProvider);
      expect(service, isA<PlaytimeService>());
    });

    test(
      'allGamesProvider should provide list of games',
      () async {
        expect(
          container.read(allGamesProvider),
          isA<AsyncValue<List<PlaytimeGame>>>(),
        );
      },
      skip: true,
    );

    test(
      'allSessionsProvider should provide list of sessions',
      () async {
        expect(
          container.read(allSessionsProvider),
          isA<AsyncValue<List<PlaytimeSession>>>(),
        );
      },
      skip: true,
    );

    test(
      'allBackgroundsProvider should provide list of backgrounds',
      () async {
        expect(
          container.read(allBackgroundsProvider),
          isA<AsyncValue<List<PlaytimeBackground>>>(),
        );
      },
      skip: true,
    );
  });
}
