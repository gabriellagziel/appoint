import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_meta.dart';

class UserMetaService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _userMetaCollection = 'user_meta';

  /// Get user metadata or create if doesn't exist
  static Future<UserMeta?> getUserMeta(String? userId) async {
    try {
      userId ??= _auth.currentUser?.uid;
      if (userId == null) return null;

      final docRef = _firestore.collection(_userMetaCollection).doc(userId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        return UserMeta.fromJson(snapshot.data()!);
      } else {
        // Create new user meta document
        final newUserMeta = UserMeta(
          userId: userId,
          userPwaPromptCount: 0,
          hasInstalledPwa: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await docRef.set(newUserMeta.toJson());
        return newUserMeta;
      }
    } catch (e) {
      print('Error getting user meta: $e');
      return null;
    }
  }

  /// Increment PWA prompt count when user creates a meeting
  static Future<bool> incrementPwaPromptCount(String? userId) async {
    try {
      userId ??= _auth.currentUser?.uid;
      if (userId == null) return false;

      final docRef = _firestore.collection(_userMetaCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          final currentData = UserMeta.fromJson(snapshot.data()!);
          final updatedData = currentData.copyWith(
            userPwaPromptCount: currentData.userPwaPromptCount + 1,
            updatedAt: DateTime.now(),
          );
          transaction.update(docRef, updatedData.toJson());
        } else {
          // Create new document if it doesn't exist
          final newUserMeta = UserMeta(
            userId: userId!,
            userPwaPromptCount: 1,
            hasInstalledPwa: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          transaction.set(docRef, newUserMeta.toJson());
        }
      });

      return true;
    } catch (e) {
      print('Error incrementing PWA prompt count: $e');
      return false;
    }
  }

  /// Mark PWA as installed and stop future prompts
  static Future<bool> markPwaAsInstalled(String? userId) async {
    try {
      userId ??= _auth.currentUser?.uid;
      if (userId == null) return false;

      final docRef = _firestore.collection(_userMetaCollection).doc(userId);

      await docRef.update({
        'hasInstalledPwa': true,
        'pwaInstalledAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error marking PWA as installed: $e');
      return false;
    }
  }

  /// Update last prompt shown timestamp
  static Future<bool> updateLastPwaPromptShown(String? userId) async {
    try {
      userId ??= _auth.currentUser?.uid;
      if (userId == null) return false;

      final docRef = _firestore.collection(_userMetaCollection).doc(userId);

      await docRef.update({
        'lastPwaPromptShown': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error updating last PWA prompt shown: $e');
      return false;
    }
  }

  /// Check if user should see PWA prompt
  static Future<bool> shouldShowPwaPrompt(String? userId) async {
    try {
      final userMeta = await getUserMeta(userId);
      if (userMeta == null) return false;

      return userMeta.shouldShowPwaPrompt;
    } catch (e) {
      print('Error checking if should show PWA prompt: $e');
      return false;
    }
  }

  /// Stream user meta changes for real-time updates
  static Stream<UserMeta?> getUserMetaStream(String? userId) {
    try {
      userId ??= _auth.currentUser?.uid;
      if (userId == null) return Stream.value(null);

      return _firestore
          .collection(_userMetaCollection)
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return UserMeta.fromJson(snapshot.data()!);
        }
        return null;
      });
    } catch (e) {
      print('Error creating user meta stream: $e');
      return Stream.value(null);
    }
  }
}
