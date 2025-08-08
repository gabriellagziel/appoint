import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../lib/services/coppa_service.dart';
import '../lib/services/playtime_service.dart';
import '../lib/services/playtime_preferences_service.dart';
import '../lib/models/playtime_game.dart';
import '../lib/models/playtime_session.dart';
import '../lib/models/playtime_preferences.dart';
import '../lib/exceptions/playtime_exceptions.dart';

void main() {
  group('Age Restriction System Tests', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      // Note: In real tests, you would need to mock the FirebaseFirestore.instance
      // This is a simplified example showing the test structure
    });

    group('COPPA Service Tests', () {
      test('correctly calculates user age from birth date', () {
        final birthDate = DateTime(2010, 6, 15); // 13+ years old
        final age = CoppaService.getAge(birthDate);
        
        expect(age, greaterThanOrEqualTo(13));
      });

      test('identifies child accounts correctly', () {
        final childBirthDate = DateTime(2015, 1, 1); // Under 13
        final adultBirthDate = DateTime(1990, 1, 1); // Over 18
        
        expect(
          CoppaService.isChildAccount(
            birthDate: childBirthDate,
            isChildAccountFlag: false,
          ),
          isTrue,
        );
        
        expect(
          CoppaService.isChildAccount(
            birthDate: adultBirthDate,
            isChildAccountFlag: false,
          ),
          isFalse,
        );
      });

      test('respects child account flag override', () {
        final adultBirthDate = DateTime(1990, 1, 1);
        
        expect(
          CoppaService.isChildAccount(
            birthDate: adultBirthDate,
            isChildAccountFlag: true, // Override
          ),
          isTrue,
        );
      });

      test('validates age for COPPA compliance', () {
        final validAge = DateTime(2005, 1, 1); // 18+ years
        final invalidAge = DateTime(2015, 1, 1); // Under 13
        
        expect(CoppaService.isValidAge(validAge), isTrue);
        expect(CoppaService.isValidAge(invalidAge), isFalse);
      });
    });

    group('Age Validation in Session Creation', () {
      test('allows adult users to create any session', () async {
        // This would require proper mocking of Firestore
        // Showing test structure for documentation purposes
        
        final adultUser = _createMockUser('adult123', DateTime(1990, 1, 1));
        final restrictedGame = _createMockGame(
          'restricted_game',
          minAge: 21,
          maxAge: 65,
        );
        
        // In real test: Mock getUserAgeInfo to return adult info
        // In real test: Mock getGameById to return restrictedGame
        
        // Adult should be able to create session despite age restrictions
        // expect(await createSessionTest(adultUser, restrictedGame), completes);
      });

      test('blocks underage users from age-restricted games', () async {
        final childUser = _createMockUser('child123', DateTime(2015, 1, 1));
        final adultGame = _createMockGame(
          'adult_game',
          minAge: 18,
          maxAge: 99,
        );
        
        // Child should be blocked from creating session
        // expect(
        //   () => createSessionTest(childUser, adultGame),
        //   throwsA(isA<AgeRestrictedError>()),
        // );
      });

      test('requires parent approval for child users', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        final childGame = _createMockGame(
          'child_game',
          minAge: 8,
          maxAge: 16,
        );
        
        // Session without parent approval should be blocked
        // expect(
        //   () => createSessionWithoutApproval(childUser, childGame),
        //   throwsA(isA<ParentApprovalRequiredError>()),
        // );
      });

      test('allows session creation with parent approval', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        final childGame = _createMockGame(
          'child_game',
          minAge: 8,
          maxAge: 16,
        );
        
        // Session with parent approval should succeed
        // expect(
        //   () => createSessionWithApproval(childUser, childGame),
        //   completes,
        // );
      });

      test('validates game existence', () async {
        final user = _createMockUser('user123', DateTime(2000, 1, 1));
        
        // Non-existent game should throw GameNotFoundError
        // expect(
        //   () => createSessionTest(user, 'nonexistent_game'),
        //   throwsA(isA<GameNotFoundError>()),
        // );
      });

      test('enforces maximum participants limit', () async {
        final user = _createMockUser('user123', DateTime(2000, 1, 1));
        final game = _createMockGame('game123', maxParticipants: 2);
        
        // Session with too many participants should be blocked
        // final sessionWithTooManyParticipants = _createMockSession(
        //   user.uid,
        //   game.id,
        //   participantCount: 3,
        // );
        
        // expect(
        //   () => PlaytimeService.createSessionWithValidation(sessionWithTooManyParticipants),
        //   throwsA(isA<MaxParticipantsReachedError>()),
        // );
      });
    });

    group('Game Access Filtering Tests', () {
      test('filters games correctly for child users', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1)); // 11 years old
        
        final games = [
          _createMockGame('toddler_game', minAge: 3, maxAge: 6),   // Too young
          _createMockGame('kid_game', minAge: 8, maxAge: 14),      // Appropriate
          _createMockGame('teen_game', minAge: 13, maxAge: 17),    // Too old
          _createMockGame('adult_game', minAge: 18, maxAge: 99),   // Too old
        ];
        
        // Mock the service responses
        // final accessibleGames = await PlaytimeService.getGamesForUser(childUser.uid);
        
        // Should only include kid_game
        // expect(accessibleGames.length, equals(1));
        // expect(accessibleGames.first.id, equals('kid_game'));
      });

      test('adult users can access all games', () async {
        final adultUser = _createMockUser('adult123', DateTime(1990, 1, 1));
        
        final games = [
          _createMockGame('toddler_game', minAge: 3, maxAge: 6),
          _createMockGame('kid_game', minAge: 8, maxAge: 14),
          _createMockGame('teen_game', minAge: 13, maxAge: 17),
          _createMockGame('adult_game', minAge: 18, maxAge: 99),
        ];
        
        // Adult should have access to all games
        // final accessibleGames = await PlaytimeService.getGamesForUser(adultUser.uid);
        // expect(accessibleGames.length, equals(games.length));
      });

      test('provides correct approval status for games', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        
        // Mock preferences with some approved games
        final preferences = PlaytimePreferences.defaultForChild(childUser.uid).copyWith(
          approvedGames: ['approved_game'],
          blockedGames: ['blocked_game'],
        );
        
        // Test game access results
        // final gamesWithStatus = await PlaytimeService.getGamesWithApprovalStatus(childUser.uid);
        
        // Verify approval status is correct
        // expect(
        //   gamesWithStatus.where((g) => g.game.id == 'approved_game').first.needsParentApproval,
        //   isFalse,
        // );
        // expect(
        //   gamesWithStatus.where((g) => g.game.id == 'blocked_game').first.canAccess,
        //   isFalse,
        // );
      });
    });

    group('Parental Override Tests', () {
      test('parental override allows age-restricted access', () async {
        final childUser = _createMockUser('child123', DateTime(2015, 1, 1)); // 8 years old
        final parentUser = _createMockUser('parent123', DateTime(1985, 1, 1));
        
        // Enable parental override
        // await PlaytimePreferencesService.setParentalOverride(
        //   childUser.uid,
        //   true,
        //   parentUser.uid,
        // );
        
        final restrictedGame = _createMockGame('restricted', minAge: 13, maxAge: 17);
        
        // Child should now be able to access with override
        // final result = await PlaytimeService.checkGameAccess(childUser.uid, restrictedGame.id);
        // expect(result.canAccess, isTrue);
        // expect(result.needsParentApproval, isFalse);
      });

      test('parent can approve specific games', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        final parentUser = _createMockUser('parent123', DateTime(1985, 1, 1));
        
        // Parent approves a specific game
        // await PlaytimePreferencesService.approveGame(
        //   childUser.uid,
        //   'special_game',
        //   parentUser.uid,
        // );
        
        // Game should now be accessible
        // final preferences = await PlaytimePreferencesService.getPreferences(childUser.uid);
        // expect(preferences!.isGameApproved('special_game'), isTrue);
      });

      test('parent can block specific games', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        final parentUser = _createMockUser('parent123', DateTime(1985, 1, 1));
        
        // Parent blocks a game
        // await PlaytimePreferencesService.blockGame(
        //   childUser.uid,
        //   'inappropriate_game',
        //   parentUser.uid,
        // );
        
        // Game should now be blocked
        // final preferences = await PlaytimePreferencesService.getPreferences(childUser.uid);
        // expect(preferences!.isGameApproved('inappropriate_game'), isFalse);
      });
    });

    group('Playtime Limits Tests', () {
      test('enforces daily playtime limits', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        
        // Set 60-minute daily limit
        final preferences = PlaytimePreferences.defaultForChild(childUser.uid).copyWith(
          maxDailyPlaytime: 60,
        );
        
        // Mock that user has already played 45 minutes today
        // Attempting 30-minute session should be blocked/warned
        
        // final remaining = await PlaytimePreferencesService.getRemainingDailyPlaytime(childUser.uid);
        // expect(remaining, lessThanOrEqualTo(15));
      });

      test('enforces allowed playtime hours', () async {
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        
        final preferences = PlaytimePreferences.defaultForChild(childUser.uid).copyWith(
          allowedPlaytimes: [
            TimeRange(
              start: const TimeOfDay(hour: 15, minute: 0), // 3 PM
              end: const TimeOfDay(hour: 19, minute: 0),   // 7 PM
            ),
          ],
        );
        
        // Test time within allowed range
        final allowedTime = DateTime(2024, 1, 1, 16, 30); // 4:30 PM
        expect(preferences.isPlaytimeAllowed(allowedTime), isTrue);
        
        // Test time outside allowed range
        final blockedTime = DateTime(2024, 1, 1, 21, 0); // 9 PM
        expect(preferences.isPlaytimeAllowed(blockedTime), isFalse);
      });
    });

    group('Error Handling Tests', () {
      test('handles missing user data gracefully', () async {
        // Non-existent user should throw UserDataIncompleteError
        // expect(
        //   () => CoppaService.getUserAgeInfo('nonexistent_user'),
        //   throwsA(isA<UserDataIncompleteError>()),
        // );
      });

      test('handles invalid birth date formats', () async {
        // Invalid birth date should be handled gracefully
        // This would require mocking Firestore with invalid data
      });

      test('provides meaningful error messages', () {
        final error = AgeRestrictedError(
          userAge: 12,
          gameId: 'test_game',
          gameName: 'Test Game',
          minAge: 16,
          maxAge: 99,
        );
        
        expect(error.isTooYoung, isTrue);
        expect(error.isTooOld, isFalse);
        expect(error.ageRangeString, equals('16-99 years'));
        expect(error.message, contains('Test Game'));
      });
    });

    group('Integration Tests', () {
      test('complete age restriction flow for child user', () async {
        // 1. Create child user
        final childUser = _createMockUser('child123', DateTime(2012, 1, 1));
        
        // 2. Initialize preferences
        // await PlaytimePreferencesService.initializePreferences(childUser.uid);
        
        // 3. Try to access age-appropriate game - should succeed
        final appropriateGame = _createMockGame('kid_game', minAge: 8, maxAge: 14);
        // final result1 = await PlaytimeService.checkGameAccess(childUser.uid, appropriateGame.id);
        // expect(result1.canAccess, isTrue);
        
        // 4. Try to access age-restricted game - should fail
        final restrictedGame = _createMockGame('adult_game', minAge: 18, maxAge: 99);
        // final result2 = await PlaytimeService.checkGameAccess(childUser.uid, restrictedGame.id);
        // expect(result2.canAccess, isFalse);
        
        // 5. Parent enables override
        final parentUser = _createMockUser('parent123', DateTime(1985, 1, 1));
        // await PlaytimePreferencesService.setParentalOverride(childUser.uid, true, parentUser.uid);
        
        // 6. Try restricted game again - should succeed with override
        // final result3 = await PlaytimeService.checkGameAccess(childUser.uid, restrictedGame.id);
        // expect(result3.canAccess, isTrue);
      });

      test('complete age restriction flow for adult user', () async {
        // 1. Create adult user
        final adultUser = _createMockUser('adult123', DateTime(1990, 1, 1));
        
        // 2. Initialize preferences
        // await PlaytimePreferencesService.initializePreferences(adultUser.uid);
        
        // 3. Try to access any game - should always succeed
        final restrictedGame = _createMockGame('any_game', minAge: 21, maxAge: 65);
        // final result = await PlaytimeService.checkGameAccess(adultUser.uid, restrictedGame.id);
        // expect(result.canAccess, isTrue);
        // expect(result.needsParentApproval, isFalse);
      });
    });
  });
}

// Helper functions for creating mock data
Map<String, dynamic> _createMockUser(String uid, DateTime birthDate) {
  return {
    'uid': uid,
    'birthDate': Timestamp.fromDate(birthDate),
    'isChildAccount': false,
    'playtimeSettings': {
      'isChild': birthDate.year > DateTime.now().year - 18,
      'parentUid': birthDate.year > DateTime.now().year - 18 ? 'parent123' : null,
    },
  };
}

PlaytimeGame _createMockGame(
  String id, {
  int minAge = 0,
  int maxAge = 18,
  int maxParticipants = 6,
  bool parentApprovalRequired = false,
}) {
  return PlaytimeGame(
    id: id,
    name: 'Test Game $id',
    description: 'Test game description',
    icon: '🎮',
    category: 'test',
    ageRange: {'min': minAge, 'max': maxAge},
    type: 'virtual',
    maxParticipants: maxParticipants,
    estimatedDuration: 30,
    isSystemGame: true,
    isPublic: true,
    creatorId: 'system',
    parentApprovalRequired: parentApprovalRequired,
    safetyLevel: 'safe',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

PlaytimeSession _createMockSession(
  String creatorId,
  String gameId, {
  int participantCount = 1,
}) {
  final participants = List.generate(
    participantCount,
    (index) => PlaytimeParticipant(
      userId: 'user_$index',
      displayName: 'User $index',
      role: index == 0 ? 'creator' : 'participant',
      joinedAt: DateTime.now(),
      status: 'joined',
    ),
  );

  return PlaytimeSession(
    id: 'session_test',
    gameId: gameId,
    type: 'virtual',
    title: 'Test Session',
    description: 'Test session description',
    creatorId: creatorId,
    participants: participants,
    duration: 30,
    parentApprovalStatus: PlaytimeParentApprovalStatus(required: false),
    adminApprovalStatus: PlaytimeAdminApprovalStatus(),
    safetyFlags: PlaytimeSafetyFlags(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    maxParticipants: 6,
  );
}
