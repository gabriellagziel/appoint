import 'package:cloud_firestore/cloud_firestore.dart';

enum AuditEventType {
  memberJoined,
  memberLeft,
  memberRemoved,
  memberInvited,
  roleChanged,
  policyChanged,
  voteOpened,
  voteClosed,
  voteCancelled,
  meetingCreated,
  meetingShared,
  rsvpSubmitted,
  mediaShared,
  checklistCreated,
  groupDeleted,
}

extension AuditEventTypeExtension on AuditEventType {
  String get displayName {
    switch (this) {
      case AuditEventType.memberJoined:
        return 'Member Joined';
      case AuditEventType.memberLeft:
        return 'Member Left';
      case AuditEventType.memberRemoved:
        return 'Member Removed';
      case AuditEventType.memberInvited:
        return 'Member Invited';
      case AuditEventType.roleChanged:
        return 'Role Changed';
      case AuditEventType.policyChanged:
        return 'Policy Changed';
      case AuditEventType.voteOpened:
        return 'Vote Opened';
      case AuditEventType.voteClosed:
        return 'Vote Closed';
      case AuditEventType.voteCancelled:
        return 'Vote Cancelled';
      case AuditEventType.meetingCreated:
        return 'Meeting Created';
      case AuditEventType.meetingShared:
        return 'Meeting Shared';
      case AuditEventType.rsvpSubmitted:
        return 'RSVP Submitted';
      case AuditEventType.mediaShared:
        return 'Media Shared';
      case AuditEventType.checklistCreated:
        return 'Checklist Created';
      case AuditEventType.groupDeleted:
        return 'Group Deleted';
    }
  }

  String get iconName {
    switch (this) {
      case AuditEventType.memberJoined:
        return 'person_add';
      case AuditEventType.memberLeft:
        return 'person_remove';
      case AuditEventType.memberRemoved:
        return 'person_off';
      case AuditEventType.memberInvited:
        return 'person_add_alt';
      case AuditEventType.roleChanged:
        return 'admin_panel_settings';
      case AuditEventType.policyChanged:
        return 'settings';
      case AuditEventType.voteOpened:
        return 'how_to_vote';
      case AuditEventType.voteClosed:
        return 'vote';
      case AuditEventType.voteCancelled:
        return 'cancel';
      case AuditEventType.meetingCreated:
        return 'event';
      case AuditEventType.meetingShared:
        return 'share';
      case AuditEventType.rsvpSubmitted:
        return 'check_circle';
      case AuditEventType.mediaShared:
        return 'photo';
      case AuditEventType.checklistCreated:
        return 'checklist';
      case AuditEventType.groupDeleted:
        return 'delete';
    }
  }

  String get color {
    switch (this) {
      case AuditEventType.memberJoined:
      case AuditEventType.memberInvited:
      case AuditEventType.roleChanged:
      case AuditEventType.policyChanged:
      case AuditEventType.voteOpened:
      case AuditEventType.meetingCreated:
      case AuditEventType.meetingShared:
      case AuditEventType.rsvpSubmitted:
      case AuditEventType.mediaShared:
      case AuditEventType.checklistCreated:
        return 'green';
      case AuditEventType.memberLeft:
      case AuditEventType.memberRemoved:
      case AuditEventType.voteClosed:
      case AuditEventType.voteCancelled:
        return 'orange';
      case AuditEventType.groupDeleted:
        return 'red';
    }
  }
}

class GroupAuditEvent {
  final String id;
  final String groupId;
  final String actorUserId;
  final AuditEventType type;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;
  final String? targetUserId;
  final String? description;

  const GroupAuditEvent({
    required this.id,
    required this.groupId,
    required this.actorUserId,
    required this.type,
    required this.metadata,
    required this.timestamp,
    this.targetUserId,
    this.description,
  });

  factory GroupAuditEvent.fromMap(String id, Map<String, dynamic> data) {
    return GroupAuditEvent(
      id: id,
      groupId: data['groupId'] ?? '',
      actorUserId: data['actorUserId'] ?? '',
      type: AuditEventType.values.firstWhere(
        (type) => type.name == data['type'],
        orElse: () => AuditEventType.memberJoined,
      ),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      targetUserId: data['targetUserId'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'actorUserId': actorUserId,
      'type': type.name,
      'metadata': metadata,
      'timestamp': Timestamp.fromDate(timestamp),
      'targetUserId': targetUserId,
      'description': description,
    };
  }

  GroupAuditEvent copyWith({
    String? id,
    String? groupId,
    String? actorUserId,
    AuditEventType? type,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
    String? targetUserId,
    String? description,
  }) {
    return GroupAuditEvent(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      actorUserId: actorUserId ?? this.actorUserId,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      targetUserId: targetUserId ?? this.targetUserId,
      description: description ?? this.description,
    );
  }

  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  String get summary {
    switch (type) {
      case AuditEventType.memberJoined:
        return '${metadata['userName'] ?? 'A user'} joined the group';
      case AuditEventType.memberInvited:
        return '${metadata['targetUserName'] ?? 'A user'} was invited by ${metadata['actorUserName'] ?? 'an admin'}';
      case AuditEventType.memberLeft:
        return '${metadata['userName'] ?? 'A user'} left the group';
      case AuditEventType.memberRemoved:
        return '${metadata['targetUserName'] ?? 'A user'} was removed by ${metadata['actorUserName'] ?? 'an admin'}';
      case AuditEventType.roleChanged:
        final oldRole = metadata['oldRole'] ?? 'member';
        final newRole = metadata['newRole'] ?? 'member';
        return '${metadata['targetUserName'] ?? 'A user'}\'s role changed from $oldRole to $newRole';
      case AuditEventType.policyChanged:
        return 'Group policy was updated by ${metadata['actorUserName'] ?? 'an admin'}';
      case AuditEventType.voteOpened:
        return 'Vote opened: ${metadata['voteAction'] ?? 'Unknown action'}';
      case AuditEventType.voteClosed:
        final result = metadata['votePassed'] == true ? 'passed' : 'failed';
        return 'Vote closed: ${metadata['voteAction'] ?? 'Unknown action'} $result';
      case AuditEventType.voteCancelled:
        return 'Vote cancelled: ${metadata['voteAction'] ?? 'Unknown action'}';
      case AuditEventType.meetingCreated:
        return 'Meeting "${metadata['meetingTitle'] ?? 'Untitled'}" was created';
      case AuditEventType.meetingShared:
        return 'Meeting was shared via ${metadata['shareMethod'] ?? 'unknown method'}';
      case AuditEventType.rsvpSubmitted:
        final status = metadata['rsvpStatus'] ?? 'unknown';
        return 'RSVP submitted: $status';
      case AuditEventType.mediaShared:
        return 'Media was shared';
      case AuditEventType.checklistCreated:
        return 'Checklist "${metadata['checklistTitle'] ?? 'Untitled'}" was created';
      case AuditEventType.groupDeleted:
        return 'Group was deleted';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupAuditEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GroupAuditEvent(id: $id, type: $type, timestamp: $timestamp)';
  }
}
