import 'package:freezed_annotation/freezed_annotation.dart';
part 'staff_member.freezed.dart';
part 'staff_member.g.dart';

@freezed
class StaffMember with _$StaffMember {
  const factory StaffMember({
    required final String id,
    required final String displayName,
    final String? photoUrl,
  }) = _StaffMember;

  factory StaffMember.fromJson(Map<String, dynamic> json) =>
      _$StaffMemberFromJson(json);
}
