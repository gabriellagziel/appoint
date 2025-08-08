import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../lib/services/playtime_service.dart';
import '../../lib/services/coppa_service.dart';
import '../../lib/models/playtime_game.dart';
import '../../lib/models/playtime_session.dart';
import '../../lib/exceptions/playtime_exceptions.dart';

void main() {
  group('Playtime Age Restriction Tests', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      // Set up test data
      _setupTestData(fakeFirestore);
    });

    group('Age Validation', () {
      test('Adult user (18+) bypasses all age restrictions', () async {
        // Setup: Adult user (25 years old)
        await _createTestUser(fakeFirestore, 'adult_user', age: 25);
        await _createTestGame(fakeFirestore, 'kids_game',
            minAge: 5, maxAge: 12);

        final session = _createTestSession('adult_user', 'kids_game');

        // Adult should be able to create session for any game
        expect(() async {
          await PlaytimeService.createSessionWithValidation(session);
        }, returnsNormally);
      });

      test('Child user blocked from age-inappropriate game (too young)',
          () async {
        // Setup: Child user (8 years old)
        await _createTestUser(fakeFirestore, 'child_user', age: 8);
        await _createTestGame(fakeFirestore, 'teen_game',
            minAge: 13, maxAge: 17);

        final session = _createTestSession('child_user', 'teen_game');

        // Should throw AgeRestrictedError
        expect(() async {
          await PlaytimeService.createSessionWithValidation(session);
        }, throwsA(isA<AgeRestrictedError>()));
      });

      test('Child user blocked from age-inappropriate game (too old)',
          () async {
        // Setup: Teen user (16 years old)
        await _createTestUser(fakeFirestore, 'teen_user', age: 16);
        await _createTestGame(fakeFirestore, 'kids_game',
            minAge: 5, maxAge: 12);

        final session = _createTestSession('teen_user', 'kids_game');

        // Should throw AgeRestrictedError
        expect(() async {
          await PlaytimeService.createSessionWithValidation(session);
        }, throwsA(isA<AgeRestrictedError>()));
      });

      test('Child user can access age-appropriate game', () async {
        // Setup: Child user (10 years old)
        await _createTestUser(fakeFirestore, 'child_user', age: 10);
        await _createTestGame(fakeFirestore, 'kids_game',
            minAge: 8, maxAge: 14);

        final session = _createTestSession('child_user', 'kids_game');

        // Should succeed
        expect(() async {
          await PlaytimeService.createSessionWithValidation(session);
        }, returnsNormally);
      });
    });

    group('Parent Approval', () {
      test('Child without parent approval blocked from creating session',
          () async {
        // Setup: Child user (12 years old)
        await _createTestUser(fakeFirestore, 'child_user',
            age: 12, isChild: true);
        await _createTestGame(fakeFirestore, 'supervised_game',
            minAge: 10, maxAge: 16, parentApprovalRequired: true);

        final session = _createTestSession('child_user', 'supervised_game',
            parentApproved: false);

        // Should throw ParentApprovalRequiredError
        expect(() async {
          await PlaytimeService.createSessionWithValidation(session);
        }, throwsA(isA<ParentApprovalRequiredError>()));
      });

      test('Child with parent approval can create session', () async {
        // Setup: Child user (12 years old) with parent approval
        await _createTestUser(fakeFirestore, 'child_user',
            age: 12, isChild: true);
        await _createTestGame(fakeFirestore, 'supervised_game',
            minAge: 10, maxAge: 16, parentApprovalRequired: true);

        final session = _createTestSession('child_user', 'supervised_game',
            parentApproved: true);

        // Should succeed
        expect(() async {
          await PlaytimeService.createSessionWithValidation(session);
        }, returnsNormally);
      });

      test(
          'Child with parental override can create session without explicit approval',
          () async {
        // Setup: Child user with parental override enabled
        await _createTestUser(fakeFirestore, 'child_user',
            age: 12, isChild: true, hasOverride: true);
        await _createTestGame(fakeFirestore, 'supervised_game',
            minAge: 10, maxAge: 16, parentApprovalRequired: true);

        final session = _createTestSession('child_user', 'supervised_game',
            parentApproved: false);

        // Should succeed due to override
        expect(() async {
          await PlaytimeService.createSessionWithValidation(session);
        }, returnsNormally);
      });
    });

    group('COPPA Service Tests', () {
      test('getUserAge returns correct age for valid user', () async {
        await _createTestUser(fakeFirestore, 'test_user', age: 15);

        final age = await CoppaService.getUserAge('test_user');
        expect(age, equals(15));
      });

      test('getUserAge throws UserDataIncompleteError for missing user',
          () async {
        expect(() async {
          await CoppaService.getUserAge('nonexistent_user');
        }, throwsA(isA<UserDataIncompleteError>()));
      });

      test('isAdultUser returns true for 18+ users', () async {
        await _createTestUser(fakeFirestore, 'adult_user', age: 25);

        final isAdult = await CoppaService.isAdultUser('adult_user');
        expect(isAdult, isTrue);
      });

      test('isAdultUser returns false for under 18 users', () async {
        await _createTestUser(fakeFirestore, 'child_user', age: 12);

        final isAdult = await CoppaService.isAdultUser('child_user');
        expect(isAdult, isFalse);
      });
    });

    group('Game Filtering Tests', () {
      test('getGamesForUser returns all games for adult', () async {
        await _createTestUser(fakeFirestore, 'adult_user', age: 25);
        await _createTestGame(fakeFirestore, 'kids_game',
            minAge: 5, maxAge: 12);
        await _createTestGame(fakeFirestore, 'teen_game',
            minAge: 13, maxAge: 17);
        await _createTestGame(fakeFirestore, 'adult_game',
            minAge: 18, maxAge: 99);

        final games = await PlaytimeService.getGamesForUser('adult_user');
        expect(games.length, equals(3));
      });

      test('getGamesForUser filters games for child user', () async {
        await _createTestUser(fakeFirestore, 'child_user', age: 10);
        await _createTestGame(fakeFirestore, 'kids_game',
            minAge: 5, maxAge: 12);
        await _createTestGame(fakeFirestore, 'teen_game',
            minAge: 13, maxAge: 17);
        await _createTestGame(fakeFirestore, 'adult_game',
            minAge: 18, maxAge: 99);

        final games = await PlaytimeService.getGamesForUser('child_user');
        expect(games.length, equals(1));
        expect(games.first.name, equals('kids_game'));
      });

      test('checkGameAccess returns correct access result', () async {
        await _createTestUser(fakeFirestore, 'child_user', age: 10);
        await _createTestGame(fakeFirestore, 'teen_game',
            minAge: 13, maxAge: 17);

        final result =
            await PlaytimeService.checkGameAccess('child_user', 'teen_game');
        expect(result.canAccess, isFalse);
        expect(result.error, contains('too young'));
      });
    });

    group('Exception Details Tests', () {
      test('AgeRestrictedError contains correct details', () {
        final error = AgeRestrictedError(
          userAge: 10,
          gameId: 'teen_game',
          gameName: 'Teen Game',
          minAge: 13,
          maxAge: 17,
        );

        expect(error.userAge, equals(10));
        expect(error.isTooYoung, isTrue);
        expect(error.isTooOld, isFalse);
        expect(error.ageRangeString, equals('13-17 years'));
      });

      test('ParentApprovalRequiredError contains correct details', () {
        final error = ParentApprovalRequiredError(
          userId: 'child_user',
          gameId: 'supervised_game',
          gameName: 'Supervised Game',
          isChildUser: true,
        );

        expect(error.userId, equals('child_user'));
        expect(error.isChildUser, isTrue);
        expect(error.message, contains('Parent approval required'));
      });
    });
  });
}

// Helper functions for test setup

void _setupTestData(FakeFirebaseFirestore firestore) {
  // Any global test data setup can go here
}

Future<void> _createTestUser(
  FakeFirebaseFirestore firestore,
  String userId, {
  required int age,
  bool isChild = false,
  bool hasOverride = false,
}) async {
  final birthDate = DateTime.now().subtract(Duration(days: age * 365));

  await firestore.collection('users').doc(userId).set({
    'birthDate': Timestamp.fromDate(birthDate),
    'isChildAccount': isChild,
    'playtimeSettings': {
      'isChild': isChild,
      'allowOverrideAgeRestriction': hasOverride,
    },
  });
}

Future<void> _createTestGame(
  FakeFirebaseFirestore firestore,
  String gameId, {
  required int minAge,
  required int maxAge,
  bool parentApprovalRequired = false,
}) async {
  await firestore.collection('playtime_games').doc(gameId).set({
    'id': gameId,
    'name': gameId,
    'description': 'Test game',
    'ageRange': {'min': minAge, 'max': maxAge},
    'parentApprovalRequired': parentApprovalRequired,
    'isActive': true,
    'type': 'virtual',
    'maxParticipants': 4,
    'estimatedDuration': 30,
    'icon': '🎮',
    'safetyLevel': 'moderate',
  });
}

PlaytimeSession _createTestSession(
  String userId,
  String gameId, {
  bool parentApproved = false,
}) {
  return PlaytimeSession(
    id: 'test_session',
    gameId: gameId,
    type: 'virtual',
    title: 'Test Session',
    creatorId: userId,
    participants: [
      PlaytimeParticipant(
        userId: userId,
        displayName: 'Test User',
        role: 'creator',
        joinedAt: DateTime.now(),
        status: 'joined',
      ),
    ],
    duration: 30,
    parentApprovalStatus: PlaytimeParentApprovalStatus(
      required: !parentApproved,
      isApproved: parentApproved,
      approvedBy: parentApproved ? 'parent_user' : null,
      approvedAt: parentApproved ? DateTime.now() : null,
    ),
    adminApprovalStatus: PlaytimeAdminApprovalStatus(),
    safetyFlags: PlaytimeSafetyFlags(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    maxParticipants: 4,
  );
}

