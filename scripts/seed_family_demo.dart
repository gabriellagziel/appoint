import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Demo family seed script
// Run with: dart run scripts/seed_family_demo.dart

Future<void> main() async {
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;

  print('🌱 Seeding demo family data...');

  // Create demo users
  final parentId = 'demo-parent-${DateTime.now().millisecondsSinceEpoch}';
  final childId = 'demo-child-${DateTime.now().millisecondsSinceEpoch}';
  final familyId = 'demo-family-${DateTime.now().millisecondsSinceEpoch}';

  // Create parent user
  await firestore.collection('users').doc(parentId).set({
    'displayName': 'Demo Parent',
    'email': 'parent@demo.com',
    'isChildAccount': false,
    'createdAt': FieldValue.serverTimestamp(),
  });

  // Create child user
  await firestore.collection('users').doc(childId).set({
    'displayName': 'Demo Child',
    'email': 'child@demo.com',
    'isChildAccount': true,
    'createdAt': FieldValue.serverTimestamp(),
  });

  // Create family relationship
  await firestore.collection('families').doc(familyId).set({
    'parentId': parentId,
    'children': [childId],
    'createdAt': FieldValue.serverTimestamp(),
  });

  // Create family link
  await firestore.collection('family_invitations').add({
    'parentId': parentId,
    'childId': childId,
    'status': 'active',
    'invitedAt': FieldValue.serverTimestamp(),
    'consentedAt': FieldValue.serverTimestamp(),
  });

  // Create demo calendar items
  final now = DateTime.now();
  final tomorrow = now.add(const Duration(days: 1));
  final nextWeek = now.add(const Duration(days: 7));

  // Meeting 1: Parent's meeting
  await firestore.collection('calendar_items').add({
    'title': 'Parent Work Meeting',
    'description': 'Important work discussion',
    'startAt': Timestamp.fromDate(tomorrow.add(const Duration(hours: 9))),
    'endAt': Timestamp.fromDate(tomorrow.add(const Duration(hours: 10))),
    'type': 'meeting',
    'ownerId': parentId,
    'assigneeId': null,
    'familyId': familyId,
    'visibility': 'family',
    'createdAt': FieldValue.serverTimestamp(),
  });

  // Meeting 2: Child's activity (assigned by parent)
  await firestore.collection('calendar_items').add({
    'title': 'Child Soccer Practice',
    'description': 'Weekly soccer practice',
    'startAt': Timestamp.fromDate(tomorrow.add(const Duration(hours: 15))),
    'endAt': Timestamp.fromDate(
        tomorrow.add(const Duration(hours: 16, minutes: 30))),
    'type': 'meeting',
    'ownerId': parentId,
    'assigneeId': childId,
    'familyId': familyId,
    'visibility': 'family',
    'createdAt': FieldValue.serverTimestamp(),
  });

  // Reminder 1: Parent's personal reminder
  await firestore.collection('reminders').add({
    'title': 'Pay Bills',
    'description': 'Monthly utility bills',
    'scheduledAt': Timestamp.fromDate(tomorrow.add(const Duration(hours: 14))),
    'ownerId': parentId,
    'assigneeId': null,
    'familyId': familyId,
    'type': 'personal',
    'recurrence': 'monthly',
    'isCompleted': false,
    'visibility': 'private',
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // Reminder 2: Child's homework (assigned by parent)
  await firestore.collection('reminders').add({
    'title': 'Math Homework',
    'description': 'Complete chapter 5 exercises',
    'scheduledAt': Timestamp.fromDate(tomorrow.add(const Duration(hours: 17))),
    'ownerId': parentId,
    'assigneeId': childId,
    'familyId': familyId,
    'type': 'task',
    'recurrence': 'none',
    'isCompleted': false,
    'visibility': 'family',
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // Reminder 3: Child's own reminder
  await firestore.collection('reminders').add({
    'title': 'Call Friend',
    'description': 'Call Sarah about weekend plans',
    'scheduledAt': Timestamp.fromDate(nextWeek.add(const Duration(hours: 16))),
    'ownerId': childId,
    'assigneeId': childId,
    'familyId': familyId,
    'type': 'personal',
    'recurrence': 'none',
    'isCompleted': false,
    'visibility': 'private',
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // Create a conflict: overlapping events for child
  await firestore.collection('calendar_items').add({
    'title': 'Child Music Lesson',
    'description': 'Piano lesson',
    'startAt': Timestamp.fromDate(
        tomorrow.add(const Duration(hours: 15, minutes: 30))),
    'endAt': Timestamp.fromDate(
        tomorrow.add(const Duration(hours: 16, minutes: 30))),
    'type': 'meeting',
    'ownerId': parentId,
    'assigneeId': childId,
    'familyId': familyId,
    'visibility': 'family',
    'createdAt': FieldValue.serverTimestamp(),
  });

  print('✅ Demo data created successfully!');
  print('📊 Summary:');
  print('  - Parent ID: $parentId');
  print('  - Child ID: $childId');
  print('  - Family ID: $familyId');
  print('  - 3 calendar items (2 meetings, 1 conflict)');
  print('  - 3 reminders (parent personal, child homework, child personal)');
  print('  - 1 family relationship (active)');
  print('');
  print('🔗 Test URLs:');
  print('  - Family Dashboard: /dashboard/family');
  print('  - Family Calendar: /family/calendar');
  print('');
  print('💡 Update the user IDs in the providers to use:');
  print('  - Parent: $parentId');
  print('  - Child: $childId');
}
