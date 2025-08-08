import 'package:cloud_firestore/cloud_firestore.dart';

enum GroupRole {
  owner,
  admin,
  member,
}

extension GroupRoleExtension on GroupRole {
  String get displayName {
    switch (this) {
      case GroupRole.owner:
        return 'Owner';
      case GroupRole.admin:
        return 'Admin';
      case GroupRole.member:
        return 'Member';
    }
  }

  String get shortName {
    switch (this) {
      case GroupRole.owner:
        return 'O';
      case GroupRole.admin:
        return 'A';
      case GroupRole.member:
        return 'M';
    }
  }

  int get permissionLevel {
    switch (this) {
      case GroupRole.owner:
        return 3;
      case GroupRole.admin:
        return 2;
      case GroupRole.member:
        return 1;
    }
  }

  bool canManageRoles() {
    return this == GroupRole.owner || this == GroupRole.admin;
  }

  bool canManagePolicy() {
    return this == GroupRole.owner || this == GroupRole.admin;
  }

  bool canRemoveMembers() {
    return this == GroupRole.owner || this == GroupRole.admin;
  }

  bool canInviteMembers() {
    return this == GroupRole.owner || this == GroupRole.admin;
  }

  bool canTransferOwnership() {
    return this == GroupRole.owner;
  }

  bool canDeleteGroup() {
    return this == GroupRole.owner;
  }

  bool canViewAuditLog() {
    return this == GroupRole.owner || this == GroupRole.admin;
  }

  bool canVote() {
    return this == GroupRole.owner ||
        this == GroupRole.admin ||
        this == GroupRole.member;
  }

  bool canOpenVotes() {
    return this == GroupRole.owner || this == GroupRole.admin;
  }
}

class GroupMember {
  final String userId;
  final GroupRole role;
  final DateTime joinedAt;
  final String? invitedBy;

  const GroupMember({
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.invitedBy,
  });

  factory GroupMember.fromMap(String userId, Map<String, dynamic> data) {
    return GroupMember(
      userId: userId,
      role: GroupRole.values.firstWhere(
        (role) => role.name == data['role'],
        orElse: () => GroupRole.member,
      ),
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      invitedBy: data['invitedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role.name,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'invitedBy': invitedBy,
    };
  }

  GroupMember copyWith({
    String? userId,
    GroupRole? role,
    DateTime? joinedAt,
    String? invitedBy,
  }) {
    return GroupMember(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      invitedBy: invitedBy ?? this.invitedBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupMember && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() {
    return 'GroupMember(userId: $userId, role: $role)';
  }
}
