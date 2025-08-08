import 'package:cloud_firestore/cloud_firestore.dart';

enum VoteAction {
  promoteAdmin,
  demoteAdmin,
  transferOwnership,
  removeMember,
  changePolicy,
}

enum VoteStatus {
  open,
  closed,
  cancelled,
}

extension VoteActionExtension on VoteAction {
  String get displayName {
    switch (this) {
      case VoteAction.promoteAdmin:
        return 'Promote to Admin';
      case VoteAction.demoteAdmin:
        return 'Demote Admin';
      case VoteAction.transferOwnership:
        return 'Transfer Ownership';
      case VoteAction.removeMember:
        return 'Remove Member';
      case VoteAction.changePolicy:
        return 'Change Policy';
    }
  }

  String get description {
    switch (this) {
      case VoteAction.promoteAdmin:
        return 'Promote a member to admin role';
      case VoteAction.demoteAdmin:
        return 'Demote an admin to member role';
      case VoteAction.transferOwnership:
        return 'Transfer group ownership to another member';
      case VoteAction.removeMember:
        return 'Remove a member from the group';
      case VoteAction.changePolicy:
        return 'Change group policy settings';
    }
  }
}

class GroupVote {
  final String id;
  final String groupId;
  final VoteAction action;
  final String targetUserId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? closesAt;
  final VoteStatus status;
  final Map<String, bool> ballots; // userId -> yes/no
  final Map<String, dynamic>? metadata; // Additional data for the action

  const GroupVote({
    required this.id,
    required this.groupId,
    required this.action,
    required this.targetUserId,
    required this.createdBy,
    required this.createdAt,
    this.closesAt,
    this.status = VoteStatus.open,
    this.ballots = const {},
    this.metadata,
  });

  factory GroupVote.fromMap(String id, Map<String, dynamic> data) {
    return GroupVote(
      id: id,
      groupId: data['groupId'] ?? '',
      action: VoteAction.values.firstWhere(
        (action) => action.name == data['action'],
        orElse: () => VoteAction.promoteAdmin,
      ),
      targetUserId: data['targetUserId'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      closesAt: data['closesAt'] != null
          ? (data['closesAt'] as Timestamp).toDate()
          : null,
      status: VoteStatus.values.firstWhere(
        (status) => status.name == data['status'],
        orElse: () => VoteStatus.open,
      ),
      ballots: Map<String, bool>.from(data['ballots'] ?? {}),
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'action': action.name,
      'targetUserId': targetUserId,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'closesAt': closesAt != null ? Timestamp.fromDate(closesAt!) : null,
      'status': status.name,
      'ballots': ballots,
      'metadata': metadata,
    };
  }

  GroupVote copyWith({
    String? id,
    String? groupId,
    VoteAction? action,
    String? targetUserId,
    String? createdBy,
    DateTime? createdAt,
    DateTime? closesAt,
    VoteStatus? status,
    Map<String, bool>? ballots,
    Map<String, dynamic>? metadata,
  }) {
    return GroupVote(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      action: action ?? this.action,
      targetUserId: targetUserId ?? this.targetUserId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      closesAt: closesAt ?? this.closesAt,
      status: status ?? this.status,
      ballots: ballots ?? this.ballots,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isOpen => status == VoteStatus.open;
  bool get isClosed => status == VoteStatus.closed;
  bool get isCancelled => status == VoteStatus.cancelled;

  bool get isExpired {
    if (closesAt == null) return false;
    return DateTime.now().isAfter(closesAt!);
  }

  int get totalVotes => ballots.length;
  int get yesVotes => ballots.values.where((vote) => vote).length;
  int get noVotes => ballots.values.where((vote) => !vote).length;

  double get yesPercentage {
    if (totalVotes == 0) return 0.0;
    return (yesVotes / totalVotes) * 100;
  }

  bool get hasPassed {
    if (totalVotes == 0) return false;
    return yesVotes > noVotes; // Simple majority
  }

  bool get hasQuorum {
    // For now, any vote counts as quorum
    // Could be enhanced to require minimum percentage of group members
    return totalVotes > 0;
  }

  bool hasVoted(String userId) {
    return ballots.containsKey(userId);
  }

  bool? getUserVote(String userId) {
    return ballots[userId];
  }

  Duration get timeRemaining {
    if (closesAt == null) return Duration.zero;
    final remaining = closesAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get timeRemainingText {
    final remaining = timeRemaining;
    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours % 24}h';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m';
    } else {
      return 'Expired';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupVote && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GroupVote(id: $id, action: $action, status: $status, totalVotes: $totalVotes)';
  }
}
