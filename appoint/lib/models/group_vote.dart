import 'package:cloud_firestore/cloud_firestore.dart';

class GroupVote {
  final String id;
  final String groupId;
  final String action;
  final String targetUserId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? closesAt;
  final String status;
  final Map<String, bool> ballots; // userId -> yes/no
  final Map<String, dynamic>? metadata; // Additional data for the action
  final int yesCount;
  final int noCount;

  const GroupVote({
    required this.id,
    required this.groupId,
    required this.action,
    required this.targetUserId,
    required this.createdBy,
    required this.createdAt,
    this.closesAt,
    this.status = 'open',
    this.ballots = const {},
    this.metadata,
    this.yesCount = 0,
    this.noCount = 0,
  });

  factory GroupVote.fromMap(String id, Map<String, dynamic> data) {
    return GroupVote(
      id: id,
      groupId: data['groupId'] ?? '',
      action: data['action'] ?? 'promote_admin',
      targetUserId: data['targetUserId'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      closesAt: data['closesAt'] != null
          ? (data['closesAt'] as Timestamp).toDate()
          : null,
      status: data['status'] ?? 'open',
      ballots: Map<String, bool>.from(data['ballots'] ?? {}),
      metadata: data['metadata'],
      yesCount: (data['yesCount'] ?? 0) as int,
      noCount: (data['noCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'action': action,
      'targetUserId': targetUserId,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'closesAt': closesAt != null ? Timestamp.fromDate(closesAt!) : null,
      'status': status,
      'ballots': ballots,
      'metadata': metadata,
      'yesCount': yesCount,
      'noCount': noCount,
    };
  }

  GroupVote copyWith({
    String? id,
    String? groupId,
    String? action,
    String? targetUserId,
    String? createdBy,
    DateTime? createdAt,
    DateTime? closesAt,
    String? status,
    Map<String, bool>? ballots,
    Map<String, dynamic>? metadata,
    int? yesCount,
    int? noCount,
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
      yesCount: yesCount ?? this.yesCount,
      noCount: noCount ?? this.noCount,
    );
  }

  bool get isOpen => status == 'open';
  bool get isClosed => status == 'closed';
  bool get isCancelled => status == 'cancelled';

  bool get isExpired {
    if (closesAt == null) return false;
    return DateTime.now().isAfter(closesAt!);
  }

  int get totalVotes => yesCount + noCount;
  int get yesVotes => yesCount;
  int get noVotes => noCount;

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
