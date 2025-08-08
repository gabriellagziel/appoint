// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

FamilyLink _$FamilyLinkFromJson(Map<String, dynamic> json) {
  return _FamilyLink.fromJson(json);
}

/// @nodoc
mixin _$FamilyLink {
  String get id => throw _privateConstructorUsedError;
  String get parentId => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'active', 'inactive'
  DateTime get invitedAt => throw _privateConstructorUsedError;
  List<DateTime> get consentedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;

  /// Serializes this FamilyLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyLinkCopyWith<FamilyLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyLinkCopyWith<$Res> {
  factory $FamilyLinkCopyWith(
          FamilyLink value, $Res Function(FamilyLink) then) =
      _$FamilyLinkCopyWithImpl<$Res, FamilyLink>;
  @useResult
  $Res call(
      {String id,
      String parentId,
      String childId,
      String status,
      DateTime invitedAt,
      List<DateTime> consentedAt,
      String? notes,
      DateTime? lastActivityAt});
}

/// @nodoc
class _$FamilyLinkCopyWithImpl<$Res, $Val extends FamilyLink>
    implements $FamilyLinkCopyWith<$Res> {
  _$FamilyLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? childId = null,
    Object? status = null,
    Object? invitedAt = null,
    Object? consentedAt = null,
    Object? notes = freezed,
    Object? lastActivityAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      consentedAt: null == consentedAt
          ? _value.consentedAt
          : consentedAt // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyLinkImplCopyWith<$Res>
    implements $FamilyLinkCopyWith<$Res> {
  factory _$$FamilyLinkImplCopyWith(
          _$FamilyLinkImpl value, $Res Function(_$FamilyLinkImpl) then) =
      __$$FamilyLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String parentId,
      String childId,
      String status,
      DateTime invitedAt,
      List<DateTime> consentedAt,
      String? notes,
      DateTime? lastActivityAt});
}

/// @nodoc
class __$$FamilyLinkImplCopyWithImpl<$Res>
    extends _$FamilyLinkCopyWithImpl<$Res, _$FamilyLinkImpl>
    implements _$$FamilyLinkImplCopyWith<$Res> {
  __$$FamilyLinkImplCopyWithImpl(
      _$FamilyLinkImpl _value, $Res Function(_$FamilyLinkImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? childId = null,
    Object? status = null,
    Object? invitedAt = null,
    Object? consentedAt = null,
    Object? notes = freezed,
    Object? lastActivityAt = freezed,
  }) {
    return _then(_$FamilyLinkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      consentedAt: null == consentedAt
          ? _value._consentedAt
          : consentedAt // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyLinkImpl implements _FamilyLink {
  const _$FamilyLinkImpl(
      {required this.id,
      required this.parentId,
      required this.childId,
      required this.status,
      required this.invitedAt,
      required final List<DateTime> consentedAt,
      this.notes,
      this.lastActivityAt})
      : _consentedAt = consentedAt;

  factory _$FamilyLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyLinkImplFromJson(json);

  @override
  final String id;
  @override
  final String parentId;
  @override
  final String childId;
  @override
  final String status;
// 'pending', 'active', 'inactive'
  @override
  final DateTime invitedAt;
  final List<DateTime> _consentedAt;
  @override
  List<DateTime> get consentedAt {
    if (_consentedAt is EqualUnmodifiableListView) return _consentedAt;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consentedAt);
  }

  @override
  final String? notes;
  @override
  final DateTime? lastActivityAt;

  @override
  String toString() {
    return 'FamilyLink(id: $id, parentId: $parentId, childId: $childId, status: $status, invitedAt: $invitedAt, consentedAt: $consentedAt, notes: $notes, lastActivityAt: $lastActivityAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyLinkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt) &&
            const DeepCollectionEquality()
                .equals(other._consentedAt, _consentedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      parentId,
      childId,
      status,
      invitedAt,
      const DeepCollectionEquality().hash(_consentedAt),
      notes,
      lastActivityAt);

  /// Create a copy of FamilyLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyLinkImplCopyWith<_$FamilyLinkImpl> get copyWith =>
      __$$FamilyLinkImplCopyWithImpl<_$FamilyLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyLinkImplToJson(
      this,
    );
  }
}

abstract class _FamilyLink implements FamilyLink {
  const factory _FamilyLink(
      {required final String id,
      required final String parentId,
      required final String childId,
      required final String status,
      required final DateTime invitedAt,
      required final List<DateTime> consentedAt,
      final String? notes,
      final DateTime? lastActivityAt}) = _$FamilyLinkImpl;

  factory _FamilyLink.fromJson(Map<String, dynamic> json) =
      _$FamilyLinkImpl.fromJson;

  @override
  String get id;
  @override
  String get parentId;
  @override
  String get childId;
  @override
  String get status; // 'pending', 'active', 'inactive'
  @override
  DateTime get invitedAt;
  @override
  List<DateTime> get consentedAt;
  @override
  String? get notes;
  @override
  DateTime? get lastActivityAt;

  /// Create a copy of FamilyLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyLinkImplCopyWith<_$FamilyLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
