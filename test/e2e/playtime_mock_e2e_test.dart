import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/coppa_service.dart';
import '../../lib/services/playtime_preferences_service.dart';
import '../../lib/models/playtime_session.dart';
import '../../lib/models/playtime_game.dart';

/// Mock E2E test that validates business logic without Firebase dependencies
void main() {
  group('Playtime E2E – Business Logic Validation', () {
    test('Adult (18+) can create any session without approval', () {
      // Mock user data
      const userAge = 25;
      const gameMinAge = 18;

      // Validate business logic
      expect(COPPAService.isAdult(userAge), true);
      expect(COPPAService.isGameAgeAppropriate(userAge, gameMinAge), true);
      expect(COPPAService.requiresParentApproval(userAge, gameMinAge), false);

      // Create session object (would normally be saved to Firestore)
      final session = PlaytimeSession(
        id: 'test_adult_session',
        gameId: 'mature_game',
        type: 'virtual',
        title: 'Adult Virtual Session',
        description: 'Mature game session for adults',
        creatorId: 'adult_user',
        participants: [
          PlaytimeParticipant(
            userId: 'adult_user',
            displayName: 'Adult User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        duration: 120,
        status: 'approved', // Adults get immediate approval
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: false),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 8,
      );

      // Validate session properties
      expect(session.isVirtual, true);
      expect(session.requiresParentApproval, false);
      expect(session.isParentApproved, true);
      expect(session.canJoin, true);
    });

    test('Child (10) blocked for age-inappropriate games', () {
      // Mock user data
      const userAge = 10;
      const gameMinAge = 18;

      // Validate business logic
      expect(COPPAService.isSubjectToCOPPA(userAge), true);
      expect(COPPAService.isGameAgeAppropriate(userAge, gameMinAge), false);
      expect(COPPAService.requiresParentApproval(userAge, gameMinAge), true);

      // Attempt to create session (should be blocked)
      final session = PlaytimeSession(
        id: 'test_child_blocked_session',
        gameId: 'mature_game',
        type: 'virtual',
        title: 'Child Blocked Session',
        description: 'Should be blocked',
        creatorId: 'child_user',
        participants: [
          PlaytimeParticipant(
            userId: 'child_user',
            displayName: 'Child User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        duration: 60,
        status: 'pending_approval',
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: true),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 6,
      );

      // Validate session requires approval
      expect(session.requiresParentApproval, true);
      expect(session.isParentApproved, false);
      expect(session.canJoin, false); // Cannot join without approval
    });

    test('Teen (15) needs parent approval for age-restricted games', () {
      // Mock user data
      const userAge = 15;
      const gameMinAge = 18;

      // Validate business logic
      expect(COPPAService.isSubjectToCOPPA(userAge), false);
      expect(COPPAService.isGameAgeAppropriate(userAge, gameMinAge), false);
      expect(COPPAService.requiresParentApproval(userAge, gameMinAge), true);

      // Create session requiring approval
      final session = PlaytimeSession(
        id: 'test_teen_approval_session',
        gameId: 'mature_game',
        type: 'virtual',
        title: 'Teen Approval Session',
        description: 'Requires parent approval',
        creatorId: 'teen_user',
        participants: [
          PlaytimeParticipant(
            userId: 'teen_user',
            displayName: 'Teen User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        duration: 90,
        status: 'pending_approval',
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: true),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 6,
      );

      // Validate initial state
      expect(session.requiresParentApproval, true);
      expect(session.isParentApproved, false);
      expect(session.canJoin, false);

      // Simulate parent approval
      final approvedSession = session.copyWith(
        status: 'approved',
        parentApprovalStatus: PlaytimeParentApprovalStatus(
          required: true,
          approvedBy: ['parent_user'],
          approvedAt: DateTime.now(),
        ),
      );

      // Validate approved state
      expect(approvedSession.requiresParentApproval, true);
      expect(approvedSession.isParentApproved, true);
      expect(approvedSession.canJoin, true);
    });

    test('Child can create age-appropriate session with parent approval', () {
      // Mock user data
      const userAge = 10;
      const gameMinAge = 8;

      // Validate business logic
      expect(COPPAService.isSubjectToCOPPA(userAge), true);
      expect(COPPAService.isGameAgeAppropriate(userAge, gameMinAge), true);
      expect(COPPAService.requiresParentApproval(userAge, gameMinAge),
          true); // Still needs approval due to COPPA

      // Create session with parent approval
      final session = PlaytimeSession(
        id: 'test_child_appropriate_session',
        gameId: 'child_game',
        type: 'virtual',
        title: 'Child Appropriate Session',
        description: 'Age-appropriate game with parent approval',
        creatorId: 'child_user',
        participants: [
          PlaytimeParticipant(
            userId: 'child_user',
            displayName: 'Child User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        duration: 60,
        status: 'approved',
        parentApprovalStatus: PlaytimeParentApprovalStatus(
          required: true,
          approvedBy: ['parent_user'],
          approvedAt: DateTime.now(),
        ),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 8,
      );

      // Validate approved session
      expect(session.requiresParentApproval, true);
      expect(session.isParentApproved, true);
      expect(session.canJoin, true);
    });

    test('Safety flags work correctly for inappropriate content', () {
      // Create session with safety issues
      final flaggedSession = PlaytimeSession(
        id: 'test_flagged_session',
        gameId: 'any_game',
        type: 'virtual',
        title: 'Inappropriate Title',
        description: 'Contains inappropriate language',
        creatorId: 'any_user',
        participants: [
          PlaytimeParticipant(
            userId: 'any_user',
            displayName: 'Any User',
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        duration: 60,
        status: 'pending_approval',
        parentApprovalStatus: PlaytimeParentApprovalStatus(required: true),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(required: true),
        safetyFlags: PlaytimeSafetyFlags(
          reportedContent: true,
          moderationRequired: true,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: 6,
      );

      // Validate safety flags
      expect(flaggedSession.safetyFlags.hasSafetyIssues, true);
      expect(flaggedSession.safetyFlags.reportedContent, true);
      expect(flaggedSession.safetyFlags.moderationRequired, true);
      expect(flaggedSession.adminApprovalStatus.required, true);
    });
  });

  group('Playtime E2E – Age Category Validation', () {
    test('All age categories are correctly identified', () {
      // Test child category (under 13)
      expect(COPPAService.getAgeCategory(5), 'child');
      expect(COPPAService.getAgeCategory(10), 'child');
      expect(COPPAService.getAgeCategory(12), 'child');

      // Test teen category (13-17)
      expect(COPPAService.getAgeCategory(13), 'teen');
      expect(COPPAService.getAgeCategory(15), 'teen');
      expect(COPPAService.getAgeCategory(17), 'teen');

      // Test adult category (18+)
      expect(COPPAService.getAgeCategory(18), 'adult');
      expect(COPPAService.getAgeCategory(25), 'adult');
      expect(COPPAService.getAgeCategory(65), 'adult');
    });

    test('COPPA compliance is correctly enforced', () {
      // Children under 13 are subject to COPPA
      expect(COPPAService.isSubjectToCOPPA(5), true);
      expect(COPPAService.isSubjectToCOPPA(10), true);
      expect(COPPAService.isSubjectToCOPPA(12), true);

      // Teens and adults are not subject to COPPA
      expect(COPPAService.isSubjectToCOPPA(13), false);
      expect(COPPAService.isSubjectToCOPPA(15), false);
      expect(COPPAService.isSubjectToCOPPA(18), false);
      expect(COPPAService.isSubjectToCOPPA(25), false);
    });
  });

  group('Playtime E2E – Game Age Validation', () {
    test('Age-appropriate games are correctly identified', () {
      // Child (10) playing age-appropriate games
      expect(
          COPPAService.isGameAgeAppropriate(10, 8), true); // Can play 8+ game
      expect(
          COPPAService.isGameAgeAppropriate(10, 10), true); // Can play 10+ game
      expect(COPPAService.isGameAgeAppropriate(10, 12),
          false); // Cannot play 12+ game

      // Teen (15) playing age-appropriate games
      expect(
          COPPAService.isGameAgeAppropriate(15, 13), true); // Can play 13+ game
      expect(
          COPPAService.isGameAgeAppropriate(15, 15), true); // Can play 15+ game
      expect(COPPAService.isGameAgeAppropriate(15, 18),
          false); // Cannot play 18+ game

      // Adult (25) can play any game
      expect(
          COPPAService.isGameAgeAppropriate(25, 8), true); // Can play 8+ game
      expect(
          COPPAService.isGameAgeAppropriate(25, 18), true); // Can play 18+ game
      expect(
          COPPAService.isGameAgeAppropriate(25, 21), true); // Can play 21+ game
    });
  });
}
