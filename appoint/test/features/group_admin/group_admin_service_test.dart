import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../lib/features/group_admin/services/group_admin_service.dart';
import '../../lib/features/group_admin/services/group_vote_service.dart';
import '../../lib/features/group_admin/services/group_audit_service.dart';
import '../../lib/features/group_admin/services/group_policy_service.dart';
import '../../lib/models/group_role.dart';
import '../../lib/models/group_policy.dart';
import '../../lib/models/group_vote.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockGroupVoteService extends Mock implements GroupVoteService {}

class MockGroupAuditService extends Mock implements GroupAuditService {}

class MockGroupPolicyService extends Mock implements GroupPolicyService {}

void main() {
  group('GroupAdminService', () {
    late GroupAdminService service;
    late MockFirebaseFirestore mockFirestore;
    late MockGroupVoteService mockVoteService;
    late MockGroupAuditService mockAuditService;
    late MockGroupPolicyService mockPolicyService;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockVoteService = MockGroupVoteService();
      mockAuditService = MockGroupAuditService();
      mockPolicyService = MockGroupPolicyService();
      service = GroupAdminService();
    });

    group('promoteToAdmin', () {
      test('promotes member to admin when policy allows direct promotion',
          () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user1';

        when(() => mockPolicyService.getPolicy(groupId)).thenAnswer(
            (_) async => const GroupPolicy(requireVoteForAdmin: false));

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.owner);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.member);

        // Act
        final result =
            await service.promoteToAdmin(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isTrue);
        verify(() => mockAuditService.logEvent(
              groupId: groupId,
              actorUserId: actorUserId,
              type: any(named: 'type'),
              targetUserId: targetUserId,
            )).called(1);
      });

      test('opens vote when policy requires voting', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user1';

        when(() => mockPolicyService.getPolicy(groupId)).thenAnswer(
            (_) async => const GroupPolicy(requireVoteForAdmin: true));

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.admin);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.member);

        when(() => mockVoteService.openVote(
              groupId: groupId,
              action: VoteAction.promoteAdmin,
              targetUserId: targetUserId,
              createdBy: actorUserId,
              closesAt: any(named: 'closesAt'),
            )).thenAnswer((_) async => true);

        // Act
        final result =
            await service.promoteToAdmin(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isTrue);
        verify(() => mockVoteService.openVote(
              groupId: groupId,
              action: VoteAction.promoteAdmin,
              targetUserId: targetUserId,
              createdBy: actorUserId,
              closesAt: any(named: 'closesAt'),
            )).called(1);
      });

      test('fails when actor is not authorized', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user3';

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.member);

        // Act
        final result =
            await service.promoteToAdmin(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isFalse);
      });
    });

    group('demoteAdmin', () {
      test('demotes admin to member when policy allows direct demotion',
          () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user1';

        when(() => mockPolicyService.getPolicy(groupId)).thenAnswer(
            (_) async => const GroupPolicy(requireVoteForAdmin: false));

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.owner);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.admin);

        // Act
        final result =
            await service.demoteAdmin(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isTrue);
      });

      test('opens vote when policy requires voting for demotion', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user1';

        when(() => mockPolicyService.getPolicy(groupId)).thenAnswer(
            (_) async => const GroupPolicy(requireVoteForAdmin: true));

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.admin);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.admin);

        when(() => mockVoteService.openVote(
              groupId: groupId,
              action: VoteAction.demoteAdmin,
              targetUserId: targetUserId,
              createdBy: actorUserId,
              closesAt: any(named: 'closesAt'),
            )).thenAnswer((_) async => true);

        // Act
        final result =
            await service.demoteAdmin(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isTrue);
        verify(() => mockVoteService.openVote(
              groupId: groupId,
              action: VoteAction.demoteAdmin,
              targetUserId: targetUserId,
              createdBy: actorUserId,
              closesAt: any(named: 'closesAt'),
            )).called(1);
      });
    });

    group('transferOwnership', () {
      test('transfers ownership when actor is owner', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user1';

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.owner);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.admin);

        when(() => mockVoteService.openVote(
              groupId: groupId,
              action: VoteAction.transferOwnership,
              targetUserId: targetUserId,
              createdBy: actorUserId,
              closesAt: any(named: 'closesAt'),
            )).thenAnswer((_) async => true);

        // Act
        final result =
            await service.transferOwnership(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isTrue);
        verify(() => mockVoteService.openVote(
              groupId: groupId,
              action: VoteAction.transferOwnership,
              targetUserId: targetUserId,
              createdBy: actorUserId,
              closesAt: any(named: 'closesAt'),
            )).called(1);
      });

      test('fails when actor is not owner', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user3';

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.admin);

        // Act
        final result =
            await service.transferOwnership(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isFalse);
      });
    });

    group('removeMember', () {
      test('removes member when actor has permission', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user1';

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.owner);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.member);

        // Act
        final result =
            await service.removeMember(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isTrue);
      });

      test('fails when trying to remove owner', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user1';
        const actorUserId = 'user2';

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.admin);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.owner);

        // Act
        final result =
            await service.removeMember(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isFalse);
      });

      test('fails when admin tries to remove another admin', () async {
        // Arrange
        const groupId = 'group1';
        const targetUserId = 'user2';
        const actorUserId = 'user3';

        when(() => service.getUserRole(groupId, actorUserId))
            .thenAnswer((_) async => GroupRole.admin);

        when(() => service.getUserRole(groupId, targetUserId))
            .thenAnswer((_) async => GroupRole.admin);

        // Act
        final result =
            await service.removeMember(groupId, targetUserId, actorUserId);

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
