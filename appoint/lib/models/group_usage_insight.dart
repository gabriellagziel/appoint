import 'package:cloud_firestore/cloud_firestore.dart';

enum GroupUsageEvent {
  share,
  click,
  rsvpAccept,
  rsvpDecline,
  createdWithGroup,
}

extension GroupUsageEventExtension on GroupUsageEvent {
  String get displayName {
    switch (this) {
      case GroupUsageEvent.share:
        return 'Share';
      case GroupUsageEvent.click:
        return 'Click';
      case GroupUsageEvent.rsvpAccept:
        return 'RSVP Accept';
      case GroupUsageEvent.rsvpDecline:
        return 'RSVP Decline';
      case GroupUsageEvent.createdWithGroup:
        return 'Created with Group';
    }
  }
}

class GroupUsageInsight {
  final String userId;
  final String groupId;
  final String? meetingId;
  final GroupUsageEvent event;
  final String? source;
  final DateTime timestamp;

  const GroupUsageInsight({
    required this.userId,
    required this.groupId,
    this.meetingId,
    required this.event,
    this.source,
    required this.timestamp,
  });

  factory GroupUsageInsight.fromMap(String id, Map<String, dynamic> data) {
    return GroupUsageInsight(
      userId: data['userId'] ?? '',
      groupId: data['groupId'] ?? '',
      meetingId: data['meetingId'],
      event: GroupUsageEvent.values.firstWhere(
        (e) => e.name == data['event'],
        orElse: () => GroupUsageEvent.click,
      ),
      source: data['source'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'groupId': groupId,
      'meetingId': meetingId,
      'event': event.name,
      'source': source,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  @override
  String toString() {
    return 'GroupUsageInsight(userId: $userId, groupId: $groupId, event: $event, source: $source)';
  }
}

class GroupInsightSummary {
  final String groupId;
  final int totalEvents;
  final int shareCount;
  final int clickCount;
  final int rsvpAcceptCount;
  final int rsvpDeclineCount;
  final int createdWithGroupCount;
  final DateTime lastEventAt;

  const GroupInsightSummary({
    required this.groupId,
    required this.totalEvents,
    required this.shareCount,
    required this.clickCount,
    required this.rsvpAcceptCount,
    required this.rsvpDeclineCount,
    required this.createdWithGroupCount,
    required this.lastEventAt,
  });

  double get conversionRate {
    final totalClicks = clickCount + shareCount;
    if (totalClicks == 0) return 0.3; // Default conversion rate
    return rsvpAcceptCount / totalClicks;
  }

  int get totalClicks => clickCount + shareCount;
  int get totalRSVPs => rsvpAcceptCount + rsvpDeclineCount;

  static double calculateConversionRate(int rsvpAccepts, int clicks) {
    if (clicks == 0) return 0.3; // Default conversion rate
    return rsvpAccepts / clicks;
  }

  @override
  String toString() {
    return 'GroupInsightSummary(groupId: $groupId, totalEvents: $totalEvents, conversionRate: ${conversionRate.toStringAsFixed(2)})';
  }
}
