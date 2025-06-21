import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import '../services/playtime_service.dart';
import '../models/playtime_game.dart';
import '../models/playtime_session.dart';
import '../models/playtime_background.dart';
import '../models/playtime_chat.dart';

// Stream Providers for real-time data
final allGamesProvider = StreamProvider.autoDispose<List<PlaytimeGame>>((ref) {
  return FirebaseFirestore.instance
      .collection('playtime_games')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PlaytimeGame.fromJson(doc.data()))
          .toList());
});

final allSessionsProvider =
    StreamProvider.autoDispose<List<PlaytimeSession>>((ref) {
  return FirebaseFirestore.instance
      .collection('playtime_sessions')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PlaytimeSession.fromJson(doc.data()))
          .toList());
});

final allBackgroundsProvider =
    StreamProvider.autoDispose<List<PlaytimeBackground>>((ref) {
  return FirebaseFirestore.instance
      .collection('playtime_backgrounds')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PlaytimeBackground.fromJson(doc.data()))
          .toList());
});

// Service Provider
final playtimeServiceProvider = Provider<PlaytimeService>((ref) {
  return PlaytimeService();
});

// Auth Provider
final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Games Providers
final gamesProvider = FutureProvider<List<PlaytimeGame>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getGames();
});

final systemGamesProvider = FutureProvider<List<PlaytimeGame>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getGames();
});

final userGamesProvider = FutureProvider<List<PlaytimeGame>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  final user = ref.read(authProvider).currentUser;
  if (user == null) return [];

  return await service.getGames();
});

final gameByIdProvider =
    FutureProvider.family<PlaytimeGame?, String>((ref, gameId) async {
  final games = await ref.read(gamesProvider.future);
  try {
    return games.firstWhere((game) => game.id == gameId);
  } catch (e) {
    return null;
  }
});

// Sessions Providers
final sessionsProvider = FutureProvider<List<PlaytimeSession>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getSessions();
});

final userSessionsProvider = FutureProvider<List<PlaytimeSession>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  final user = ref.read(authProvider).currentUser;
  if (user == null) return [];

  return await service.getSessions();
});

final pendingSessionsProvider =
    FutureProvider<List<PlaytimeSession>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getSessions();
});

final confirmedSessionsProvider =
    FutureProvider<List<PlaytimeSession>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getSessions();
});

final sessionByIdProvider =
    FutureProvider.family<PlaytimeSession?, String>((ref, sessionId) async {
  final sessions = await ref.read(sessionsProvider.future);
  try {
    return sessions.firstWhere((session) => session.id == sessionId);
  } catch (e) {
    return null;
  }
});

// Backgrounds Providers
final backgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getBackgrounds();
});

final systemBackgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getBackgrounds();
});

final pendingBackgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getBackgrounds();
});

final approvedBackgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getBackgrounds();
});

final backgroundByIdProvider =
    FutureProvider.family<PlaytimeBackground?, String>(
        (ref, backgroundId) async {
  final backgrounds = await ref.read(backgroundsProvider.future);
  try {
    return backgrounds
        .firstWhere((background) => background.id == backgroundId);
  } catch (e) {
    return null;
  }
});

// Chat Providers
final chatProvider =
    FutureProvider.family<PlaytimeChat, String>((ref, sessionId) async {
  final service = ref.read(playtimeServiceProvider);
  return await service.getChat(sessionId);
});

// User Settings Providers
final childPermissionProvider = FutureProvider<bool>((ref) async {
  final user = ref.read(authProvider).currentUser;
  if (user == null) return false;

  // This would typically fetch from Firestore
  // For now, return a default value
  return true;
});

final parentApprovalStatusProvider = FutureProvider<bool>((ref) async {
  final user = ref.read(authProvider).currentUser;
  if (user == null) return false;

  // This would typically fetch from Firestore
  // For now, return a default value
  return true;
});

// State Notifiers for Actions
class PlaytimeGameNotifier extends StateNotifier<AsyncValue<void>> {
  final PlaytimeService _service;

  PlaytimeGameNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> createGame(PlaytimeGame game) async {
    state = const AsyncValue.loading();
    try {
      await _service.createGame(game);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateGame(PlaytimeGame game) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateGame(game);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteGame(String gameId) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteGame(gameId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class PlaytimeSessionNotifier extends StateNotifier<AsyncValue<void>> {
  final PlaytimeService _service;

  PlaytimeSessionNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> createSession(PlaytimeSession session) async {
    state = const AsyncValue.loading();
    try {
      await _service.createSession(session);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSession(PlaytimeSession session) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateSession(session);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class PlaytimeBackgroundNotifier extends StateNotifier<AsyncValue<void>> {
  final PlaytimeService _service;

  PlaytimeBackgroundNotifier(this._service)
      : super(const AsyncValue.data(null));

  Future<void> createBackground(
    String name,
    String description,
    String imagePath,
    String category,
    List<String> tags,
  ) async {
    state = const AsyncValue.loading();
    try {
      if (kIsWeb) {
        throw UnsupportedError('createBackground is not supported on the web');
      }
      final imageFile = File(imagePath);
      await _service.createBackground(
          name, description, imageFile, category, tags);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class PlaytimeChatNotifier extends StateNotifier<AsyncValue<void>> {
  final PlaytimeService _service;

  PlaytimeChatNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> sendMessage(String sessionId, ChatMessage message) async {
    state = const AsyncValue.loading();
    try {
      await _service.sendMessage(sessionId, message);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// State Notifier Providers
final playtimeGameNotifierProvider =
    StateNotifierProvider<PlaytimeGameNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(playtimeServiceProvider);
  return PlaytimeGameNotifier(service);
});

final playtimeSessionNotifierProvider =
    StateNotifierProvider<PlaytimeSessionNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(playtimeServiceProvider);
  return PlaytimeSessionNotifier(service);
});

final REDACTED_TOKEN =
    StateNotifierProvider<PlaytimeBackgroundNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(playtimeServiceProvider);
  return PlaytimeBackgroundNotifier(service);
});

final playtimeChatNotifierProvider =
    StateNotifierProvider<PlaytimeChatNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(playtimeServiceProvider);
  return PlaytimeChatNotifier(service);
});

// Utility Providers
final isUserInSessionProvider =
    FutureProvider.family<bool, String>((ref, sessionId) async {
  final user = ref.read(authProvider).currentUser;
  if (user == null) return false;

  final session = await ref.read(sessionByIdProvider(sessionId).future);
  if (session == null) return false;

  return session.participants.contains(user.uid);
});

final userSessionRoleProvider =
    FutureProvider.family<String?, String>((ref, sessionId) async {
  final user = ref.read(authProvider).currentUser;
  if (user == null) return null;

  final session = await ref.read(sessionByIdProvider(sessionId).future);
  if (session == null) return null;

  // For simplified model, we'll return a default role
  return session.participants.contains(user.uid) ? 'participant' : null;
});
