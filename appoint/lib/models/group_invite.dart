import 'package:cloud_firestore/cloud_firestore.dart';

class GroupInvite {
  final String code;
  final String groupId;
  final String createdBy;
  final List<String> usedBy;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final int maxUses;
  final bool isActive;

  GroupInvite({
    required this.code,
    required this.groupId,
    required this.createdBy,
    required this.usedBy,
    required this.createdAt,
    this.expiresAt,
    this.maxUses = -1, // -1 means unlimited
    this.isActive = true,
  });

  factory GroupInvite.fromMap(String code, Map<String, dynamic> data) {
    return GroupInvite(
      code: code,
      groupId: data['groupId'] ?? '',
      createdBy: data['createdBy'] ?? '',
      usedBy: List<String>.from(data['usedBy'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: data['expiresAt'] != null 
          ? (data['expiresAt'] as Timestamp).toDate() 
          : null,
      maxUses: data['maxUses'] ?? -1,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'createdBy': createdBy,
      'usedBy': usedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'maxUses': maxUses,
      'isActive': isActive,
    };
  }

  GroupInvite copyWith({
    String? code,
    String? groupId,
    String? createdBy,
    List<String>? usedBy,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? maxUses,
    bool? isActive,
  }) {
    return GroupInvite(
      code: code ?? this.code,
      groupId: groupId ?? this.groupId,
      createdBy: createdBy ?? this.createdBy,
      usedBy: usedBy ?? this.usedBy,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      maxUses: maxUses ?? this.maxUses,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isMaxUsesReached => maxUses > 0 && usedBy.length >= maxUses;
  bool get isValid => isActive && !isExpired && !isMaxUsesReached;
  int get remainingUses => maxUses > 0 ? maxUses - usedBy.length : -1;
}

