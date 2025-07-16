import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessProfile {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final List<String> services;
  final Map<String, dynamic> workingHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  BusinessProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.services,
    required this.workingHours,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusinessProfile(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      services: List<String>.from(data['services'] ?? []),
      workingHours: Map<String, dynamic>.from(data['workingHours'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory BusinessProfile.fromJson(Map<String, dynamic> json) => BusinessProfile(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    services: List<String>.from(json['services'] as List),
    workingHours: Map<String, dynamic>.from(json['workingHours'] as Map),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'address': address,
    'phone': phone,
    'email': email,
    'services': services,
    'workingHours': workingHours,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'description': description,
    'address': address,
    'phone': phone,
    'email': email,
    'services': services,
    'workingHours': workingHours,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  BusinessProfile copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? phone,
    String? email,
    List<String>? services,
    Map<String, dynamic>? workingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BusinessProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    services: services ?? this.services,
    workingHours: workingHours ?? this.workingHours,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
