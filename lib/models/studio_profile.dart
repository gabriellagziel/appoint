import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_profile.freezed.dart';
part 'studio_profile.g.dart';

@freezed
class StudioProfile with _$StudioProfile {
  const factory StudioProfile({
    required String id,
    required String name,
    required String ownerId,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? imageUrl,
    bool? isAdminFreeAccess,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StudioProfile;

  factory StudioProfile.fromJson(Map<String, dynamic> json) =>
      _$StudioProfileFromJson(json);
}
