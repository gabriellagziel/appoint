import 'package:json_annotation/json_annotation.dart';

// Temporarily removed generated file dependency
// part 'staff_profile.g.dart';

@JsonSerializable()
class StaffProfile {

  StaffProfile({
    required this.id,
    required this.businessProfileId,
    required this.name,
    required this.services, 
    required this.hourlyRate, 
    required this.createdAt, 
    this.photoUrl,
    this.bio,
    this.isActive = true,
    this.updatedAt,
  });

  // Manual implementation instead of generated code
  factory StaffProfile.fromJson(Map<String, dynamic> json) {
    return StaffProfile(
      id: json['id'] as String,
      businessProfileId: json['businessProfileId'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      services: List<String>.from(json['services'] as List),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

  final String id;
  final String businessProfileId;
  final String name;
  final String? photoUrl;
  final String? bio;
  final List<String> services;
  final double hourlyRate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessProfileId': businessProfileId,
      'name': name,
      'photoUrl': photoUrl,
      'bio': bio,
      'services': services,
      'hourlyRate': hourlyRate,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
