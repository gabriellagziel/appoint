import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/meeting_share_service.dart';

class MeetingShareAnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Log share link created event
  Future<void> logShareLinkCreated({
    required String meetingId,
    required String groupId,
    required ShareSource source,
    required String shareUrl,
    String? userId,
  }) async {
    try {
      await _firestore.collection('analytics_share_events').add({
        'event': 'share_link_created',
        'meetingId': meetingId,
        'groupId': groupId,
        'source': source.name,
        'shareUrl': shareUrl,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': source.name,
      });
    } catch (e) {
      print('Error logging share link created: $e');
    }
  }

  /// Log share link clicked event
  Future<void> logShareLinkClicked({
    required String meetingId,
    required String groupId,
    required ShareSource source,
    required String shareUrl,
    String? userId,
    String? ipHash,
    String? userAgent,
  }) async {
    try {
      await _firestore.collection('analytics_share_events').add({
        'event': 'share_link_clicked',
        'meetingId': meetingId,
        'groupId': groupId,
        'source': source.name,
        'shareUrl': shareUrl,
        'userId': userId,
        'ipHash': ipHash,
        'userAgent': userAgent,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': source.name,
      });
    } catch (e) {
      print('Error logging share link clicked: $e');
    }
  }

  /// Log group member joined from share
  Future<void> logGroupMemberJoinedFromShare({
    required String meetingId,
    required String groupId,
    required String userId,
    required ShareSource source,
  }) async {
    try {
      await _firestore.collection('analytics_share_events').add({
        'event': 'group_member_joined_from_share',
        'meetingId': meetingId,
        'groupId': groupId,
        'userId': userId,
        'source': source.name,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': source.name,
      });
    } catch (e) {
      print('Error logging group member joined: $e');
    }
  }

  /// Log RSVP submitted from share
  Future<void> logRSVPSubmittedFromShare({
    required String meetingId,
    required String groupId,
    required String userId,
    required String rsvpStatus,
    required ShareSource source,
    bool isGuest = false,
  }) async {
    try {
      await _firestore.collection('analytics_share_events').add({
        'event': 'rsvp_submitted_from_share',
        'meetingId': meetingId,
        'groupId': groupId,
        'userId': userId,
        'rsvpStatus': rsvpStatus,
        'source': source.name,
        'isGuest': isGuest,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': source.name,
      });
    } catch (e) {
      print('Error logging RSVP submitted: $e');
    }
  }

  /// Get analytics summary for a meeting
  Future<Map<String, dynamic>> getMeetingAnalytics(String meetingId) async {
    try {
      final eventsSnapshot = await _firestore
          .collection('analytics_share_events')
          .where('meetingId', isEqualTo: meetingId)
          .get();

      final events = eventsSnapshot.docs.map((doc) => doc.data()).toList();

      final summary = {
        'totalShares': 0,
        'totalClicks': 0,
        'totalJoins': 0,
        'totalRSVPs': 0,
        'sources': <String, Map<String, int>>{},
        'conversionRate': 0.0,
        'clickThroughRate': 0.0,
      };

      for (final event in events) {
        final eventType = event['event'] as String;
        final source = event['source'] as String;

        // Initialize source stats if not exists
        if (!summary['sources'].containsKey(source)) {
          summary['sources'][source] = {
            'shares': 0,
            'clicks': 0,
            'joins': 0,
            'rsvps': 0,
          };
        }

        switch (eventType) {
          case 'share_link_created':
            summary['totalShares'] = (summary['totalShares'] as int) + 1;
            summary['sources'][source]['shares'] =
                (summary['sources'][source]['shares'] as int) + 1;
            break;
          case 'share_link_clicked':
            summary['totalClicks'] = (summary['totalClicks'] as int) + 1;
            summary['sources'][source]['clicks'] =
                (summary['sources'][source]['clicks'] as int) + 1;
            break;
          case 'group_member_joined_from_share':
            summary['totalJoins'] = (summary['totalJoins'] as int) + 1;
            summary['sources'][source]['joins'] =
                (summary['sources'][source]['joins'] as int) + 1;
            break;
          case 'rsvp_submitted_from_share':
            summary['totalRSVPs'] = (summary['totalRSVPs'] as int) + 1;
            summary['sources'][source]['rsvps'] =
                (summary['sources'][source]['rsvps'] as int) + 1;
            break;
        }
      }

      // Calculate rates
      if (summary['totalShares'] > 0) {
        summary['clickThroughRate'] =
            (summary['totalClicks'] as int) / (summary['totalShares'] as int);
      }

      if (summary['totalClicks'] > 0) {
        summary['conversionRate'] =
            ((summary['totalJoins'] as int) + (summary['totalRSVPs'] as int)) /
                (summary['totalClicks'] as int);
      }

      return summary;
    } catch (e) {
      print('Error getting meeting analytics: $e');
      return {};
    }
  }

  /// Get analytics summary for a group
  Future<Map<String, dynamic>> getGroupAnalytics(String groupId) async {
    try {
      final eventsSnapshot = await _firestore
          .collection('analytics_share_events')
          .where('groupId', isEqualTo: groupId)
          .get();

      final events = eventsSnapshot.docs.map((doc) => doc.data()).toList();

      final summary = {
        'totalShares': 0,
        'totalClicks': 0,
        'totalJoins': 0,
        'totalRSVPs': 0,
        'meetings': <String, int>{},
        'sources': <String, Map<String, int>>{},
      };

      for (final event in events) {
        final eventType = event['event'] as String;
        final source = event['source'] as String;
        final meetingId = event['meetingId'] as String;

        // Count meetings
        summary['meetings'][meetingId] =
            (summary['meetings'][meetingId] ?? 0) + 1;

        // Initialize source stats if not exists
        if (!summary['sources'].containsKey(source)) {
          summary['sources'][source] = {
            'shares': 0,
            'clicks': 0,
            'joins': 0,
            'rsvps': 0,
          };
        }

        switch (eventType) {
          case 'share_link_created':
            summary['totalShares'] = (summary['totalShares'] as int) + 1;
            summary['sources'][source]['shares'] =
                (summary['sources'][source]['shares'] as int) + 1;
            break;
          case 'share_link_clicked':
            summary['totalClicks'] = (summary['totalClicks'] as int) + 1;
            summary['sources'][source]['clicks'] =
                (summary['sources'][source]['clicks'] as int) + 1;
            break;
          case 'group_member_joined_from_share':
            summary['totalJoins'] = (summary['totalJoins'] as int) + 1;
            summary['sources'][source]['joins'] =
                (summary['sources'][source]['joins'] as int) + 1;
            break;
          case 'rsvp_submitted_from_share':
            summary['totalRSVPs'] = (summary['totalRSVPs'] as int) + 1;
            summary['sources'][source]['rsvps'] =
                (summary['sources'][source]['rsvps'] as int) + 1;
            break;
        }
      }

      return summary;
    } catch (e) {
      print('Error getting group analytics: $e');
      return {};
    }
  }

  /// Get top performing sources
  Future<List<Map<String, dynamic>>> getTopPerformingSources(
      String groupId) async {
    try {
      final analytics = await getGroupAnalytics(groupId);
      final sources = analytics['sources'] as Map<String, Map<String, int>>;

      final sourceStats = sources.entries.map((entry) {
        final source = entry.key;
        final stats = entry.value;
        final clicks = stats['clicks'] ?? 0;
        final shares = stats['shares'] ?? 0;
        final ctr = shares > 0 ? clicks / shares : 0.0;

        return {
          'source': source,
          'shares': shares,
          'clicks': clicks,
          'joins': stats['joins'] ?? 0,
          'rsvps': stats['rsvps'] ?? 0,
          'ctr': ctr,
        };
      }).toList();

      // Sort by CTR descending
      sourceStats
          .sort((a, b) => (b['ctr'] as double).compareTo(a['ctr'] as double));

      return sourceStats;
    } catch (e) {
      print('Error getting top performing sources: $e');
      return [];
    }
  }

  /// Get conversion funnel for a meeting
  Future<Map<String, dynamic>> getConversionFunnel(String meetingId) async {
    try {
      final analytics = await getMeetingAnalytics(meetingId);

      final shares = analytics['totalShares'] ?? 0;
      final clicks = analytics['totalClicks'] ?? 0;
      final joins = analytics['totalJoins'] ?? 0;
      final rsvps = analytics['totalRSVPs'] ?? 0;

      return {
        'shares': shares,
        'clicks': clicks,
        'joins': joins,
        'rsvps': rsvps,
        'clickRate': shares > 0 ? (clicks / shares) * 100 : 0,
        'conversionRate': clicks > 0 ? ((joins + rsvps) / clicks) * 100 : 0,
        'joinRate': clicks > 0 ? (joins / clicks) * 100 : 0,
        'rsvpRate': clicks > 0 ? (rsvps / clicks) * 100 : 0,
      };
    } catch (e) {
      print('Error getting conversion funnel: $e');
      return {};
    }
  }
}

// Riverpod providers
final meetingShareAnalyticsServiceProvider =
    Provider<MeetingShareAnalyticsService>((ref) {
  return MeetingShareAnalyticsService();
});

final meetingAnalyticsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, meetingId) async {
  final service = ref.read(meetingShareAnalyticsServiceProvider);
  return await service.getMeetingAnalytics(meetingId);
});

final groupAnalyticsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final service = ref.read(meetingShareAnalyticsServiceProvider);
  return await service.getGroupAnalytics(groupId);
});

final topPerformingSourcesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, groupId) async {
  final service = ref.read(meetingShareAnalyticsServiceProvider);
  return await service.getTopPerformingSources(groupId);
});

final conversionFunnelProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, meetingId) async {
  final service = ref.read(meetingShareAnalyticsServiceProvider);
  return await service.getConversionFunnel(meetingId);
});


