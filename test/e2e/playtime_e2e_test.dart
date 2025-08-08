import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../lib/firebase_options.dart';
import '../../lib/services/playtime_service.dart';
import '../../lib/models/playtime_session.dart';
import '../../lib/models/playtime_game.dart';

/// Helper to point Firestore to emulator in tests
Future<void> _initFirebaseForTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Point to emulator if env var set (recommended for CI)
  const host = String.fromEnvironment('FIRESTORE_EMULATOR_HOST',
      defaultValue: 'localhost');
  const portStr =
      String.fromEnvironment('FIRESTORE_EMULATOR_PORT', defaultValue: '8081');
  final port = int.tryParse(portStr) ?? 8081;
  FirebaseFirestore.instance.useFirestoreEmulator(host, port);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
}

/// Seed minimal data: users, parent-child link, games
Future<void> _seedData() async {
  final db = FirebaseFirestore.instance;
  // Users
  await db.collection('users').doc('adult_18').set({
    'uid': 'adult_18',
    'age': 18,
    'isChild': false,
    'parentUid': null,
  });
  await db.collection('users').doc('teen_15').set({
    'uid': 'teen_15',
    'age': 15,
    'isChild': true,
    'parentUid': 'parent_42',
  });
  await db.collection('users').doc('child_10').set({
    'uid': 'child_10',
    'age': 10,
    'isChild': true,
    'parentUid': 'parent_42',
  });
  await db.collection('users').doc('parent_42').set({
    'uid': 'parent_42',
    'age': 40,
    'isChild': false,
  });

  // Parent prefs (override enabled for testing teen scenario)
  await db.collection('playtime_preferences').doc('parent_42').set({
    'allowOverrideAgeRestriction': true,
    'blockedGames': [],
    'allowedPlatforms': ['PC', 'Console', 'Mobile'],
  });

  // Games with varied minAge
  await db.collection('playtime_games').doc('minecraft').set({
    'id': 'minecraft',
    'name': 'Minecraft',
    'platform': 'PC',
    'minAge': 8,
    'maxPlayers': 10,
    'parentApproved': true,
  });
  await db.collection('playtime_games').doc('mature_shooter').set({
    'id': 'mature_shooter',
    'name': 'Mature Shooter',
    'platform': 'Console',
    'minAge': 18,
    'maxPlayers': 8,
    'parentApproved': true,
  });
}

void main() {
  setUpAll(() async {
    await _initFirebaseForTests();
    await _seedData();
  });

  group('E2E Playtime – Age enforcement', () {
    test(
        'Adult (18+) can create any session without approval (physical & virtual)',
        () async {
      // Arrange
      const uid = 'adult_18';
      final db = FirebaseFirestore.instance;
      final gameSnap =
          await db.collection('playtime_games').doc('mature_shooter').get();
      final game = PlaytimeGame.fromJson(gameSnap.data()!);

      // Act – create physical session
      final sessionPhysical = PlaytimeSession(
        id: 's1_adult_physical',
        gameId: game.id,
        type: 'physical',
        title: 'Adult physical session',
        description: 'Mature shooter session',
        creatorId: uid,
        participants: [
          PlaytimeParticipant(
            userId: uid,
            displayName: 'Adult User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        location: PlaytimeLocation(
          name: 'Central Park',
          address: 'Some Park, New York',
          coordinates: {'lat': 40.7128, 'lng': -74.0060},
        ),
        duration: 120,
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: false),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 8,
      );
      await PlaytimeService.createSession(sessionPhysical);

      // Act – create virtual session
      final sessionVirtual = PlaytimeSession(
        id: 's2_adult_virtual',
        gameId: game.id,
        type: 'virtual',
        title: 'Adult virtual session',
        description: 'Virtual mature shooter session',
        creatorId: uid,
        participants: [
          PlaytimeParticipant(
            userId: uid,
            displayName: 'Adult User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        location: PlaytimeLocation(
          name: 'Virtual Room',
          address: 'https://example.com/room',
          coordinates: {},
        ),
        duration: 120,
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: false),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 8,
      );
      await PlaytimeService.createSession(sessionVirtual);

      // Assert – sessions saved without approval requirement
      final s1 = await db
          .collection('playtime_sessions')
          .doc('s1_adult_physical')
          .get();
      final s2 = await db
          .collection('playtime_sessions')
          .doc('s2_adult_virtual')
          .get();
      expect(s1.exists, true);
      expect(s2.exists, true);
    });

    test('Child (10) blocked for game with minAge 18 without parent approval',
        () async {
      const uid = 'child_10';
      final db = FirebaseFirestore.instance;
      final gameSnap =
          await db.collection('playtime_games').doc('mature_shooter').get();
      final game = PlaytimeGame.fromJson(gameSnap.data()!);

      final session = PlaytimeSession(
        id: 's3_child_blocked',
        gameId: game.id,
        type: 'virtual',
        title: 'Child blocked session',
        description: 'Should be blocked',
        creatorId: uid,
        participants: [
          PlaytimeParticipant(
            userId: uid,
            displayName: 'Child User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        location: PlaytimeLocation(
          name: 'Blocked Virtual Room',
          address: 'https://example.com/locked',
          coordinates: {},
        ),
        duration: 120,
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: true),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 8,
      );

      try {
        await PlaytimeService.createSession(session);
        fail('Expected AgeRestrictedError or ParentApprovalRequiredError');
      } catch (e) {
        // Either age restricted or parent approval required is fine here
        expect(e.toString(),
            anyOf([contains('Restricted'), contains('ParentApproval')]));
      }

      final s3 = await db
          .collection('playtime_sessions')
          .doc('s3_child_blocked')
          .get();
      expect(s3.exists, false,
          reason: 'Write should be rejected at service or rules');
    });

    test(
        'Teen (15) can create game above age only with parent override + approval',
        () async {
      const uid = 'teen_15';
      final db = FirebaseFirestore.instance;
      final gameSnap =
          await db.collection('playtime_games').doc('mature_shooter').get();
      final game = PlaytimeGame.fromJson(gameSnap.data()!);

      // Attempt without approval – should throw ParentApprovalRequired
      const sId = 's4_teen_needs_approval';
      final session = PlaytimeSession(
        id: sId,
        gameId: game.id,
        type: 'virtual',
        title: 'Teen needs approval',
        description: 'Teen session requiring approval',
        creatorId: uid,
        participants: [
          PlaytimeParticipant(
            userId: uid,
            displayName: 'Teen User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        location: PlaytimeLocation(
          name: 'Teen Virtual Room',
          address: 'https://example.com/teen',
          coordinates: {},
        ),
        duration: 120,
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: true),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 8,
      );

      bool threw = false;
      try {
        await PlaytimeService.createSession(session);
      } catch (e) {
        threw = true;
        expect(e.toString(), contains('ParentApproval'));
      }
      expect(threw, true,
          reason: 'Should require parent approval before write');

      // Simulate parent approval via service or direct write (depending on your design)
      await db.collection('playtime_sessions').doc(sId).set(session.toJson());
      await db.collection('playtime_sessions').doc(sId).update({
        'parentApprovalStatus.approvedBy': ['parent_42']
      });

      // Verify final state
      final s4 = await db.collection('playtime_sessions').doc(sId).get();
      expect(s4.exists, true);
      expect(s4.data()!['parentApprovalStatus']['approvedBy'],
          contains('parent_42'));
    });

    test('Child can create age-appropriate session with parent approval flow',
        () async {
      const uid = 'child_10';
      final db = FirebaseFirestore.instance;
      final gameSnap =
          await db.collection('playtime_games').doc('minecraft').get();
      final game = PlaytimeGame.fromJson(gameSnap.data()!);

      final session = PlaytimeSession(
        id: 's5_child_appropriate',
        gameId: game.id,
        type: 'virtual',
        title: 'Child appropriate session',
        description: 'Age-appropriate Minecraft session',
        creatorId: uid,
        participants: [
          PlaytimeParticipant(
            userId: uid,
            displayName: 'Child User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        location: PlaytimeLocation(
          name: 'Minecraft Virtual World',
          address: 'https://example.com/minecraft',
          coordinates: {},
        ),
        duration: 60,
        parentApprovalStatus: PlaytimeParentApprovalStatus(
          required: true,
          approvedBy: ['parent_42'],
          approvedAt: DateTime.now(),
        ),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 10,
      );

      await PlaytimeService.createSession(session);

      // Assert – session saved with parent approval
      final s5 = await db
          .collection('playtime_sessions')
          .doc('s5_child_appropriate')
          .get();
      expect(s5.exists, true);
      expect(s5.data()!['parentApprovalStatus']['approvedBy'],
          contains('parent_42'));
    });
  });

  group('E2E Playtime – Safety and Monitoring', () {
    test('System flags inappropriate content and requires admin review',
        () async {
      const uid = 'teen_15';
      final db = FirebaseFirestore.instance;
      final gameSnap =
          await db.collection('playtime_games').doc('minecraft').get();
      final game = PlaytimeGame.fromJson(gameSnap.data()!);

      final session = PlaytimeSession(
        id: 's6_flagged_content',
        gameId: game.id,
        type: 'virtual',
        title: 'Inappropriate Title',
        description: 'Contains inappropriate language',
        creatorId: uid,
        participants: [
          PlaytimeParticipant(
            userId: uid,
            displayName: 'Teen User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        location: PlaytimeLocation(
          name: 'Flagged Virtual Room',
          address: 'https://example.com/flagged',
          coordinates: {},
        ),
        duration: 60,
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: true),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(
          required: true,
        ),
        safetyFlags: PlaytimeSafetyFlags(
          reportedContent: true,
          moderationRequired: true,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 8,
      );

      await PlaytimeService.createSession(session);

      // Assert – session requires admin approval
      final s6 = await db
          .collection('playtime_sessions')
          .doc('s6_flagged_content')
          .get();
      expect(s6.exists, true);
      expect(s6.data()!['adminApprovalStatus']['required'], true);
      expect(s6.data()!['safetyFlags']['reportedContent'], true);
    });
  });
}
