import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Test bootstrap for Firebase initialization
/// This file sets up Firebase for testing with emulator endpoints
class TestBootstrap {
  static bool _initialized = false;
  static FirebaseFirestore? _firestore;
  static FirebaseAuth? _auth;

  /// Initialize Firebase for testing
  static Future<void> initialize() async {
    if (_initialized) return;

    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase with test configuration
    await Firebase.initializeApp();

    // Connect to emulators if running
    try {
      // Check if emulators are running
      await FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

      print('✅ Connected to Firebase emulators');
    } catch (e) {
      print('⚠️ Could not connect to emulators, using production endpoints');
    }

    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _initialized = true;
  }

  /// Get Firestore instance
  static FirebaseFirestore get firestore {
    if (!_initialized) {
      throw Exception(
          'TestBootstrap not initialized. Call initialize() first.');
    }
    return _firestore!;
  }

  /// Get Auth instance
  static FirebaseAuth get auth {
    if (!_initialized) {
      throw Exception(
          'TestBootstrap not initialized. Call initialize() first.');
    }
    return _auth!;
  }

  /// Clean up test data
  static Future<void> cleanup() async {
    if (!_initialized) return;

    try {
      // Clean up test collections
      final collections = [
        'share_links',
        'guest_tokens',
        'rate_limits',
        'analytics',
        'meetings',
        'rsvp'
      ];

      for (final collection in collections) {
        final snapshot = await _firestore!.collection(collection).get();
        final batch = _firestore!.batch();

        for (final doc in snapshot.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
      }

      print('✅ Test data cleaned up');
    } catch (e) {
      print('⚠️ Error cleaning up test data: $e');
    }
  }

  /// Create test user
  static Future<User> createTestUser({
    String uid = 'test-user-123',
    String email = 'test@example.com',
    String displayName = 'Test User',
  }) async {
    if (!_initialized) {
      throw Exception(
          'TestBootstrap not initialized. Call initialize() first.');
    }

    // Create test user document
    await _firestore!.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('✅ Test user created: $uid');

    // Return mock user (in real tests, you'd sign in)
    return _auth!.currentUser ?? await _auth!.signInAnonymously();
  }

  /// Create test meeting
  static Future<String> createTestMeeting({
    String? organizerId,
    String? groupId,
    String title = 'Test Meeting',
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    if (!_initialized) {
      throw Exception(
          'TestBootstrap not initialized. Call initialize() first.');
    }

    final meetingId = 'test-meeting-${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    await _firestore!.collection('meetings').doc(meetingId).set({
      'id': meetingId,
      'organizerId': organizerId ?? 'test-user-123',
      'title': title,
      'startTime': startTime ?? now.add(Duration(hours: 1)),
      'endTime': endTime ?? now.add(Duration(hours: 2)),
      'meetingType': 'personal',
      'status': 'scheduled',
      'participants': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'groupId': groupId,
      'visibility': {
        'groupMembersOnly': groupId != null,
        'allowGuestsRSVP': true,
      },
    });

    print('✅ Test meeting created: $meetingId');
    return meetingId;
  }

  /// Create test group
  static Future<String> createTestGroup({
    String? ownerId,
    String name = 'Test Group',
  }) async {
    if (!_initialized) {
      throw Exception(
          'TestBootstrap not initialized. Call initialize() first.');
    }

    final groupId = 'test-group-${DateTime.now().millisecondsSinceEpoch}';

    await _firestore!.collection('user_groups').doc(groupId).set({
      'id': groupId,
      'name': name,
      'ownerId': ownerId ?? 'test-user-123',
      'members': {
        ownerId ?? 'test-user-123': {
          'role': 'owner',
          'joinedAt': FieldValue.serverTimestamp(),
        }
      },
      'admins': {},
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('✅ Test group created: $groupId');
    return groupId;
  }

  /// Create test share link
  static Future<String> createTestShareLink({
    required String meetingId,
    String? groupId,
    String? createdBy,
    String? source,
  }) async {
    if (!_initialized) {
      throw Exception(
          'TestBootstrap not initialized. Call initialize() first.');
    }

    final shareId = 'test-share-${DateTime.now().millisecondsSinceEpoch}';

    await _firestore!.collection('share_links').doc(shareId).set({
      'shareId': shareId,
      'meetingId': meetingId,
      'groupId': groupId,
      'createdBy': createdBy ?? 'test-user-123',
      'source': source ?? 'test',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': null,
      'usageCount': 0,
      'maxUsage': null,
      'revoked': false,
    });

    print('✅ Test share link created: $shareId');
    return shareId;
  }

  /// Create test guest token
  static Future<String> createTestGuestToken({
    required String meetingId,
    String? groupId,
    Duration? expiry,
  }) async {
    if (!_initialized) {
      throw Exception(
          'TestBootstrap not initialized. Call initialize() first.');
    }

    final token = 'test-token-${DateTime.now().millisecondsSinceEpoch}';
    final expiresAt = DateTime.now().add(expiry ?? Duration(hours: 24));

    await _firestore!.collection('guest_tokens').doc(token).set({
      'claims': {
        'meetingId': meetingId,
        'groupId': groupId,
        'exp': expiresAt.millisecondsSinceEpoch,
        'iat': DateTime.now().millisecondsSinceEpoch,
      },
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isActive': true,
    });

    print('✅ Test guest token created: $token');
    return token;
  }

  /// Setup complete test environment
  static Future<Map<String, String>> setupTestEnvironment() async {
    await initialize();
    await cleanup();

    // Create test user
    final user = await createTestUser();

    // Create test group
    final groupId = await createTestGroup(ownerId: user.uid);

    // Create test meeting
    final meetingId = await createTestMeeting(
      organizerId: user.uid,
      groupId: groupId,
    );

    // Create test share link
    final shareId = await createTestShareLink(
      meetingId: meetingId,
      groupId: groupId,
      createdBy: user.uid,
    );

    // Create test guest token
    final guestToken = await createTestGuestToken(
      meetingId: meetingId,
      groupId: groupId,
    );

    print('✅ Test environment setup complete');

    return {
      'userId': user.uid,
      'groupId': groupId,
      'meetingId': meetingId,
      'shareId': shareId,
      'guestToken': guestToken,
    };
  }
}

/// Global test setup function
Future<void> setupTestEnvironment() async {
  await TestBootstrap.setupTestEnvironment();
}

/// Global test cleanup function
Future<void> cleanupTestEnvironment() async {
  await TestBootstrap.cleanup();
}
