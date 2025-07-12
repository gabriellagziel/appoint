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
    required final String id,
    required final String parentPhoneNumber,
    required final FreeAccessStatus status,
    required final DateTime startDate,
    required final DateTime endDate,
    required final String grantedByAdminId,
    required final String grantedByAdminName,
    required final DateTime grantedAt,
    final String? notes,
    final DateTime? lastAccessedAt,
    final int? totalAccessCount,
  }) = _ParentFreeAccess;

  factory ParentFreeAccess.fromJson(Map<String, dynamic> json) =>
      _$ParentFreeAccessFromJson(json);
}
