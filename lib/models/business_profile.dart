import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_profile.freezed.dart';
part 'business_profile.g.dart';

@freezed
class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String name,
    required String description,
    required String phone,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) => _$BusinessProfileFromJson(json);
} 