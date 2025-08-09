import 'package:cloud_firestore/cloud_firestore.dart';

/// AUDIT: Migration script to link existing meetings to groups and set visibility
/// This script backfills groupId and visibility settings for meetings created via group share
class MeetingGroupLinkMigration {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Run the migration to link meetings to groups
  Future<void> runMigration() async {
    print('Starting meeting-group link migration...');

    final batch = _firestore.batch();
    int updatedCount = 0;
    int skippedCount = 0;
    int errorCount = 0;

    try {
      // Get all meetings that don't have groupId set
      final query = await _firestore
          .collection('meetings')
          .where('groupId', isNull: true)
          .get();

      print('Found ${query.docs.length} meetings without groupId');

      for (final doc in query.docs) {
        final meetingData = doc.data();
        final meetingId = doc.id;

        try {
          // Check if meeting was created via group share (check analytics)
          final groupId = await _findGroupIdFromAnalytics(meetingId);

          if (groupId != null) {
            // Update meeting with groupId and default visibility
            batch.update(doc.reference, {
              'groupId': groupId,
              'visibility': {
                'groupMembersOnly': true,
                'allowGuestsRSVP': true,
              },
              'updatedAt': FieldValue.serverTimestamp(),
            });
            updatedCount++;
            print('Updated meeting $meetingId with groupId: $groupId');
          } else {
            // Set default visibility for meetings without group association
            batch.update(doc.reference, {
              'visibility': {
                'groupMembersOnly': false,
                'allowGuestsRSVP': true,
              },
              'updatedAt': FieldValue.serverTimestamp(),
            });
            skippedCount++;
            print(
                'Set default visibility for meeting $meetingId (no group found)');
          }
        } catch (e) {
          errorCount++;
          print('Error processing meeting $meetingId: $e');
        }
      }

      // Commit the batch
      await batch.commit();

      print('\nMigration completed:');
      print('- Updated: $updatedCount meetings');
      print('- Skipped: $skippedCount meetings');
      print('- Errors: $errorCount meetings');
    } catch (e) {
      print('Migration failed: $e');
      rethrow;
    }
  }

  /// Find groupId from analytics data
  Future<String?> _findGroupIdFromAnalytics(String meetingId) async {
    try {
      // Check for share link creation events
      final shareEvents = await _firestore
          .collection('analytics')
          .where('event', isEqualTo: 'share_link_created')
          .where('meetingId', isEqualTo: meetingId)
          .get();

      for (final event in shareEvents.docs) {
        final data = event.data();
        if (data['groupId'] != null) {
          return data['groupId'] as String;
        }
      }

      // Check for group member joined events
      final joinEvents = await _firestore
          .collection('analytics')
          .where('event', isEqualTo: 'group_member_joined_from_share')
          .where('meetingId', isEqualTo: meetingId)
          .get();

      for (final event in joinEvents.docs) {
        final data = event.data();
        if (data['groupId'] != null) {
          return data['groupId'] as String;
        }
      }

      return null;
    } catch (e) {
      print('Error finding groupId from analytics: $e');
      return null;
    }
  }

  /// Validate migration results
  Future<void> validateMigration() async {
    print('\nValidating migration results...');

    final totalMeetings = await _firestore.collection('meetings').count().get();
    final meetingsWithGroup = await _firestore
        .collection('meetings')
        .where('groupId', isNull: false)
        .count()
        .get();
    final meetingsWithVisibility = await _firestore
        .collection('meetings')
        .where('visibility', isNull: false)
        .count()
        .get();

    print('Total meetings: ${totalMeetings.count}');
    print('Meetings with groupId: ${meetingsWithGroup.count}');
    print('Meetings with visibility: ${meetingsWithVisibility.count}');

    if (meetingsWithVisibility.count == totalMeetings.count) {
      print('✅ All meetings have visibility settings');
    } else {
      print('❌ Some meetings missing visibility settings');
    }
  }
}

/// Main function to run the migration
void main() async {
  final migration = MeetingGroupLinkMigration();

  try {
    await migration.runMigration();
    await migration.validateMigration();
    print('\n✅ Migration completed successfully');
  } catch (e) {
    print('\n❌ Migration failed: $e');
    exit(1);
  }
}
