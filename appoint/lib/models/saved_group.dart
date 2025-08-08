import 'package:cloud_firestore/cloud_firestore.dart';

class SavedGroup {
  final String groupId;
  final bool pinned;
  final String? alias;
  final DateTime lastUsedAt;
  final int useCount;

  const SavedGroup({
    required this.groupId,
    required this.pinned,
    this.alias,
    required this.lastUsedAt,
    required this.useCount,
  });

  factory SavedGroup.fromMap(String groupId, Map<String, dynamic> data) {
    return SavedGroup(
      groupId: groupId,
      pinned: data['pinned'] ?? false,
      alias: data['alias'],
      lastUsedAt: (data['lastUsedAt'] as Timestamp).toDate(),
      useCount: data['useCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pinned': pinned,
      'alias': alias,
      'lastUsedAt': Timestamp.fromDate(lastUsedAt),
      'useCount': useCount,
    };
  }

  SavedGroup copyWith({
    String? groupId,
    bool? pinned,
    String? alias,
    DateTime? lastUsedAt,
    int? useCount,
  }) {
    return SavedGroup(
      groupId: groupId ?? this.groupId,
      pinned: pinned ?? this.pinned,
      alias: alias ?? this.alias,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      useCount: useCount ?? this.useCount,
    );
  }

  String getDisplayName(String? groupName) {
    if (alias != null && alias!.isNotEmpty) {
      return alias!;
    }
    return groupName ?? 'Group $groupId';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedGroup && other.groupId == groupId;
  }

  @override
  int get hashCode => groupId.hashCode;

  @override
  String toString() {
    return 'SavedGroup(groupId: $groupId, pinned: $pinned, alias: $alias, useCount: $useCount)';
  }
}
