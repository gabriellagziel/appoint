import 'package:cloud_firestore/cloud_firestore.dart';

class UserGroup {
  final String id;
  final String name;
  final String createdBy;
  final List<String> members;
  final List<String> admins;
  final DateTime createdAt;
  final String? description;
  final String? imageUrl;
  final bool isActive;

  UserGroup({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.members,
    required this.admins,
    required this.createdAt,
    this.description,
    this.imageUrl,
    this.isActive = true,
  });

  factory UserGroup.fromMap(String id, Map<String, dynamic> data) {
    return UserGroup(
      id: id,
      name: data['name'] ?? '',
      createdBy: data['createdBy'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      admins: List<String>.from(data['admins'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      description: data['description'],
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'createdBy': createdBy,
      'members': members,
      'admins': admins,
      'createdAt': Timestamp.fromDate(createdAt),
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }

  UserGroup copyWith({
    String? id,
    String? name,
    String? createdBy,
    List<String>? members,
    List<String>? admins,
    DateTime? createdAt,
    String? description,
    String? imageUrl,
    bool? isActive,
  }) {
    return UserGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      admins: admins ?? this.admins,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isAdmin => admins.contains(createdBy);
  bool get isMember => members.contains(createdBy);
  int get memberCount => members.length;
  int get adminCount => admins.length;
}

