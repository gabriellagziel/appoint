import 'package:appoint/models/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameProvider =
    StateNotifierProvider<GameNotifier, AsyncValue<List<Game>>>(
  (ref) => GameNotifier(),
);

class GameNotifier extends StateNotifier<AsyncValue<List<Game>>> {
  GameNotifier() : super(const AsyncValue.loading());

  Future<void> loadGames() async {
    state = const AsyncValue.loading();
    try {
      // TODO(username): Implement actual game loading from API or Firestore
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncValue.data([]);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addGame(Game game) async {
    try {
      final currentGames = state.value ?? [];
      final state = AsyncValue.data([...currentGames, game]);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateGame(Game game) async {
    try {
      final currentGames = state.value ?? [];
      final updatedGames =
          currentGames.map((g) => g.id == game.id ? game : g).toList();
      final state = AsyncValue.data(updatedGames);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      final currentGames = state.value ?? [];
      final updatedGames = currentGames.where((g) => g.id != gameId).toList();
      final state = AsyncValue.data(updatedGames);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }
}
