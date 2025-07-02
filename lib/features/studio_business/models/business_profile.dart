import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/features/studio_business/models/business_profile.g.dart';

@JsonSerializable()
class BusinessProfile {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String website;
  final List<String> services;
  final Map<String, dynamic> businessHours;
  final String? logoUrl;
  final String? coverImageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? ownerId;
  final String? imageUrl;
  final bool? isAdminFreeAccess;

  BusinessProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.website = '',
    required this.services,
    required this.businessHours,
    this.logoUrl,
    this.coverImageUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.ownerId,
    this.imageUrl,
    this.isAdminFreeAccess,
  });

  factory BusinessProfile.fromJson(final Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessProfileToJson(this);

  BusinessProfile copyWith({
    final String? id,
    final String? name,
    final String? description,
    final String? address,
    final String? phone,
    final String? email,
    final String? website,
    final List<String>? services,
    final Map<String, dynamic>? businessHours,
    final String? logoUrl,
    final String? coverImageUrl,
    final bool? isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? ownerId,
    final String? imageUrl,
    final bool? isAdminFreeAccess,
  }) {
    return BusinessProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      services: services ?? this.services,
      businessHours: businessHours ?? this.businessHours,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
      imageUrl: imageUrl ?? this.imageUrl,
      isAdminFreeAccess: isAdminFreeAccess ?? this.isAdminFreeAccess,
    );
  }
}
