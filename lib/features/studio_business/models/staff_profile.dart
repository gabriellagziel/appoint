import 'package:json_annotation/json_annotation.dart';

part 'staff_profile.g.dart';

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

  factory StaffProfile.fromJson(Map<String, dynamic> json) =>
      _$StaffProfileFromJson(json);
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
  Map<String, dynamic> toJson() => _$StaffProfileToJson(this);
}
