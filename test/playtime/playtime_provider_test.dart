import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../lib/providers/playtime_provider.dart';
import '../../lib/models/playtime_game.dart';
import '../../lib/models/playtime_session.dart';
import '../../lib/models/playtime_background.dart';
import '../../lib/services/playtime_service.dart';
import '../fake_firebase_setup.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Playtime Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
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
    });

    test('allSessionsProvider should provide list of sessions', () async {
      expect(container.read(allSessionsProvider),
          isA<AsyncValue<List<PlaytimeSession>>>());
    });

    test('allBackgroundsProvider should provide list of backgrounds', () async {
      expect(container.read(allBackgroundsProvider),
          isA<AsyncValue<List<PlaytimeBackground>>>());
    });
  });
}
