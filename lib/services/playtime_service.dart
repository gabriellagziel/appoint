import 'dart:io';

import 'package:appoint/models/playtime_background.dart';
import 'package:appoint/models/playtime_chat.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlaytimeService {
  // TODO(username): Implement this featurentegrate a storage solution for non-web platforms
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;

  PlaytimeService() {
    try {
      // Only initialize Firebase if it's available
      if (Firebase.apps.isNotEmpty) {
        _firestore = FirebaseFirestore.instance;
        _auth = FirebaseAuth.instance;
      }
    } catch (e) {
      // Silently handle Firebase initialization errors in tests
    }
  }

  // Collections
  static const String _gamesCollection = 'playtime_games';
  static const String _sessionsCollection = 'playtime_sessions';
  static const String _backgroundsCollection = 'playtime_backgrounds';
  static const String _chatsCollection = 'playtime_chats';
  static const String _ticketsCollection = 'playtime_tickets';
  static const String _eventsCollection = 'playtime_events';
  
  // Constants for ticket system
  static const int _maxTicketsPerDay = 10;

  // Ticket/Reward Operations
  Future<void> grantTicket() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      if (!await canEarnMoreToday()) {
        throw Exception('Maximum tickets for today already earned');
      }

      final now = DateTime.now();
      final batch = _firestore.batch();

      // Add ticket to user's collection
      final ticketRef = _firestore.collection(_ticketsCollection).doc(user.uid);
      batch.set(ticketRef, {
        'userId': user.uid,
        'ticketCount': FieldValue.increment(1),
        'lastGranted': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Log the event for parental tracking
      final eventRef = _firestore.collection(_eventsCollection).doc();
      batch.set(eventRef, {
        'childId': user.uid,
        'tickets': 1,
        'timestamp': FieldValue.serverTimestamp(),
        'date': DateTime(now.year, now.month, now.day).toIso8601String(),
        'eventType': 'ticket_granted',
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to grant ticket: $e');
    }
  }

  Future<bool> canEarnMoreToday() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day).toIso8601String();

      final snapshot = await _firestore
          .collection(_eventsCollection)
          .where('childId', isEqualTo: user.uid)
          .where('date', isEqualTo: today)
          .where('eventType', isEqualTo: 'ticket_granted')
          .get();

      return snapshot.docs.length < _maxTicketsPerDay;
    } catch (e) {
      throw Exception('Failed to check ticket eligibility: $e');
    }
  }

  Stream<int> getCurrentTicketCount() {
    try {
      final user = _auth.currentUser;
      if (user == null) return Stream.value(0);

      return _firestore
          .collection(_ticketsCollection)
          .doc(user.uid)
          .snapshots()
          .map((doc) {
            if (!doc.exists) return 0;
            return (doc.data()?['ticketCount'] as int?) ?? 0;
          });
    } catch (e) {
      return Stream.value(0);
    }
  }

  // Game Operations
  Future<List<PlaytimeGame>> getGames() async {
    try {
      if (Firebase.apps.isEmpty) return [];
      
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
    } catch (e) {
      throw Exception('Failed to update game: $e');
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _firestore.collection(_gamesCollection).doc(gameId).delete();
    } catch (e) {
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
    } catch (e) {
      throw Exception('Failed to fetch backgrounds: $e');
    }
  }

  Future<PlaytimeBackground> createBackground(
    final String name,
    final String description,
    final File imageFile,
    final String category,
    final List<String> tags,
  ) async {
    if (kIsWeb) {
      throw UnsupportedError('createBackground is not supported on the web');
    }
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // TODO(username): Implement this feature
      const imageUrl = 'TODO: image url';

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
        ...doc.data()!,
      });
    } catch (e) {
    } catch (e) {
      throw Exception('Failed to fetch chat: $e');
    }
  }

  Future<void> sendMessage(
      String sessionId, final ChatMessage message) async {
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
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
