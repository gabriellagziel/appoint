import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_link.freezed.dart';
part 'family_link.g.dart';

@freezed
class FamilyLink with _$FamilyLink {
  const factory FamilyLink({
    required String id,
    required String parentId,
    required String childId,
    required String status, // 'pending', 'active', 'inactive'
    required DateTime invitedAt,
    required List<DateTime> consentedAt,
    String? notes,
    DateTime? lastActivityAt,
  }) = _FamilyLink;

  factory FamilyLink.fromJson(Map<String, dynamic> json) =>
      _$FamilyLinkFromJson(json);
}
