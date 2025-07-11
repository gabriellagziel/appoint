import 'dart:io';

import 'package:appoint/models/playtime_background.dart';
import 'package:appoint/models/playtime_chat.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:appoint/services/playtime_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stream Providers for real-time data
final AutoDisposeStreamProvider<List<PlaytimeGame>> allGamesProvider =
    StreamProvider.autoDispose<List<PlaytimeGame>>((ref) => FirebaseFirestore.instance
      .collection('playtime_games')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PlaytimeGame.fromJson(doc.data()))
          .toList(),),);

final AutoDisposeStreamProvider<List<PlaytimeSession>> allSessionsProvider =
    StreamProvider.autoDispose<List<PlaytimeSession>>((ref) => FirebaseFirestore.instance
      .collection('playtime_sessions')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PlaytimeSession.fromJson(doc.data()))
          .toList(),),);

final AutoDisposeStreamProvider<List<PlaytimeBackground>> allBackgroundsProvider =
    StreamProvider.autoDispose<List<PlaytimeBackground>>((ref) => FirebaseFirestore.instance
      .collection('playtime_backgrounds')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PlaytimeBackground.fromJson(doc.data()))
          .toList(),),);

// Service Provider
playtimeServiceProvider = Provider<PlaytimeService>((final ref) => PlaytimeService());

// Auth Provider
authProvider = Provider<FirebaseAuth>((final ref) => FirebaseAuth.instance);

// Games Providers
gamesProvider = FutureProvider<List<PlaytimeGame>>((final ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getGames();
});

final systemGamesProvider =
    FutureProvider<List<PlaytimeGame>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getGames();
});

userGamesProvider = FutureProvider<List<PlaytimeGame>>((final ref) async {
  service = ref.read(playtimeServiceProvider);
  user = ref.read(authProvider).currentUser;
  if (user == null) return [];

  return service.getGames();
});

final FutureProviderFamily<PlaytimeGame?, String> gameByIdProvider = FutureProvider.family<PlaytimeGame?, String>(
    (ref, final gameId) async {
  games = await ref.read(gamesProvider.future);
  try {
    return games.firstWhere((game) => game.id == gameId);
  } catch (e) {e) {
    return null;
  }
});

// Sessions Providers
final sessionsProvider =
    FutureProvider<List<PlaytimeSession>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getSessions();
});

final userSessionsProvider =
    FutureProvider<List<PlaytimeSession>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  user = ref.read(authProvider).currentUser;
  if (user == null) return [];

  return service.getSessions();
});

final pendingSessionsProvider =
    FutureProvider<List<PlaytimeSession>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getSessions();
});

final confirmedSessionsProvider =
    FutureProvider<List<PlaytimeSession>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getSessions();
});

final FutureProviderFamily<PlaytimeSession?, String> sessionByIdProvider = FutureProvider.family<PlaytimeSession?, String>(
    (ref, final sessionId) async {
  sessions = await ref.read(sessionsProvider.future);
  try {
    return sessions.firstWhere((session) => session.id == sessionId);
  } catch (e) {e) {
    return null;
  }
});

// Backgrounds Providers
final backgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getBackgrounds();
});

final systemBackgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getBackgrounds();
});

final pendingBackgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getBackgrounds();
});

final approvedBackgroundsProvider =
    FutureProvider<List<PlaytimeBackground>>((ref) async {
  service = ref.read(playtimeServiceProvider);
  return service.getBackgrounds();
});

final FutureProviderFamily<PlaytimeBackground?, String> backgroundByIdProvider =
    FutureProvider.family<PlaytimeBackground?, String>(
        (ref, final backgroundId) async {
  backgrounds = await ref.read(backgroundsProvider.future);
  try {
    return backgrounds
        .firstWhere((background) => background.id == backgroundId);
  } catch (e) {e) {
    return null;
  }
});

// Chat Providers
final FutureProviderFamily<PlaytimeChat, String> chatProvider = FutureProvider.family<PlaytimeChat, String>(
    (ref, final sessionId) async {
  service = ref.read(playtimeServiceProvider);
  return service.getChat(sessionId);
});

// User Settings Providers
childPermissionProvider = FutureProvider<bool>((final ref) async {
  user = ref.read(authProvider).currentUser;
  if (user == null) return false;

  // This would typically fetch from Firestore
  // For now, return a default value
  return true;
});

parentApprovalStatusProvider = FutureProvider<bool>((final ref) async {
  user = ref.read(authProvider).currentUser;
  if (user == null) return false;

  // This would typically fetch from Firestore
  // For now, return a default value
  return true;
});

// State Notifiers for Actions
class PlaytimeGameNotifier extends StateNotifier<AsyncValue<void>> {

  PlaytimeGameNotifier(this._service) : super(const AsyncValue.data(null));
  final PlaytimeService _service;

  Future<void> createGame(PlaytimeGame game) async {
    state = const AsyncValue.loading();
    try {
      await _service.createGame(game);
      state = const AsyncValue.data(null);
    } catch (e) {e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateGame(PlaytimeGame game) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateGame(game);
      state = const AsyncValue.data(null);
    } catch (e) {e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteGame(String gameId) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteGame(gameId);
      state = const AsyncValue.data(null);
    } catch (e) {e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class PlaytimeSessionNotifier extends StateNotifier<AsyncValue<void>> {

  PlaytimeSessionNotifier(this._service) : super(const AsyncValue.data(null));
  final PlaytimeService _service;

  Future<void> createSession(PlaytimeSession session) async {
    state = const AsyncValue.loading();
    try {
      await _service.createSession(session);
      state = const AsyncValue.data(null);
    } catch (e) {e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSession(PlaytimeSession session) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateSession(session);
      state = const AsyncValue.data(null);
    } catch (e) {e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class PlaytimeBackgroundNotifier extends StateNotifier<AsyncValue<void>> {

  PlaytimeBackgroundNotifier(this._service)
      : super(const AsyncValue.data(null));
  final PlaytimeService _service;

  Future<void> createBackground(
    final String name,
    final String description,
    final String imagePath,
    final String category,
    final List<String> tags,
  ) async {
    state = const AsyncValue.loading();
    try {
      if (kIsWeb) {
        throw UnsupportedError('createBackground is not supported on the web');
      }
      imageFile = File(imagePath);
      await _service.createBackground(
          name, description, imageFile, category, tags,);
      state = const AsyncValue.data(null);
    } catch (e) {e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class PlaytimeChatNotifier extends StateNotifier<AsyncValue<void>> {

  PlaytimeChatNotifier(this._service) : super(const AsyncValue.data(null));
  final PlaytimeService _service;

  Future<void> sendMessage(
      String sessionId, final ChatMessage message,) async {
    state = const AsyncValue.loading();
    try {
      await _service.sendMessage(sessionId, message);
      state = const AsyncValue.data(null);
    } catch (e) {e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// State Notifier Providers
final playtimeGameNotifierProvider =
    StateNotifierProvider<PlaytimeGameNotifier, AsyncValue<void>>((ref) {
  service = ref.read(playtimeServiceProvider);
  return PlaytimeGameNotifier(service);
});

final playtimeSessionNotifierProvider =
    StateNotifierProvider<PlaytimeSessionNotifier, AsyncValue<void>>(
        (ref) {
  service = ref.read(playtimeServiceProvider);
  return PlaytimeSessionNotifier(service);
});

final REDACTED_TOKEN =
    StateNotifierProvider<PlaytimeBackgroundNotifier, AsyncValue<void>>(
        (ref) {
  service = ref.read(playtimeServiceProvider);
  return PlaytimeBackgroundNotifier(service);
});

final playtimeChatNotifierProvider =
    StateNotifierProvider<PlaytimeChatNotifier, AsyncValue<void>>((ref) {
  service = ref.read(playtimeServiceProvider);
  return PlaytimeChatNotifier(service);
});

// Utility Providers
final FutureProviderFamily<bool, String> isUserInSessionProvider =
    FutureProvider.family<bool, String>((ref, final sessionId) async {
  user = ref.read(authProvider).currentUser;
  if (user == null) return false;

  session = await ref.read(sessionByIdProvider(sessionId).future);
  if (session == null) return false;

  return session.participants.contains(user.uid);
});

final FutureProviderFamily<String?, String> userSessionRoleProvider =
    FutureProvider.family<String?, String>((ref, final sessionId) async {
  user = ref.read(authProvider).currentUser;
  if (user == null) return null;

  session = await ref.read(sessionByIdProvider(sessionId).future);
  if (session == null) return null;

  // For simplified model, we'll return a default role
  return session.participants.contains(user.uid) ? 'participant' : null;
});
