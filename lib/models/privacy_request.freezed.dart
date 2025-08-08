// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

PrivacyRequest _$PrivacyRequestFromJson(Map<String, dynamic> json) {
  return _PrivacyRequest.fromJson(json);
}

/// @nodoc
mixin _$PrivacyRequest {
  String get id => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  String get parentId => throw _privateConstructorUsedError;
  String get requestType =>
      throw _privateConstructorUsedError; // 'data_access', 'account_deletion', 'permission_change'
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'approved', 'denied'
  DateTime get requestedAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String? get parentResponse => throw _privateConstructorUsedError;

  /// Serializes this PrivacyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacyRequestCopyWith<PrivacyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyRequestCopyWith<$Res> {
  factory $PrivacyRequestCopyWith(
          PrivacyRequest value, $Res Function(PrivacyRequest) then) =
      _$PrivacyRequestCopyWithImpl<$Res, PrivacyRequest>;
  @useResult
  $Res call(
      {String id,
      String childId,
      String parentId,
      String requestType,
      String status,
      DateTime requestedAt,
      DateTime? respondedAt,
      String? reason,
      String? parentResponse});
}

/// @nodoc
class _$PrivacyRequestCopyWithImpl<$Res, $Val extends PrivacyRequest>
    implements $PrivacyRequestCopyWith<$Res> {
  _$PrivacyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? parentId = null,
    Object? requestType = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? respondedAt = freezed,
    Object? reason = freezed,
    Object? parentResponse = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      parentResponse: freezed == parentResponse
          ? _value.parentResponse
          : parentResponse // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyRequestImplCopyWith<$Res>
    implements $PrivacyRequestCopyWith<$Res> {
  factory _$$PrivacyRequestImplCopyWith(_$PrivacyRequestImpl value,
          $Res Function(_$PrivacyRequestImpl) then) =
      __$$PrivacyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String childId,
      String parentId,
      String requestType,
      String status,
      DateTime requestedAt,
      DateTime? respondedAt,
      String? reason,
      String? parentResponse});
}

/// @nodoc
class __$$PrivacyRequestImplCopyWithImpl<$Res>
    extends _$PrivacyRequestCopyWithImpl<$Res, _$PrivacyRequestImpl>
    implements _$$PrivacyRequestImplCopyWith<$Res> {
  __$$PrivacyRequestImplCopyWithImpl(
      _$PrivacyRequestImpl _value, $Res Function(_$PrivacyRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivacyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? parentId = null,
    Object? requestType = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? respondedAt = freezed,
    Object? reason = freezed,
    Object? parentResponse = freezed,
  }) {
    return _then(_$PrivacyRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      parentResponse: freezed == parentResponse
          ? _value.parentResponse
          : parentResponse // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyRequestImpl implements _PrivacyRequest {
  const _$PrivacyRequestImpl(
      {required this.id,
      required this.childId,
      required this.parentId,
      required this.requestType,
      required this.status,
      required this.requestedAt,
      this.respondedAt,
      this.reason,
      this.parentResponse});

  factory _$PrivacyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String childId;
  @override
  final String parentId;
  @override
  final String requestType;
// 'data_access', 'account_deletion', 'permission_change'
  @override
  final String status;
// 'pending', 'approved', 'denied'
  @override
  final DateTime requestedAt;
  @override
  final DateTime? respondedAt;
  @override
  final String? reason;
  @override
  final String? parentResponse;

  @override
  String toString() {
    return 'PrivacyRequest(id: $id, childId: $childId, parentId: $parentId, requestType: $requestType, status: $status, requestedAt: $requestedAt, respondedAt: $respondedAt, reason: $reason, parentResponse: $parentResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.parentResponse, parentResponse) ||
                other.parentResponse == parentResponse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, childId, parentId,
      requestType, status, requestedAt, respondedAt, reason, parentResponse);

  /// Create a copy of PrivacyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyRequestImplCopyWith<_$PrivacyRequestImpl> get copyWith =>
      __$$PrivacyRequestImplCopyWithImpl<_$PrivacyRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyRequestImplToJson(
      this,
    );
  }
}

abstract class _PrivacyRequest implements PrivacyRequest {
  const factory _PrivacyRequest(
      {required final String id,
      required final String childId,
      required final String parentId,
      required final String requestType,
      required final String status,
      required final DateTime requestedAt,
      final DateTime? respondedAt,
      final String? reason,
      final String? parentResponse}) = _$PrivacyRequestImpl;

  factory _PrivacyRequest.fromJson(Map<String, dynamic> json) =
      _$PrivacyRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get childId;
  @override
  String get parentId;
  @override
  String
      get requestType; // 'data_access', 'account_deletion', 'permission_change'
  @override
  String get status; // 'pending', 'approved', 'denied'
  @override
  DateTime get requestedAt;
  @override
  DateTime? get respondedAt;
  @override
  String? get reason;
  @override
  String? get parentResponse;

  /// Create a copy of PrivacyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacyRequestImplCopyWith<_$PrivacyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
