import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_request.freezed.dart';
part 'privacy_request.g.dart';

@freezed
class PrivacyRequest with _$PrivacyRequest {
  const factory PrivacyRequest({
    required String id,
    required String childId,
    required String parentId,
    required String
        requestType, // 'data_access', 'account_deletion', 'permission_change'
    required String status, // 'pending', 'approved', 'denied'
    required DateTime requestedAt,
    DateTime? respondedAt,
    String? reason,
    String? parentResponse,
  }) = _PrivacyRequest;

  factory PrivacyRequest.fromJson(Map<String, dynamic> json) =>
      _$PrivacyRequestFromJson(json);
}
