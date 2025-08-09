import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FamilyRole {
  parent,
  child,
  spouse,
  other,
}

enum ApprovalStatus {
  pending,
  approved,
  denied,
}

class FamilyMember {
  final String id;
  final String name;
  final String email;
  final FamilyRole role;
  final DateTime joinedAt;
  final String? profileImageUrl;
  final bool isActive;
  final ApprovalStatus approvalStatus;
  final String? invitedBy;
  final DateTime? lastActive;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedAt,
    this.profileImageUrl,
    this.isActive = true,
    this.approvalStatus = ApprovalStatus.approved,
    this.invitedBy,
    this.lastActive,
  });

  factory FamilyMember.fromMap(String id, Map<String, dynamic> data) {
    return FamilyMember(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: FamilyRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => FamilyRole.other,
      ),
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      profileImageUrl: data['profileImageUrl'],
      isActive: data['isActive'] ?? true,
      approvalStatus: ApprovalStatus.values.firstWhere(
        (e) => e.name == data['approvalStatus'],
        orElse: () => ApprovalStatus.approved,
      ),
      invitedBy: data['invitedBy'],
      lastActive: data['lastActive'] != null
          ? (data['lastActive'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role.name,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'profileImageUrl': profileImageUrl,
      'isActive': isActive,
      'approvalStatus': approvalStatus.name,
      'invitedBy': invitedBy,
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
    };
  }

  FamilyMember copyWith({
    String? id,
    String? name,
    String? email,
    FamilyRole? role,
    DateTime? joinedAt,
    String? profileImageUrl,
    bool? isActive,
    ApprovalStatus? approvalStatus,
    String? invitedBy,
    DateTime? lastActive,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isActive: isActive ?? this.isActive,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      invitedBy: invitedBy ?? this.invitedBy,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  bool get isParent => role == FamilyRole.parent;
  bool get isChild => role == FamilyRole.child;
  bool get isSpouse => role == FamilyRole.spouse;
  bool get isPendingApproval => approvalStatus == ApprovalStatus.pending;
  bool get isApproved => approvalStatus == ApprovalStatus.approved;
  bool get isDenied => approvalStatus == ApprovalStatus.denied;

  String get roleDisplayName {
    switch (role) {
      case FamilyRole.parent:
        return 'Parent';
      case FamilyRole.child:
        return 'Child';
      case FamilyRole.spouse:
        return 'Spouse';
      case FamilyRole.other:
        return 'Family Member';
    }
  }

  Color get roleColor {
    switch (role) {
      case FamilyRole.parent:
        return Colors.blue;
      case FamilyRole.child:
        return Colors.green;
      case FamilyRole.spouse:
        return Colors.purple;
      case FamilyRole.other:
        return Colors.orange;
    }
  }

  IconData get roleIcon {
    switch (role) {
      case FamilyRole.parent:
        return Icons.family_restroom;
      case FamilyRole.child:
        return Icons.child_care;
      case FamilyRole.spouse:
        return Icons.favorite;
      case FamilyRole.other:
        return Icons.person;
    }
  }

  String get statusDisplayName {
    switch (approvalStatus) {
      case ApprovalStatus.pending:
        return 'Pending Approval';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.denied:
        return 'Denied';
    }
  }

  Color get statusColor {
    switch (approvalStatus) {
      case ApprovalStatus.pending:
        return Colors.orange;
      case ApprovalStatus.approved:
        return Colors.green;
      case ApprovalStatus.denied:
        return Colors.red;
    }
  }
}






