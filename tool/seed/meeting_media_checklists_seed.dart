import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appoint/models/meeting_media.dart';
import 'package:appoint/models/meeting_checklist.dart';

Future<void> main() async {
  await Firebase.initializeApp();
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  await _seedMeetingMediaChecklistsData();
}

Future<void> _seedMeetingMediaChecklistsData() async {
  final firestore = FirebaseFirestore.instance;

  // Create test meeting
  const meetingId = 'REDACTED_TOKEN';
  const groupId = 'test-group-123';

  // Create meeting document
  await firestore.collection('meetings').doc(meetingId).set({
    'title': 'Test Meeting with Media & Checklists',
    'groupId': groupId,
    'startTime':
        Timestamp.fromDate(DateTime.now().add(const Duration(days: 1))),
    'endTime': Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 1, hours: 2))),
    'createdBy': 'test-user-1',
    'createdAt': Timestamp.now(),
    'groupMemberIds': ['test-user-1', 'test-user-2', 'test-user-3'],
  });

  // Create test media files
  final mediaFiles = [
    {
      'id': 'media-1',
      'meetingId': meetingId,
      'groupId': groupId,
      'uploaderId': 'test-user-1',
      'fileName': 'presentation.pdf',
      'mimeType': 'application/pdf',
      'sizeBytes': 2048576, // 2MB
      'storagePath': 'meetings/$meetingId/media/presentation.pdf',
      'url': 'https://example.com/presentation.pdf',
      'uploadedAt': Timestamp.now(),
      'visibility': 'group',
      'allowedRoles': ['owner', 'admin', 'member'],
      'checksum': 'abc123def456',
      'notes': 'Main presentation for the meeting',
    },
    {
      'id': 'media-2',
      'meetingId': meetingId,
      'groupId': groupId,
      'uploaderId': 'test-user-2',
      'fileName': 'meeting-photo.jpg',
      'mimeType': 'image/jpeg',
      'sizeBytes': 512000, // 512KB
      'storagePath': 'meetings/$meetingId/media/meeting-photo.jpg',
      'url': 'https://example.com/meeting-photo.jpg',
      'uploadedAt': Timestamp.now(),
      'visibility': 'public',
      'allowedRoles': ['owner', 'admin', 'member'],
      'checksum': 'def456ghi789',
      'notes': 'Group photo from last meeting',
    },
    {
      'id': 'media-3',
      'meetingId': meetingId,
      'groupId': groupId,
      'uploaderId': 'test-user-1',
      'fileName': 'agenda.docx',
      'mimeType':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'sizeBytes': 102400, // 100KB
      'storagePath': 'meetings/$meetingId/media/agenda.docx',
      'url': 'https://example.com/agenda.docx',
      'uploadedAt': Timestamp.now(),
      'visibility': 'group',
      'allowedRoles': ['owner', 'admin', 'member'],
      'checksum': 'ghi789jkl012',
      'notes': 'Meeting agenda and topics',
    },
  ];

  for (final media in mediaFiles) {
    await firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('media')
        .doc(media['id'] as String)
        .set(media);
  }

  // Create test checklists
  final checklists = [
    {
      'id': 'checklist-1',
      'meetingId': meetingId,
      'groupId': groupId,
      'title': 'Event Preparation',
      'createdBy': 'test-user-1',
      'createdAt': Timestamp.now(),
      'isArchived': false,
    },
    {
      'id': 'checklist-2',
      'meetingId': meetingId,
      'groupId': groupId,
      'title': 'Follow-up Tasks',
      'createdBy': 'test-user-2',
      'createdAt': Timestamp.now(),
      'isArchived': false,
    },
  ];

  for (final checklist in checklists) {
    await firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('checklists')
        .doc(checklist['id'] as String)
        .set(checklist);
  }

  // Create test checklist items
  final checklistItems = [
    // Event Preparation items
    {
      'id': 'item-1',
      'listId': 'checklist-1',
      'text': 'Book meeting room',
      'createdBy': 'test-user-1',
      'assigneeId': 'test-user-1',
      'dueAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 1))),
      'priority': 'high',
      'isDone': true,
      'doneBy': 'test-user-1',
      'doneAt': Timestamp.now(),
      'orderIndex': 0,
    },
    {
      'id': 'item-2',
      'listId': 'checklist-1',
      'text': 'Prepare presentation slides',
      'createdBy': 'test-user-1',
      'assigneeId': 'test-user-2',
      'dueAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 2))),
      'priority': 'high',
      'isDone': false,
      'orderIndex': 1,
    },
    {
      'id': 'item-3',
      'listId': 'checklist-1',
      'text': 'Send meeting invitations',
      'createdBy': 'test-user-1',
      'assigneeId': null,
      'dueAt':
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      'priority': 'medium',
      'isDone': false,
      'orderIndex': 2,
    },
    {
      'id': 'item-4',
      'listId': 'checklist-1',
      'text': 'Order refreshments',
      'createdBy': 'test-user-2',
      'assigneeId': 'test-user-3',
      'dueAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 6))),
      'priority': 'low',
      'isDone': false,
      'orderIndex': 3,
    },
    {
      'id': 'item-5',
      'listId': 'checklist-1',
      'text': 'Test video equipment',
      'createdBy': 'test-user-1',
      'assigneeId': 'test-user-1',
      'dueAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 1))),
      'priority': 'medium',
      'isDone': false,
      'orderIndex': 4,
    },

    // Follow-up Tasks items
    {
      'id': 'item-6',
      'listId': 'checklist-2',
      'text': 'Send meeting minutes',
      'createdBy': 'test-user-2',
      'assigneeId': 'test-user-2',
      'dueAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 2))),
      'priority': 'high',
      'isDone': false,
      'orderIndex': 0,
    },
    {
      'id': 'item-7',
      'listId': 'checklist-2',
      'text': 'Schedule follow-up meeting',
      'createdBy': 'test-user-2',
      'assigneeId': 'test-user-1',
      'dueAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
      'priority': 'medium',
      'isDone': false,
      'orderIndex': 1,
    },
    {
      'id': 'item-8',
      'listId': 'checklist-2',
      'text': 'Update project timeline',
      'createdBy': 'test-user-3',
      'assigneeId': null,
      'dueAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 3))),
      'priority': 'low',
      'isDone': false,
      'orderIndex': 2,
    },
  ];

  for (final item in checklistItems) {
    await firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('checklists')
        .doc(item['listId'] as String)
        .collection('items')
        .doc(item['id'] as String)
        .set(item);
  }

  print('✅ Meeting Media & Checklists seed data created successfully!');
  print('');
  print('📋 Test Data Summary:');
  print('  Meeting ID: $meetingId');
  print('  Group ID: $groupId');
  print('  Media Files: ${mediaFiles.length}');
  print('  Checklists: ${checklists.length}');
  print('  Checklist Items: ${checklistItems.length}');
  print('');
  print('🎯 Test Scenarios:');
  print('  • 1 overdue item (item-3)');
  print('  • 1 done item (item-1)');
  print('  • 2 high priority items (item-1, item-2)');
  print('  • 2 assigned items (item-2, item-4)');
  print('  • 1 public media file (media-2)');
  print('  • 2 group-only media files (media-1, media-3)');
  print('');
  print('🚀 Ready for testing!');
}
