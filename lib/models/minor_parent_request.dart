import 'package:freezed_annotation/freezed_annotation.dart';

part 'minor_parent_request.freezed.dart';
part 'minor_parent_request.g.dart';

@freezed
class MinorParentRequest with _$MinorParentRequest {
  const factory MinorParentRequest({
    required String minorId,
    required String parentPhoneNumber,
    required String otpCode,
    @Default(false) bool isVerified,
  }) = _MinorParentRequest;

  factory MinorParentRequest.fromJson(Map<String, dynamic> json) =>
      _$MinorParentRequestFromJson(json);
}
