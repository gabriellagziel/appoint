import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPolicy {
  final bool membersCanInvite;
  final bool requireVoteForAdmin;
  final bool allowNonMembersRSVP;
  final bool allowMediaSharing;
  final bool allowChecklists;
  final int maxMembers;
  final Duration voteDuration;
  final DateTime? lastUpdated;
  final String? updatedBy;
  final int version;

  const GroupPolicy({
    this.membersCanInvite = true,
    this.requireVoteForAdmin = true,
    this.allowNonMembersRSVP = true,
    this.allowMediaSharing = true,
    this.allowChecklists = true,
    this.maxMembers = 100,
    this.voteDuration = const Duration(hours: 48),
    this.lastUpdated,
    this.updatedBy,
    this.version = 1,
  });

  factory GroupPolicy.fromMap(Map<String, dynamic> data) {
    return GroupPolicy(
      membersCanInvite: data['membersCanInvite'] ?? true,
      requireVoteForAdmin: data['requireVoteForAdmin'] ?? true,
      allowNonMembersRSVP: data['allowNonMembersRSVP'] ?? true,
      allowMediaSharing: data['allowMediaSharing'] ?? true,
      allowChecklists: data['allowChecklists'] ?? true,
      maxMembers: data['maxMembers'] ?? 100,
      voteDuration: Duration(hours: data['voteDurationHours'] ?? 48),
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
      updatedBy: data['updatedBy'],
      version: data['version'] is int ? data['version'] as int : 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'membersCanInvite': membersCanInvite,
      'requireVoteForAdmin': requireVoteForAdmin,
      'allowNonMembersRSVP': allowNonMembersRSVP,
      'allowMediaSharing': allowMediaSharing,
      'allowChecklists': allowChecklists,
      'maxMembers': maxMembers,
      'voteDurationHours': voteDuration.inHours,
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
      'updatedBy': updatedBy,
      'version': version,
    };
  }

  GroupPolicy copyWith({
    bool? membersCanInvite,
    bool? requireVoteForAdmin,
    bool? allowNonMembersRSVP,
    bool? allowMediaSharing,
    bool? allowChecklists,
    int? maxMembers,
    Duration? voteDuration,
    DateTime? lastUpdated,
    String? updatedBy,
    int? version,
  }) {
    return GroupPolicy(
      membersCanInvite: membersCanInvite ?? this.membersCanInvite,
      requireVoteForAdmin: requireVoteForAdmin ?? this.requireVoteForAdmin,
      allowNonMembersRSVP: allowNonMembersRSVP ?? this.allowNonMembersRSVP,
      allowMediaSharing: allowMediaSharing ?? this.allowMediaSharing,
      allowChecklists: allowChecklists ?? this.allowChecklists,
      maxMembers: maxMembers ?? this.maxMembers,
      voteDuration: voteDuration ?? this.voteDuration,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
      version: version ?? this.version,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupPolicy &&
        other.membersCanInvite == membersCanInvite &&
        other.requireVoteForAdmin == requireVoteForAdmin &&
        other.allowNonMembersRSVP == allowNonMembersRSVP &&
        other.allowMediaSharing == allowMediaSharing &&
        other.allowChecklists == allowChecklists &&
        other.maxMembers == maxMembers &&
        other.voteDuration == voteDuration;
  }

  @override
  int get hashCode {
    return Object.hash(
      membersCanInvite,
      requireVoteForAdmin,
      allowNonMembersRSVP,
      allowMediaSharing,
      allowChecklists,
      maxMembers,
      voteDuration,
    );
  }

  @override
  String toString() {
    return 'GroupPolicy(membersCanInvite: $membersCanInvite, requireVoteForAdmin: $requireVoteForAdmin, allowNonMembersRSVP: $allowNonMembersRSVP)';
  }
}
