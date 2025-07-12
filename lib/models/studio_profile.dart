import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_profile.freezed.dart';
part 'studio_profile.g.dart';

@freezed
class StudioProfile with _$StudioProfile {
  const factory StudioProfile({
    required final String id,
    required final String name,
    required final String ownerId,
    final String? description,
    final String? address,
    final String? phone,
    final String? email,
    final String? imageUrl,
    final bool? isAdminFreeAccess,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _StudioProfile;

  factory StudioProfile.fromJson(Map<String, dynamic> json) =>
      _$StudioProfileFromJson(json);
}
