import 'package:json_annotation/json_annotation.dart';

part 'staff_profile.g.dart';

@JsonSerializable()
class StaffProfile {
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

  StaffProfile({
    required this.id,
    required this.businessProfileId,
    required this.name,
    this.photoUrl,
    this.bio,
    required this.services,
    required this.hourlyRate,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory StaffProfile.fromJson(final Map<String, dynamic> json) =>
      _$StaffProfileFromJson(json);
  Map<String, dynamic> toJson() => _$StaffProfileToJson(this);
} 