import 'package:json_annotation/json_annotation.dart';

part '../../../generated/features/studio_business/models/studio_profile.g.dart';

@JsonSerializable()
class StudioProfile {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String website;
  final List<String> services;
  final List<String> equipment;
  final Map<String, dynamic> studioHours;
  final String? logoUrl;
  final String? coverImageUrl;
  final List<String> photos;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudioProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.website = '',
    required this.services,
    required this.equipment,
    required this.studioHours,
    this.logoUrl,
    this.coverImageUrl,
    this.photos = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudioProfile.fromJson(final Map<String, dynamic> json) =>
      _$StudioProfileFromJson(json);

  Map<String, dynamic> toJson() => _$StudioProfileToJson(this);

  StudioProfile copyWith({
    final String? id,
    final String? name,
    final String? description,
    final String? address,
    final String? phone,
    final String? email,
    final String? website,
    final List<String>? services,
    final List<String>? equipment,
    final Map<String, dynamic>? studioHours,
    final String? logoUrl,
    final String? coverImageUrl,
    final List<String>? photos,
    final bool? isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) {
    return StudioProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      services: services ?? this.services,
      equipment: equipment ?? this.equipment,
      studioHours: studioHours ?? this.studioHours,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      photos: photos ?? this.photos,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
