import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../lib/models/user_group.dart';
import '../../lib/models/group_invite.dart';
import '../../lib/services/group_sharing_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockWriteBatch extends Mock implements WriteBatch {}

void main() {
  group('GroupSharingService', () {
    late GroupSharingService service;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockGroupsCollection;
    late MockCollectionReference mockInvitesCollection;
    late MockDocumentReference mockGroupDoc;
    late MockDocumentReference mockInviteDoc;
    late MockDocumentSnapshot mockGroupSnapshot;
    late MockDocumentSnapshot mockInviteSnapshot;
    late MockWriteBatch mockBatch;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockGroupsCollection = MockCollectionReference();
      mockInvitesCollection = MockCollectionReference();
      mockGroupDoc = MockDocumentReference();
      mockInviteDoc = MockDocumentReference();
      mockGroupSnapshot = MockDocumentSnapshot();
      mockInviteSnapshot = MockDocumentSnapshot();
      mockBatch = MockWriteBatch();

      service = GroupSharingService();
      
      // Setup default mocks
      when(() => mockFirestore.collection('user_groups')).thenReturn(mockGroupsCollection);
      when(() => mockFirestore.collection('group_invites')).thenReturn(mockInvitesCollection);
      when(() => mockFirestore.batch()).thenReturn(mockBatch);
      when(() => mockGroupsCollection.doc(any())).thenReturn(mockGroupDoc);
      when(() => mockInvitesCollection.doc(any())).thenReturn(mockInviteDoc);
    });

    group('createGroupInvite', () {
      test('should create group and invite successfully', () async {
        // Arrange
        const creatorId = 'test-creator';
        const groupName = 'Test Group';
        const description = 'Test Description';

        when(() => mockBatch.set(any(), any())).thenReturn(mockBatch);
        when(() => mockBatch.commit()).thenAnswer((_) async {});

        // Act
        final result = await service.createGroupInvite(
          creatorId,
          groupName: groupName,
          description: description,
        );

        // Assert
        expect(result, isA<String>());
        expect(result.length, equals(6)); // 6-character code
        verify(() => mockBatch.set(any(), any())).called(2); // Group + Invite
        verify(() => mockBatch.commit()).called(1);
      });

      test('should handle Firestore errors gracefully', () async {
        // Arrange
        when(() => mockBatch.commit()).thenThrow(Exception('Firestore error'));

        // Act & Assert
        expect(
          () => service.createGroupInvite('test-creator'),
          throwsException,
        );
      });
    });

    group('joinGroupFromCode', () {
      test('should join group successfully with valid invite', () async {
        // Arrange
        const inviteCode = 'ABC123';
        const userId = 'test-user';
        const groupId = 'test-group';

        final inviteData = {
          'groupId': groupId,
          'createdBy': 'creator',
          'usedBy': [],
          'createdAt': Timestamp.now(),
          'maxUses': -1,
          'isActive': true,
        };

        final groupData = {
          'name': 'Test Group',
          'createdBy': 'creator',
          'members': ['creator'],
          'admins': ['creator'],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockInviteSnapshot.exists).thenReturn(true);
        when(() => mockInviteSnapshot.data()).thenReturn(inviteData);
        when(() => mockInviteDoc.get()).thenAnswer((_) async => mockInviteSnapshot);

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        when(() => mockGroupDoc.update(any())).thenAnswer((_) async {});
        when(() => mockInviteDoc.update(any())).thenAnswer((_) async {});

        // Act
        final result = await service.joinGroupFromCode(inviteCode, userId);

        // Assert
        expect(result, isA<UserGroup>());
        expect(result.members, contains(userId));
        verify(() => mockGroupDoc.update(any())).called(1);
        verify(() => mockInviteDoc.update(any())).called(1);
      });

      test('should throw exception for invalid invite code', () async {
        // Arrange
        when(() => mockInviteSnapshot.exists).thenReturn(false);
        when(() => mockInviteDoc.get()).thenAnswer((_) async => mockInviteSnapshot);

        // Act & Assert
        expect(
          () => service.joinGroupFromCode('INVALID', 'test-user'),
          throwsException,
        );
      });

      test('should throw exception for non-existent group', () async {
        // Arrange
        const inviteCode = 'ABC123';
        const userId = 'test-user';

        final inviteData = {
          'groupId': 'non-existent-group',
          'createdBy': 'creator',
          'usedBy': [],
          'createdAt': Timestamp.now(),
          'maxUses': -1,
          'isActive': true,
        };

        when(() => mockInviteSnapshot.exists).thenReturn(true);
        when(() => mockInviteSnapshot.data()).thenReturn(inviteData);
        when(() => mockInviteDoc.get()).thenAnswer((_) async => mockInviteSnapshot);

        when(() => mockGroupSnapshot.exists).thenReturn(false);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act & Assert
        expect(
          () => service.joinGroupFromCode(inviteCode, userId),
          throwsException,
        );
      });
    });

    group('getGroupById', () {
      test('should return group for valid ID', () async {
        // Arrange
        const groupId = 'test-group';
        final groupData = {
          'name': 'Test Group',
          'createdBy': 'creator',
          'members': ['creator'],
          'admins': ['creator'],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        final result = await service.getGroupById(groupId);

        // Assert
        expect(result, isA<UserGroup>());
        expect(result?.id, equals(groupId));
        expect(result?.name, equals('Test Group'));
      });

      test('should return null for non-existent group', () async {
        // Arrange
        when(() => mockGroupSnapshot.exists).thenReturn(false);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        final result = await service.getGroupById('non-existent');

        // Assert
        expect(result, isNull);
      });
    });

    group('getUserGroups', () {
      test('should return user groups successfully', () async {
        // Arrange
        const userId = 'test-user';
        final mockQuerySnapshot = MockQuerySnapshot();
        final mockDoc1 = MockDocumentSnapshot();
        final mockDoc2 = MockDocumentSnapshot();

        final groupData1 = {
          'name': 'Group 1',
          'createdBy': 'creator1',
          'members': [userId],
          'admins': ['creator1'],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        final groupData2 = {
          'name': 'Group 2',
          'createdBy': 'creator2',
          'members': [userId],
          'admins': ['creator2'],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupsCollection.where('members', arrayContains: userId))
            .thenReturn(mockGroupsCollection);
        when(() => mockGroupsCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockGroupsCollection);
        when(() => mockGroupsCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

        when(() => mockQuerySnapshot.docs).thenReturn([mockDoc1, mockDoc2]);
        when(() => mockDoc1.id).thenReturn('group1');
        when(() => mockDoc1.data()).thenReturn(groupData1);
        when(() => mockDoc2.id).thenReturn('group2');
        when(() => mockDoc2.data()).thenReturn(groupData2);

        // Act
        final result = await service.getUserGroups(userId);

        // Assert
        expect(result, isA<List<UserGroup>>());
        expect(result.length, equals(2));
        expect(result[0].name, equals('Group 1'));
        expect(result[1].name, equals('Group 2'));
      });
    });

    group('createGroupShareLink', () {
      test('should create valid share link', () {
        // Arrange
        const groupCode = 'ABC123';

        // Act
        final result = service.createGroupShareLink(groupCode);

        // Assert
        expect(result, equals('https://app-oint.com/group-invite/ABC123'));
      });
    });

    group('updateGroup', () {
      test('should update group successfully', () async {
        // Arrange
        const groupId = 'test-group';
        final updates = {'name': 'Updated Group Name'};

        when(() => mockGroupDoc.update(updates)).thenAnswer((_) async {});

        // Act
        await service.updateGroup(groupId, updates);

        // Assert
        verify(() => mockGroupDoc.update(updates)).called(1);
      });
    });

    group('addGroupAdmin', () {
      test('should add admin successfully', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'new-admin';
        const creatorId = 'creator';

        final groupData = {
          'name': 'Test Group',
          'createdBy': creatorId,
          'members': [creatorId, userId],
          'admins': [creatorId],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);
        when(() => mockGroupDoc.update(any())).thenAnswer((_) async {});

        // Act
        await service.addGroupAdmin(groupId, userId);

        // Assert
        verify(() => mockGroupDoc.update(any())).called(1);
      });

      test('should not add admin if already admin', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'existing-admin';
        const creatorId = 'creator';

        final groupData = {
          'name': 'Test Group',
          'createdBy': creatorId,
          'members': [creatorId, userId],
          'admins': [creatorId, userId],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        await service.addGroupAdmin(groupId, userId);

        // Assert
        verifyNever(() => mockGroupDoc.update(any()));
      });
    });

    group('removeGroupAdmin', () {
      test('should remove admin successfully', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'admin-to-remove';
        const creatorId = 'creator';

        final groupData = {
          'name': 'Test Group',
          'createdBy': creatorId,
          'members': [creatorId, userId],
          'admins': [creatorId, userId],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);
        when(() => mockGroupDoc.update(any())).thenAnswer((_) async {});

        // Act
        await service.removeGroupAdmin(groupId, userId);

        // Assert
        verify(() => mockGroupDoc.update(any())).called(1);
      });

      test('should not remove admin if only one admin', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'only-admin';
        const creatorId = 'creator';

        final groupData = {
          'name': 'Test Group',
          'createdBy': creatorId,
          'members': [creatorId, userId],
          'admins': [userId], // Only one admin
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        await service.removeGroupAdmin(groupId, userId);

        // Assert
        verifyNever(() => mockGroupDoc.update(any()));
      });
    });

    group('leaveGroup', () {
      test('should leave group successfully', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'user-to-leave';
        const creatorId = 'creator';

        final groupData = {
          'name': 'Test Group',
          'createdBy': creatorId,
          'members': [creatorId, userId],
          'admins': [creatorId, userId],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);
        when(() => mockGroupDoc.update(any())).thenAnswer((_) async {});

        // Act
        await service.leaveGroup(groupId, userId);

        // Assert
        verify(() => mockGroupDoc.update(any())).called(1);
      });
    });

    group('deleteGroup', () {
      test('should delete group successfully', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'creator';

        final groupData = {
          'name': 'Test Group',
          'createdBy': userId,
          'members': [userId],
          'admins': [userId],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        final mockInvitesQuerySnapshot = MockQuerySnapshot();
        final mockInviteDocRef = MockDocumentReference();

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        when(() => mockInvitesCollection.where('groupId', isEqualTo: groupId))
            .thenReturn(mockInvitesCollection);
        when(() => mockInvitesCollection.get()).thenAnswer((_) async => mockInvitesQuerySnapshot);
        when(() => mockInvitesQuerySnapshot.docs).thenReturn([mockInviteDocRef]);

        when(() => mockBatch.delete(any())).thenReturn(mockBatch);
        when(() => mockBatch.commit()).thenAnswer((_) async {});

        // Act
        await service.deleteGroup(groupId, userId);

        // Assert
        verify(() => mockBatch.delete(any())).called(2); // Group + Invites
        verify(() => mockBatch.commit()).called(1);
      });

      test('should throw exception if not admin', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'non-admin';
        const creatorId = 'creator';

        final groupData = {
          'name': 'Test Group',
          'createdBy': creatorId,
          'members': [creatorId, userId],
          'admins': [creatorId], // User is not admin
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act & Assert
        expect(
          () => service.deleteGroup(groupId, userId),
          throwsException,
        );
      });
    });

    group('isUserGroupAdmin', () {
      test('should return true for admin', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'admin';

        final groupData = {
          'name': 'Test Group',
          'createdBy': 'creator',
          'members': ['creator', userId],
          'admins': ['creator', userId],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        final result = await service.isUserGroupAdmin(groupId, userId);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for non-admin', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'non-admin';

        final groupData = {
          'name': 'Test Group',
          'createdBy': 'creator',
          'members': ['creator', userId],
          'admins': ['creator'], // User is not admin
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        final result = await service.isUserGroupAdmin(groupId, userId);

        // Assert
        expect(result, isFalse);
      });
    });

    group('isUserGroupMember', () {
      test('should return true for member', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'member';

        final groupData = {
          'name': 'Test Group',
          'createdBy': 'creator',
          'members': ['creator', userId],
          'admins': ['creator'],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        final result = await service.isUserGroupMember(groupId, userId);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for non-member', () async {
        // Arrange
        const groupId = 'test-group';
        const userId = 'non-member';

        final groupData = {
          'name': 'Test Group',
          'createdBy': 'creator',
          'members': ['creator'], // User is not member
          'admins': ['creator'],
          'createdAt': Timestamp.now(),
          'isActive': true,
        };

        when(() => mockGroupSnapshot.exists).thenReturn(true);
        when(() => mockGroupSnapshot.data()).thenReturn(groupData);
        when(() => mockGroupDoc.get()).thenAnswer((_) async => mockGroupSnapshot);

        // Act
        final result = await service.isUserGroupMember(groupId, userId);

        // Assert
        expect(result, isFalse);
      });
    });
  });
}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

