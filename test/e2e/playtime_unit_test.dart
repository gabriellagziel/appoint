import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/coppa_service.dart';
import '../../lib/services/playtime_preferences_service.dart';
import '../../lib/models/playtime_session.dart';
import '../../lib/models/playtime_game.dart';

void main() {
  group('Playtime Age Enforcement Unit Tests', () {
    test('COPPA age categorization works correctly', () {
      // Test age categories
      expect(COPPAService.getAgeCategory(10), 'child');
      expect(COPPAService.getAgeCategory(15), 'teen');
      expect(COPPAService.getAgeCategory(25), 'adult');

      // Test COPPA compliance
      expect(COPPAService.isSubjectToCOPPA(10), true);
      expect(COPPAService.isSubjectToCOPPA(15), false);
      expect(COPPAService.isSubjectToCOPPA(25), false);

      // Test adult status
      expect(COPPAService.isAdult(10), false);
      expect(COPPAService.isAdult(15), false);
      expect(COPPAService.isAdult(25), true);
    });

    test('Age appropriateness checks work correctly', () {
      // Age-appropriate scenarios
      expect(COPPAService.isGameAgeAppropriate(10, 8),
          true); // Child can play age 8+ game
      expect(COPPAService.isGameAgeAppropriate(15, 13),
          true); // Teen can play age 13+ game
      expect(COPPAService.isGameAgeAppropriate(25, 18),
          true); // Adult can play age 18+ game

      // Age-inappropriate scenarios
      expect(COPPAService.isGameAgeAppropriate(10, 18),
          false); // Child cannot play mature game
      expect(COPPAService.isGameAgeAppropriate(15, 18),
          false); // Teen cannot play mature game without approval
    });

    test('Parent approval requirements work correctly', () {
      // Children always need parent approval
      expect(COPPAService.requiresParentApproval(10, 8),
          true); // Even for age-appropriate games
      expect(COPPAService.requiresParentApproval(10, 18),
          true); // Especially for inappropriate games

      // Teens need approval for inappropriate games only
      expect(COPPAService.requiresParentApproval(15, 13),
          false); // Age-appropriate game
      expect(COPPAService.requiresParentApproval(15, 18),
          true); // Inappropriate game

      // Adults never need approval
      expect(COPPAService.requiresParentApproval(25, 8), false);
      expect(COPPAService.requiresParentApproval(25, 18), false);
    });

    test('PlaytimeSession model works correctly', () {
      final session = PlaytimeSession(
        id: 'test_session',
        gameId: 'minecraft',
        type: 'virtual',
        title: 'Test Session',
        description: 'A test session',
        creatorId: 'user123',
        participants: [
          PlaytimeParticipant(
            userId: 'user123',
            displayName: 'Test User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        duration: 60,
        status: 'approved', // Need approved status for canJoin to be true
        parentApprovalStatus: PlaytimeParentApprovalStatus(
          required: true,
          approvedBy: ['parent123'],
        ),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 6,
      );

      // Test session properties
      expect(session.isVirtual, true);
      expect(session.requiresParentApproval, true);
      expect(session.isParentApproved, true);
      expect(session.canJoin, true);
      expect(session.isFull, false);
    });

    test('PlaytimeGame model works correctly', () {
      final game = PlaytimeGame(
        id: 'minecraft',
        name: 'Minecraft',
        description: 'Block building game',
        icon: '🎮',
        category: 'creative',
        ageRange: {'min': 8, 'max': 99},
        type: 'virtual',
        maxParticipants: 10,
        estimatedDuration: 120,
        isSystemGame: true,
        isPublic: true,
        creatorId: 'system',
        parentApprovalRequired: true,
        safetyLevel: 'safe',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Test game properties
      expect(game.isVirtual, true);
      expect(game.minAge, 8);
      expect(game.maxAge, 99);
      expect(game.isPublic, true);
    });

    test('PlaytimePreferences model works correctly', () {
      final prefs = PlaytimePreferences(
        parentId: 'parent123',
        allowOverrideAgeRestriction: true,
        blockedGames: ['violent_game'],
        allowedPlatforms: ['PC', 'Console'],
        maxSessionDuration: 120,
        allowVirtualSessions: true,
        allowPhysicalSessions: true,
        requirePreApproval: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Test preference properties
      expect(prefs.allowOverrideAgeRestriction, true);
      expect(prefs.blockedGames, contains('violent_game'));
      expect(prefs.allowedPlatforms, contains('PC'));
      expect(prefs.maxSessionDuration, 120);
    });

    test('Parent approval status works correctly', () {
      // Test pending approval
      final pendingApproval = PlaytimeParentApprovalStatus(required: true);
      expect(pendingApproval.isApproved, false);
      expect(pendingApproval.isPending, true);
      expect(pendingApproval.isDeclined, false);

      // Test approved status
      final approvedStatus = PlaytimeParentApprovalStatus(
        required: true,
        approvedBy: ['parent123'],
        approvedAt: DateTime.now(),
      );
      expect(approvedStatus.isApproved, true);
      expect(approvedStatus.isPending, false);

      // Test declined status
      final declinedStatus = PlaytimeParentApprovalStatus(
        required: true,
        declinedBy: ['parent123'],
        declinedAt: DateTime.now(),
      );
      expect(declinedStatus.isDeclined, true);
      expect(declinedStatus.isPending, false);
    });

    test('Safety flags work correctly', () {
      // Test safe session
      final safeFlags = PlaytimeSafetyFlags();
      expect(safeFlags.hasSafetyIssues, false);

      // Test flagged session
      final flaggedSession = PlaytimeSafetyFlags(
        reportedContent: true,
        moderationRequired: true,
      );
      expect(flaggedSession.hasSafetyIssues, true);
    });
  });

  group('Age-Based Scenario Validation', () {
    test('Adult (18+) scenario validation', () {
      const userAge = 25;
      const gameMinAge = 18;

      expect(COPPAService.isAdult(userAge), true);
      expect(COPPAService.isGameAgeAppropriate(userAge, gameMinAge), true);
      expect(COPPAService.requiresParentApproval(userAge, gameMinAge), false);
    });

    test('Teen (13-17) scenario validation', () {
      const userAge = 15;
      const appropriateGameAge = 13;
      const matureGameAge = 18;

      expect(COPPAService.isAdult(userAge), false);
      expect(COPPAService.isSubjectToCOPPA(userAge), false);

      // Age-appropriate game
      expect(
          COPPAService.isGameAgeAppropriate(userAge, appropriateGameAge), true);
      expect(COPPAService.requiresParentApproval(userAge, appropriateGameAge),
          false);

      // Mature game
      expect(COPPAService.isGameAgeAppropriate(userAge, matureGameAge), false);
      expect(COPPAService.requiresParentApproval(userAge, matureGameAge), true);
    });

    test('Child (<13) scenario validation', () {
      const userAge = 10;
      const appropriateGameAge = 8;
      const matureGameAge = 18;

      expect(COPPAService.isSubjectToCOPPA(userAge), true);
      expect(COPPAService.isAdult(userAge), false);

      // Even age-appropriate games need parent approval for children
      expect(
          COPPAService.isGameAgeAppropriate(userAge, appropriateGameAge), true);
      expect(COPPAService.requiresParentApproval(userAge, appropriateGameAge),
          true);

      // Mature games definitely need approval
      expect(COPPAService.isGameAgeAppropriate(userAge, matureGameAge), false);
      expect(COPPAService.requiresParentApproval(userAge, matureGameAge), true);
    });
  });
}
