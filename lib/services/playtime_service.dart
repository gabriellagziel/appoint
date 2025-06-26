import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import '../models/playtime_game.dart';
import '../models/playtime_session.dart';
import '../models/playtime_background.dart';
import '../models/playtime_chat.dart';

class PlaytimeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // TODO: Integrate a storage solution for non-web platforms
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String _gamesCollection = 'playtime_games';
  static const String _sessionsCollection = 'playtime_sessions';
  static const String _backgroundsCollection = 'playtime_backgrounds';
  static const String _chatsCollection = 'playtime_chats';

  // Game Operations
  Future<List<PlaytimeGame>> getGames() async {
    try {
      final snapshot = await _firestore.collection(_gamesCollection).get();
      return snapshot.docs
          .map((doc) => PlaytimeGame.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch games: $e');
    }
  }

  Future<PlaytimeGame> createGame(PlaytimeGame game) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final docRef = await _firestore.collection(_gamesCollection).add({
        ...game.toJson(),
        'id': null, // Remove id as it will be set by Firestore
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return game.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create game: $e');
    }
  }

  Future<void> updateGame(PlaytimeGame game) async {
    try {
      await _firestore.collection(_gamesCollection).doc(game.id).update({
        ...game.toJson(),
        'id': null,
      });
    } catch (e) {
      throw Exception('Failed to update game: $e');
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _firestore.collection(_gamesCollection).doc(gameId).delete();
    } catch (e) {
      throw Exception('Failed to delete game: $e');
    }
  }

  // Session Operations
  Future<List<PlaytimeSession>> getSessions() async {
    try {
      final snapshot = await _firestore.collection(_sessionsCollection).get();
      return snapshot.docs
          .map((doc) => PlaytimeSession.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch sessions: $e');
    }
  }

  Future<PlaytimeSession> createSession(PlaytimeSession session) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final docRef = await _firestore.collection(_sessionsCollection).add({
        ...session.toJson(),
        'id': null,
      });

      return session.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  Future<void> updateSession(PlaytimeSession session) async {
    try {
      await _firestore.collection(_sessionsCollection).doc(session.id).update({
        ...session.toJson(),
        'id': null,
      });
    } catch (e) {
      throw Exception('Failed to update session: $e');
    }
  }

  // Background Operations
  Future<List<PlaytimeBackground>> getBackgrounds() async {
    try {
      final snapshot =
          await _firestore.collection(_backgroundsCollection).get();
      return snapshot.docs
          .map((doc) => PlaytimeBackground.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch backgrounds: $e');
    }
  }

  Future<PlaytimeBackground> createBackground(
    String name,
    String description,
    File imageFile,
    String category,
    List<String> tags,
  ) async {
    if (kIsWeb) {
      throw UnsupportedError('createBackground is not supported on the web');
    }
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // TODO: Upload image to a storage service
      final imageUrl = 'TODO: image url';

      final docRef = await _firestore.collection(_backgroundsCollection).add({
        'imageUrl': imageUrl,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return PlaytimeBackground(
        id: docRef.id,
        imageUrl: imageUrl,
        createdBy: user.uid,
      );
    } catch (e) {
      throw Exception('Failed to create background: $e');
    }
  }

  // Chat Operations
  Future<PlaytimeChat> getChat(String sessionId) async {
    try {
      final doc =
          await _firestore.collection(_chatsCollection).doc(sessionId).get();
      if (!doc.exists) {
        // Create new chat if it doesn't exist
        await _firestore.collection(_chatsCollection).doc(sessionId).set({
          'sessionId': sessionId,
          'messages': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
        return PlaytimeChat(
          sessionId: sessionId,
          messages: [],
        );
      }

      return PlaytimeChat.fromJson({
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to fetch chat: $e');
    }
  }

  Future<void> sendMessage(String sessionId, ChatMessage message) async {
    try {
      final chatRef = _firestore.collection(_chatsCollection).doc(sessionId);

      await _firestore.runTransaction((transaction) async {
        final chatDoc = await transaction.get(chatRef);
        final messages = List<Map<String, dynamic>>.from(
          chatDoc.data()?['messages'] ?? [],
        );

        messages.add(message.toJson());

        transaction.set(
            chatRef,
            {
              'sessionId': sessionId,
              'messages': messages,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
