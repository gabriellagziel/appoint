import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_profile.freezed.dart';
part 'business_profile.g.dart';

@freezed
class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required final String name,
    required final String description,
    required final String phone,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);
}

extension BusinessProfileExtension on BusinessProfile {
  String? get logoUrl =>
      null; // TODO(username): Add logoUrl property when code generation is fixed
}
