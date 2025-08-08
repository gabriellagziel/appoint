import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appoint/models/group_role.dart';
import 'package:appoint/models/group_policy.dart';
import 'package:appoint/models/group_vote.dart';
import 'package:appoint/models/group_audit_event.dart';

Future<void> main() async {
  // Initialize Firebase for emulator
  await Firebase.initializeApp();

  // Connect to Firestore emulator
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  print('🌱 Seeding Group Admin Test Data...');

  try {
    await _seedGroupAdminData();
    print('✅ Group Admin seed completed successfully!');
  } catch (e) {
    print('❌ Error seeding data: $e');
    rethrow;
  }
}

Future<void> _seedGroupAdminData() async {
  final firestore = FirebaseFirestore.instance;

  // Test group data
  const groupId = 'test-group-admin-123';
  const ownerId = 'userA';
  const adminId = 'userB';
  const memberId = 'userC';

  // 1. Create user groups document
  await firestore.collection('user_groups').doc(groupId).set({
    'name': 'Test Admin Group',
    'description': 'Group for testing admin functionality',
    'ownerId': ownerId,
    'createdAt': FieldValue.serverTimestamp(),
    'memberCount': 3,
    'adminCount': 1,
  });

  // 2. Create members with roles
  final membersRef =
      firestore.collection('groups').doc(groupId).collection('members');

  // Owner
  await membersRef.doc(ownerId).set({
    'role': GroupRole.owner.name,
    'joinedAt': FieldValue.serverTimestamp(),
    'invitedBy': null,
  });

  // Admin
  await membersRef.doc(adminId).set({
    'role': GroupRole.admin.name,
    'joinedAt': FieldValue.serverTimestamp(),
    'invitedBy': ownerId,
  });

  // Member
  await membersRef.doc(memberId).set({
    'role': GroupRole.member.name,
    'joinedAt': FieldValue.serverTimestamp(),
    'invitedBy': ownerId,
  });

  // 3. Create group policy
  final policyRef = firestore
      .collection('groups')
      .doc(groupId)
      .collection('policy')
      .doc('settings');
  await policyRef.set({
    'membersCanInvite': true,
    'requireVoteForAdmin': true,
    'allowNonMembersRSVP': true,
    'lastUpdated': FieldValue.serverTimestamp(),
    'updatedBy': ownerId,
    'version': 1,
  });

  // 4. Create an open vote
  final votesRef =
      firestore.collection('groups').doc(groupId).collection('votes');
  final voteId = 'vote-demote-admin-123';

  await votesRef.doc(voteId).set({
    'groupId': groupId,
    'action': 'demote_admin',
    'targetUserId': adminId,
    'status': 'open',
    'createdAt': FieldValue.serverTimestamp(),
    'closesAt': DateTime.now().add(const Duration(hours: 48)),
    'ballots': {
      ownerId: true, // Owner voted Yes
      memberId: false, // Member voted No
    },
    'yesCount': 1,
    'noCount': 1,
  });

  // 5. Create audit events
  final auditRef =
      firestore.collection('groups').doc(groupId).collection('audit');

  // Member joined event
  await auditRef.add({
    'groupId': groupId,
    'type': AuditEventType.memberJoined.name,
    'actorUserId': memberId,
    'targetUserId': memberId,
    'timestamp': FieldValue.serverTimestamp(),
    'metadata': {
      'invitedBy': ownerId,
    },
  });

  // Vote opened event
  await auditRef.add({
    'groupId': groupId,
    'type': AuditEventType.voteOpened.name,
    'actorUserId': ownerId,
    'targetUserId': adminId,
    'timestamp': FieldValue.serverTimestamp(),
    'metadata': {
      'voteId': voteId,
      'action': 'demote_admin',
    },
  });

  // Role change event (previous admin promotion)
  await auditRef.add({
    'groupId': groupId,
    'type': AuditEventType.roleChanged.name,
    'actorUserId': ownerId,
    'targetUserId': adminId,
    'timestamp': FieldValue.serverTimestamp(),
    'metadata': {
      'oldRole': GroupRole.member.name,
      'newRole': GroupRole.admin.name,
    },
  });

  // Policy change event
  await auditRef.add({
    'groupId': groupId,
    'type': AuditEventType.policyChanged.name,
    'actorUserId': ownerId,
    'timestamp': FieldValue.serverTimestamp(),
    'metadata': {
      'changedFields': ['membersCanInvite', 'requireVoteForAdmin'],
      'oldValues': {
        'membersCanInvite': false,
        'requireVoteForAdmin': false,
      },
      'newValues': {
        'membersCanInvite': true,
        'requireVoteForAdmin': true,
      },
    },
  });

  print('📊 Created test data:');
  print('   - Group: $groupId');
  print('   - Owner: $ownerId');
  print('   - Admin: $adminId');
  print('   - Member: $memberId');
  print('   - Open vote: $voteId');
  print('   - 4 audit events');
  print('   - Policy with voting required');

  print('\n🎯 Test scenarios available:');
  print('   - Owner can promote/demote admins');
  print('   - Admin can remove members (not admins)');
  print('   - Policy requires voting for admin changes');
  print('   - Vote in progress with ballots');
  print('   - Audit trail for all actions');
}
