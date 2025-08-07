// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrivacyRequest _$PrivacyRequestFromJson(Map<String, dynamic> json) {
  return _PrivacyRequest.fromJson(json);
}

/// @nodoc
mixin _$PrivacyRequest {
  String get id => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'private_session', 'data_access', etc.
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'approved', 'denied'
  DateTime get requestedAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  String? get parentResponse => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

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
      String type,
      String status,
      DateTime requestedAt,
      DateTime? respondedAt,
      String? parentResponse,
      String? reason});
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
    Object? type = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? respondedAt = freezed,
    Object? parentResponse = freezed,
    Object? reason = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
      parentResponse: freezed == parentResponse
          ? _value.parentResponse
          : parentResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
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
      String type,
      String status,
      DateTime requestedAt,
      DateTime? respondedAt,
      String? parentResponse,
      String? reason});
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
    Object? type = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? respondedAt = freezed,
    Object? parentResponse = freezed,
    Object? reason = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
      parentResponse: freezed == parentResponse
          ? _value.parentResponse
          : parentResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
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
      required this.type,
      required this.status,
      required this.requestedAt,
      this.respondedAt,
      this.parentResponse,
      this.reason});

  factory _$PrivacyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String childId;
  @override
  final String type;
// 'private_session', 'data_access', etc.
  @override
  final String status;
// 'pending', 'approved', 'denied'
  @override
  final DateTime requestedAt;
  @override
  final DateTime? respondedAt;
  @override
  final String? parentResponse;
  @override
  final String? reason;

  @override
  String toString() {
    return 'PrivacyRequest(id: $id, childId: $childId, type: $type, status: $status, requestedAt: $requestedAt, respondedAt: $respondedAt, parentResponse: $parentResponse, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.parentResponse, parentResponse) ||
                other.parentResponse == parentResponse) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, childId, type, status,
      requestedAt, respondedAt, parentResponse, reason);

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
      required final String type,
      required final String status,
      required final DateTime requestedAt,
      final DateTime? respondedAt,
      final String? parentResponse,
      final String? reason}) = _$PrivacyRequestImpl;

  factory _PrivacyRequest.fromJson(Map<String, dynamic> json) =
      _$PrivacyRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get childId;
  @override
  String get type; // 'private_session', 'data_access', etc.
  @override
  String get status; // 'pending', 'approved', 'denied'
  @override
  DateTime get requestedAt;
  @override
  DateTime? get respondedAt;
  @override
  String? get parentResponse;
  @override
  String? get reason;

  /// Create a copy of PrivacyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacyRequestImplCopyWith<_$PrivacyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
