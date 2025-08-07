import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/playtime_game.dart';
import '../models/playtime_session.dart';
import '../models/playtime_background.dart';

class PlaytimeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Games Collection
  static const String _gamesCollection = 'playtime_games';
  static const String _sessionsCollection = 'playtime_sessions';
  static const String _backgroundsCollection = 'playtime_backgrounds';
  static const String _uploadsCollection = 'playtime_uploads';

  // MARK: - Game Operations

  /// Get all available games
  static Future<List<PlaytimeGame>> getAvailableGames() async {
    try {
      final snapshot = await _firestore
          .collection(_gamesCollection)
          .where('isActive', isEqualTo: true)
          .where('isPublic', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => PlaytimeGame.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching games: $e');
      return [];
    }
  }

  /// Get games by category
  static Future<List<PlaytimeGame>> getGamesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_gamesCollection)
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => PlaytimeGame.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching games by category: $e');
      return [];
    }
  }

  /// Get games suitable for a specific age
  static Future<List<PlaytimeGame>> getGamesForAge(int age) async {
    try {
      final snapshot = await _firestore
          .collection(_gamesCollection)
          .where('isActive', isEqualTo: true)
          .get();

      final allGames = snapshot.docs
          .map((doc) => PlaytimeGame.fromJson(doc.data()))
          .toList();

      return allGames.where((game) {
        final minAge = game.ageRange['min'] ?? 0;
        final maxAge = game.ageRange['max'] ?? 18;
        return age >= minAge && age <= maxAge;
      }).toList();
    } catch (e) {
      print('Error fetching games for age: $e');
      return [];
    }
  }

  /// Create a new game (admin only)
  static Future<bool> createGame(PlaytimeGame game) async {
    try {
      await _firestore
          .collection(_gamesCollection)
          .doc(game.id)
          .set(game.toJson());
      return true;
    } catch (e) {
      print('Error creating game: $e');
      return false;
    }
  }

  // MARK: - Session Operations

  /// Create a new playtime session
  static Future<bool> createSession(PlaytimeSession session) async {
    try {
      await _firestore
          .collection(_sessionsCollection)
          .doc(session.id)
          .set(session.toJson());
      return true;
    } catch (e) {
      print('Error creating session: $e');
      return false;
    }
  }

  /// Get sessions for a specific user
  static Future<List<PlaytimeSession>> getUserSessions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_sessionsCollection)
          .where('creatorId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PlaytimeSession.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching user sessions: $e');
      return [];
    }
  }

  /// Get sessions where user is a participant
  static Future<List<PlaytimeSession>> getParticipantSessions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_sessionsCollection)
          .where('participants', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PlaytimeSession.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching participant sessions: $e');
      return [];
    }
  }

  /// Get sessions pending parent approval
  static Future<List<PlaytimeSession>> getPendingApprovalSessions(String parentId) async {
    try {
      final snapshot = await _firestore
          .collection(_sessionsCollection)
          .where('status', isEqualTo: 'pending_approval')
          .where('parentApprovalStatus.required', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => PlaytimeSession.fromJson(doc.data()))
          .where((session) => session.parentApprovalStatus.isPending)
          .toList();
    } catch (e) {
      print('Error fetching pending approval sessions: $e');
      return [];
    }
  }

  /// Update session status
  static Future<bool> updateSessionStatus(String sessionId, String status) async {
    try {
      await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error updating session status: $e');
      return false;
    }
  }

  /// Add participant to session
  static Future<bool> addParticipant(String sessionId, PlaytimeParticipant participant) async {
    try {
      await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .update({
        'participants': FieldValue.arrayUnion([participant.toJson()]),
        'currentParticipants': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error adding participant: $e');
      return false;
    }
  }

  /// Remove participant from session
  static Future<bool> removeParticipant(String sessionId, String userId) async {
    try {
      final sessionDoc = await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .get();

      if (!sessionDoc.exists) return false;

      final session = PlaytimeSession.fromJson(sessionDoc.data()!);
      final updatedParticipants = session.participants
          .where((p) => p.userId != userId)
          .toList();

      await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .update({
        'participants': updatedParticipants.map((p) => p.toJson()).toList(),
        'currentParticipants': updatedParticipants.length,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error removing participant: $e');
      return false;
    }
  }

  // MARK: - Parent Approval Operations

  /// Approve session by parent
  static Future<bool> approveSessionByParent(String sessionId, String parentId) async {
    try {
      await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .update({
        'parentApprovalStatus.approvedBy': FieldValue.arrayUnion([parentId]),
        'parentApprovalStatus.approvedAt': DateTime.now().toIso8601String(),
        'status': 'approved',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error approving session: $e');
      return false;
    }
  }

  /// Decline session by parent
  static Future<bool> declineSessionByParent(String sessionId, String parentId, String reason) async {
    try {
      await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .update({
        'parentApprovalStatus.declinedBy': FieldValue.arrayUnion([parentId]),
        'parentApprovalStatus.declinedAt': DateTime.now().toIso8601String(),
        'status': 'declined',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error declining session: $e');
      return false;
    }
  }

  // MARK: - Background Operations

  /// Get available backgrounds
  static Future<List<PlaytimeBackground>> getAvailableBackgrounds() async {
    try {
      final snapshot = await _firestore
          .collection(_backgroundsCollection)
          .where('status', isEqualTo: 'approved')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => PlaytimeBackground.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching backgrounds: $e');
      return [];
    }
  }

  /// Get backgrounds by category
  static Future<List<PlaytimeBackground>> getBackgroundsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_backgroundsCollection)
          .where('category', isEqualTo: category)
          .where('status', isEqualTo: 'approved')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => PlaytimeBackground.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching backgrounds by category: $e');
      return [];
    }
  }

  /// Upload new background
  static Future<bool> uploadBackground(PlaytimeBackground background) async {
    try {
      await _firestore
          .collection(_backgroundsCollection)
          .doc(background.id)
          .set(background.toJson());
      return true;
    } catch (e) {
      print('Error uploading background: $e');
      return false;
    }
  }

  /// Approve background by admin
  static Future<bool> approveBackground(String backgroundId, String adminId) async {
    try {
      await _firestore
          .collection(_backgroundsCollection)
          .doc(backgroundId)
          .update({
        'status': 'approved',
        'approvalStatus.reviewedBy': adminId,
        'approvalStatus.reviewedAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error approving background: $e');
      return false;
    }
  }

  /// Decline background by admin
  static Future<bool> declineBackground(String backgroundId, String adminId, String reason) async {
    try {
      await _firestore
          .collection(_backgroundsCollection)
          .doc(backgroundId)
          .update({
        'status': 'declined',
        'approvalStatus.reviewedBy': adminId,
        'approvalStatus.reviewedAt': DateTime.now().toIso8601String(),
        'approvalStatus.reason': reason,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error declining background: $e');
      return false;
    }
  }

  // MARK: - Safety and Moderation

  /// Report session for safety concerns
  static Future<bool> reportSession(String sessionId, String reporterId, String reason) async {
    try {
      await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .update({
        'safetyFlags.reportedContent': true,
        'safetyFlags.moderationRequired': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error reporting session: $e');
      return false;
    }
  }

  /// Pause session due to safety concerns
  static Future<bool> pauseSession(String sessionId, String adminId, String reason) async {
    try {
      await _firestore
          .collection(_sessionsCollection)
          .doc(sessionId)
          .update({
        'safetyFlags.autoPaused': true,
        'status': 'cancelled',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error pausing session: $e');
      return false;
    }
  }

  // MARK: - Utility Methods

  /// Check if user is a child
  static Future<bool> isChildUser(String userId) async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) return false;

      final userData = userDoc.data()!;
      return userData['playtimeSettings']?['isChild'] == true;
    } catch (e) {
      print('Error checking if user is child: $e');
      return false;
    }
  }

  /// Get parent ID for a child user
  static Future<String?> getParentId(String childId) async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(childId)
          .get();

      if (!userDoc.exists) return null;

      final userData = userDoc.data()!;
      return userData['playtimeSettings']?['parentUid'];
    } catch (e) {
      print('Error getting parent ID: $e');
      return null;
    }
  }

  /// Check if session requires parent approval
  static Future<bool> requiresParentApproval(PlaytimeSession session) async {
    if (!session.requiresParentApproval) return false;
    
    final isChild = await isChildUser(session.creatorId);
    return isChild;
  }

  /// Generate session ID
  static String generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}';
  }

  /// Generate game ID
  static String generateGameId() {
    return 'game_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}';
  }

  /// Generate background ID
  static String generateBackgroundId() {
    return 'bg_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}';
  }
}
