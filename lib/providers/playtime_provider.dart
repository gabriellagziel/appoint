import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/playtime_game.dart';
import '../models/playtime_session.dart';
import '../models/playtime_background.dart';
import '../services/playtime_service.dart';

// MARK: - Service Provider
final playtimeServiceProvider = Provider<PlaytimeService>((ref) {
  return PlaytimeService();
});

// MARK: - Auth Provider
final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).authStateChanges();
});

// MARK: - Games Providers
final playtimeGamesProvider = FutureProvider<List<PlaytimeGame>>((ref) async {
  return await PlaytimeService.getAvailableGames();
});

final playtimeGamesByCategoryProvider = FutureProvider.family<List<PlaytimeGame>, String>((ref, category) async {
  return await PlaytimeService.getGamesByCategory(category);
});

final playtimeGamesForAgeProvider = FutureProvider.family<List<PlaytimeGame>, int>((ref, age) async {
  return await PlaytimeService.getGamesForAge(age);
});

// MARK: - Sessions Providers
final userSessionsProvider = FutureProvider.family<List<PlaytimeSession>, String>((ref, userId) async {
  return await PlaytimeService.getUserSessions(userId);
});

final participantSessionsProvider = FutureProvider.family<List<PlaytimeSession>, String>((ref, userId) async {
  return await PlaytimeService.getParticipantSessions(userId);
});

final pendingApprovalSessionsProvider = FutureProvider.family<List<PlaytimeSession>, String>((ref, parentId) async {
  return await PlaytimeService.getPendingApprovalSessions(parentId);
});

// MARK: - Backgrounds Providers
final playtimeBackgroundsProvider = FutureProvider<List<PlaytimeBackground>>((ref) async {
  return await PlaytimeService.getAvailableBackgrounds();
});

final playtimeBackgroundsByCategoryProvider = FutureProvider.family<List<PlaytimeBackground>, String>((ref, category) async {
  return await PlaytimeService.getBackgroundsByCategory(category);
});

// MARK: - State Notifiers

class PlaytimeGamesNotifier extends StateNotifier<AsyncValue<List<PlaytimeGame>>> {
  PlaytimeGamesNotifier() : super(const AsyncValue.loading());

  Future<void> loadGames() async {
    state = const AsyncValue.loading();
    try {
      final games = await PlaytimeService.getAvailableGames();
      state = AsyncValue.data(games);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadGamesByCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final games = await PlaytimeService.getGamesByCategory(category);
      state = AsyncValue.data(games);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadGamesForAge(int age) async {
    state = const AsyncValue.loading();
    try {
      final games = await PlaytimeService.getGamesForAge(age);
      state = AsyncValue.data(games);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> createGame(PlaytimeGame game) async {
    try {
      final success = await PlaytimeService.createGame(game);
      if (success) {
        await loadGames();
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}

class PlaytimeSessionsNotifier extends StateNotifier<AsyncValue<List<PlaytimeSession>>> {
  PlaytimeSessionsNotifier() : super(const AsyncValue.loading());

  Future<void> loadUserSessions(String userId) async {
    state = const AsyncValue.loading();
    try {
      final sessions = await PlaytimeService.getUserSessions(userId);
      state = AsyncValue.data(sessions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadParticipantSessions(String userId) async {
    state = const AsyncValue.loading();
    try {
      final sessions = await PlaytimeService.getParticipantSessions(userId);
      state = AsyncValue.data(sessions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadPendingApprovalSessions(String parentId) async {
    state = const AsyncValue.loading();
    try {
      final sessions = await PlaytimeService.getPendingApprovalSessions(parentId);
      state = AsyncValue.data(sessions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> createSession(PlaytimeSession session) async {
    try {
      final success = await PlaytimeService.createSession(session);
      if (success) {
        await loadUserSessions(session.creatorId);
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> updateSessionStatus(String sessionId, String status) async {
    try {
      final success = await PlaytimeService.updateSessionStatus(sessionId, status);
      if (success) {
        // Refresh the sessions list
        final currentSessions = state.value ?? [];
        final updatedSessions = currentSessions.map((session) {
          if (session.id == sessionId) {
            return session.copyWith(status: status);
          }
          return session;
        }).toList();
        state = AsyncValue.data(updatedSessions);
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> approveSession(String sessionId, String parentId) async {
    try {
      final success = await PlaytimeService.approveSessionByParent(sessionId, parentId);
      if (success) {
        await loadPendingApprovalSessions(parentId);
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> declineSession(String sessionId, String parentId, String reason) async {
    try {
      final success = await PlaytimeService.declineSessionByParent(sessionId, parentId, reason);
      if (success) {
        await loadPendingApprovalSessions(parentId);
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> addParticipant(String sessionId, PlaytimeParticipant participant) async {
    try {
      final success = await PlaytimeService.addParticipant(sessionId, participant);
      if (success) {
        // Refresh the sessions list
        final currentSessions = state.value ?? [];
        final updatedSessions = currentSessions.map((session) {
          if (session.id == sessionId) {
            final updatedParticipants = List<PlaytimeParticipant>.from(session.participants)
              ..add(participant);
            return session.copyWith(
              participants: updatedParticipants,
              currentParticipants: updatedParticipants.length,
            );
          }
          return session;
        }).toList();
        state = AsyncValue.data(updatedSessions);
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> removeParticipant(String sessionId, String userId) async {
    try {
      final success = await PlaytimeService.removeParticipant(sessionId, userId);
      if (success) {
        // Refresh the sessions list
        final currentSessions = state.value ?? [];
        final updatedSessions = currentSessions.map((session) {
          if (session.id == sessionId) {
            final updatedParticipants = session.participants
                .where((p) => p.userId != userId)
                .toList();
            return session.copyWith(
              participants: updatedParticipants,
              currentParticipants: updatedParticipants.length,
            );
          }
          return session;
        }).toList();
        state = AsyncValue.data(updatedSessions);
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}

class PlaytimeBackgroundsNotifier extends StateNotifier<AsyncValue<List<PlaytimeBackground>>> {
  PlaytimeBackgroundsNotifier() : super(const AsyncValue.loading());

  Future<void> loadBackgrounds() async {
    state = const AsyncValue.loading();
    try {
      final backgrounds = await PlaytimeService.getAvailableBackgrounds();
      state = AsyncValue.data(backgrounds);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadBackgroundsByCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final backgrounds = await PlaytimeService.getBackgroundsByCategory(category);
      state = AsyncValue.data(backgrounds);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> uploadBackground(PlaytimeBackground background) async {
    try {
      final success = await PlaytimeService.uploadBackground(background);
      if (success) {
        await loadBackgrounds();
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> approveBackground(String backgroundId, String adminId) async {
    try {
      final success = await PlaytimeService.approveBackground(backgroundId, adminId);
      if (success) {
        await loadBackgrounds();
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> declineBackground(String backgroundId, String adminId, String reason) async {
    try {
      final success = await PlaytimeService.declineBackground(backgroundId, adminId, reason);
      if (success) {
        await loadBackgrounds();
      }
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}

// MARK: - Provider Instances
final playtimeGamesNotifierProvider = StateNotifierProvider<PlaytimeGamesNotifier, AsyncValue<List<PlaytimeGame>>>((ref) {
  return PlaytimeGamesNotifier();
});

final playtimeSessionsNotifierProvider = StateNotifierProvider<PlaytimeSessionsNotifier, AsyncValue<List<PlaytimeSession>>>((ref) {
  return PlaytimeSessionsNotifier();
});

final playtimeBackgroundsNotifierProvider = StateNotifierProvider<PlaytimeBackgroundsNotifier, AsyncValue<List<PlaytimeBackground>>>((ref) {
  return PlaytimeBackgroundsNotifier();
});

// MARK: - Utility Providers
final isChildUserProvider = FutureProvider.family<bool, String>((ref, userId) async {
  return await PlaytimeService.isChildUser(userId);
});

final parentIdProvider = FutureProvider.family<String?, String>((ref, childId) async {
  return await PlaytimeService.getParentId(childId);
});

final requiresParentApprovalProvider = FutureProvider.family<bool, PlaytimeSession>((ref, session) async {
  return await PlaytimeService.requiresParentApproval(session);
});

// MARK: - Session Creation Provider
final sessionCreationProvider = StateProvider<PlaytimeSession?>((ref) => null);

final sessionCreationNotifierProvider = StateNotifierProvider<SessionCreationNotifier, PlaytimeSession?>((ref) {
  return SessionCreationNotifier();
});

class SessionCreationNotifier extends StateNotifier<PlaytimeSession?> {
  SessionCreationNotifier() : super(null);

  void setSession(PlaytimeSession session) {
    state = session;
  }

  void clearSession() {
    state = null;
  }

  void updateSession(PlaytimeSession Function(PlaytimeSession) update) {
    if (state != null) {
      state = update(state!);
    }
  }
}
