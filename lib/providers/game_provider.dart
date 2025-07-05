import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/game.dart';

final gameProvider =
    StateNotifierProvider<GameNotifier, AsyncValue<List<Game>>>(
  (final ref) => GameNotifier(),
);

class GameNotifier extends StateNotifier<AsyncValue<List<Game>>> {
  GameNotifier() : super(const AsyncValue.loading());

  Future<void> loadGames() async {
    state = const AsyncValue.loading();
    try {
      // TODO: Implement actual game loading from API or Firestore
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncValue.data([]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addGame(final Game game) async {
    try {
      final currentGames = state.value ?? [];
      state = AsyncValue.data([...currentGames, game]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateGame(final Game game) async {
    try {
      final currentGames = state.value ?? [];
      final updatedGames =
          currentGames.map((final g) => g.id == game.id ? game : g).toList();
      state = AsyncValue.data(updatedGames);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteGame(final String gameId) async {
    try {
      final currentGames = state.value ?? [];
      final updatedGames =
          currentGames.where((final g) => g.id != gameId).toList();
      state = AsyncValue.data(updatedGames);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
