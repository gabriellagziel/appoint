import 'package:cloud_firestore/cloud_firestore.dart';

/// AUDIT: Migration script to link existing meetings to groups
/// This script updates meetings that were created via group sharing
/// to have proper groupId and visibility settings
class MeetingGroupMigration {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Run the migration to link meetings to groups
  Future<void> runMigration() async {
    print('Starting meeting-group migration...');

    int updatedCount = 0;
    int errorCount = 0;

    try {
      // Get all meetings that might need group association
      final meetingsQuery = await _firestore
          .collection('meetings')
          .where('meetingType', isEqualTo: 'event')
          .get();

      print('Found ${meetingsQuery.docs.length} event meetings to check');

      for (final meetingDoc in meetingsQuery.docs) {
        try {
          final meetingData = meetingDoc.data();
          final meetingId = meetingDoc.id;

          // Check if meeting already has groupId
          if (meetingData['groupId'] != null) {
            print(
                'Meeting $meetingId already has groupId: ${meetingData['groupId']}');
            continue;
          }

          // Check if meeting has old groupChatId field
          final oldGroupChatId = meetingData['groupChatId'];
          if (oldGroupChatId != null) {
            print(
                'Found meeting $meetingId with old groupChatId: $oldGroupChatId');

            // Update to use new groupId field
            await meetingDoc.reference.update({
              'groupId': oldGroupChatId,
              'groupChatId': FieldValue.delete(), // Remove old field
              'visibility': {
                'groupMembersOnly': true,
                'allowGuestsRSVP': true,
              },
              'updatedAt': FieldValue.serverTimestamp(),
            });

            updatedCount++;
            print('Updated meeting $meetingId with groupId: $oldGroupChatId');
          }

          // Check analytics for share link creation events
          final analyticsQuery = await _firestore
              .collection('analytics')
              .where('event', isEqualTo: 'share_link_created')
              .where('meetingId', isEqualTo: meetingId)
              .limit(1)
              .get();

          if (analyticsQuery.docs.isNotEmpty) {
            final analyticsData = analyticsQuery.docs.first.data();
            final groupId = analyticsData['groupId'];

            if (groupId != null && meetingData['groupId'] == null) {
              print(
                  'Found meeting $meetingId with share analytics, groupId: $groupId');

              // Update meeting with groupId from analytics
              await meetingDoc.reference.update({
                'groupId': groupId,
                'visibility': {
                  'groupMembersOnly': true,
                  'allowGuestsRSVP': true,
                },
                'updatedAt': FieldValue.serverTimestamp(),
              });

              updatedCount++;
              print(
                  'Updated meeting $meetingId with groupId from analytics: $groupId');
            }
          }
        } catch (e) {
          errorCount++;
          print('Error processing meeting ${meetingDoc.id}: $e');
        }
      }

      print('Migration completed:');
      print('- Updated meetings: $updatedCount');
      print('- Errors: $errorCount');
    } catch (e) {
      print('Migration failed: $e');
      rethrow;
    }
  }

  /// Rollback the migration (if needed)
  Future<void> rollback() async {
    print('Rolling back meeting-group migration...');

    int rollbackCount = 0;

    try {
      final meetingsQuery = await _firestore
          .collection('meetings')
          .where('groupId', isNull: false)
          .get();

      for (final meetingDoc in meetingsQuery.docs) {
        try {
          final meetingData = meetingDoc.data();
          final groupId = meetingData['groupId'];

          // Restore old field and remove new ones
          await meetingDoc.reference.update({
            'groupChatId': groupId,
            'groupId': FieldValue.delete(),
            'visibility': FieldValue.delete(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          rollbackCount++;
          print('Rolled back meeting ${meetingDoc.id}');
        } catch (e) {
          print('Error rolling back meeting ${meetingDoc.id}: $e');
        }
      }

      print('Rollback completed: $rollbackCount meetings rolled back');
    } catch (e) {
      print('Rollback failed: $e');
      rethrow;
    }
  }

  /// Generate a summary report of the migration
  Future<void> generateReport() async {
    print('Generating migration report...');

    try {
      final totalMeetings =
          await _firestore.collection('meetings').count().get();
      final groupMeetings = await _firestore
          .collection('meetings')
          .where('groupId', isNull: false)
          .count()
          .get();

      final oldGroupMeetings = await _firestore
          .collection('meetings')
          .where('groupChatId', isNull: false)
          .count()
          .get();

      print('Migration Report:');
      print('- Total meetings: ${totalMeetings.count}');
      print('- Meetings with groupId: ${groupMeetings.count}');
      print('- Meetings with old groupChatId: ${oldGroupMeetings.count}');
    } catch (e) {
      print('Error generating report: $e');
    }
  }
}

/// Main function to run the migration
Future<void> main() async {
  final migration = MeetingGroupMigration();

  // Uncomment the line you want to run:

  // Run the migration
  await migration.runMigration();

  // Generate a report
  // await migration.generateReport();

  // Rollback (if needed)
  // await migration.rollback();
}
