import 'package:freezed_annotation/freezed_annotation.dart';

part 'parent_free_access.freezed.dart';
part 'parent_free_access.g.dart';

enum FreeAccessStatus {
  active,
  inactive,
  expired,
}

@freezed
class ParentFreeAccess with _$ParentFreeAccess {
  const factory ParentFreeAccess({
    required String id,
    required String parentPhoneNumber,
    required FreeAccessStatus status,
    required DateTime startDate,
    required DateTime endDate,
    required String grantedByAdminId,
    required String grantedByAdminName,
    required DateTime grantedAt,
    String? notes,
    DateTime? lastAccessedAt,
    int? totalAccessCount,
  }) = _ParentFreeAccess;

  factory ParentFreeAccess.fromJson(Map<String, dynamic> json) =>
      _$ParentFreeAccessFromJson(json);
}
