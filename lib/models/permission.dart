import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission.freezed.dart';
part 'permission.g.dart';

@freezed
class Permission with _$Permission {
  const factory Permission({
    required String id,
    required String familyLinkId,
    required String grantedTo, // childId
    required String grantedBy, // parentId
    required String
        permissionType, // 'calendar_view', 'reminder_assign', 'data_access'
    required bool isGranted,
    required DateTime grantedAt,
    DateTime? revokedAt,
    String? notes,
  }) = _Permission;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);
}
