// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

Permission _$PermissionFromJson(Map<String, dynamic> json) {
  return _Permission.fromJson(json);
}

/// @nodoc
mixin _$Permission {
  String get id => throw _privateConstructorUsedError;
  String get familyLinkId => throw _privateConstructorUsedError;
  String get grantedTo => throw _privateConstructorUsedError; // childId
  String get grantedBy => throw _privateConstructorUsedError; // parentId
  String get permissionType =>
      throw _privateConstructorUsedError; // 'calendar_view', 'reminder_assign', 'data_access'
  bool get isGranted => throw _privateConstructorUsedError;
  DateTime get grantedAt => throw _privateConstructorUsedError;
  DateTime? get revokedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this Permission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionCopyWith<Permission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionCopyWith<$Res> {
  factory $PermissionCopyWith(
          Permission value, $Res Function(Permission) then) =
      _$PermissionCopyWithImpl<$Res, Permission>;
  @useResult
  $Res call(
      {String id,
      String familyLinkId,
      String grantedTo,
      String grantedBy,
      String permissionType,
      bool isGranted,
      DateTime grantedAt,
      DateTime? revokedAt,
      String? notes});
}

/// @nodoc
class _$PermissionCopyWithImpl<$Res, $Val extends Permission>
    implements $PermissionCopyWith<$Res> {
  _$PermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyLinkId = null,
    Object? grantedTo = null,
    Object? grantedBy = null,
    Object? permissionType = null,
    Object? isGranted = null,
    Object? grantedAt = null,
    Object? revokedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      familyLinkId: null == familyLinkId
          ? _value.familyLinkId
          : familyLinkId // ignore: cast_nullable_to_non_nullable
              as String,
      grantedTo: null == grantedTo
          ? _value.grantedTo
          : grantedTo // ignore: cast_nullable_to_non_nullable
              as String,
      grantedBy: null == grantedBy
          ? _value.grantedBy
          : grantedBy // ignore: cast_nullable_to_non_nullable
              as String,
      permissionType: null == permissionType
          ? _value.permissionType
          : permissionType // ignore: cast_nullable_to_non_nullable
              as String,
      isGranted: null == isGranted
          ? _value.isGranted
          : isGranted // ignore: cast_nullable_to_non_nullable
              as bool,
      grantedAt: null == grantedAt
          ? _value.grantedAt
          : grantedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revokedAt: freezed == revokedAt
          ? _value.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionImplCopyWith<$Res>
    implements $PermissionCopyWith<$Res> {
  factory _$$PermissionImplCopyWith(
          _$PermissionImpl value, $Res Function(_$PermissionImpl) then) =
      __$$PermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String familyLinkId,
      String grantedTo,
      String grantedBy,
      String permissionType,
      bool isGranted,
      DateTime grantedAt,
      DateTime? revokedAt,
      String? notes});
}

/// @nodoc
class __$$PermissionImplCopyWithImpl<$Res>
    extends _$PermissionCopyWithImpl<$Res, _$PermissionImpl>
    implements _$$PermissionImplCopyWith<$Res> {
  __$$PermissionImplCopyWithImpl(
      _$PermissionImpl _value, $Res Function(_$PermissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyLinkId = null,
    Object? grantedTo = null,
    Object? grantedBy = null,
    Object? permissionType = null,
    Object? isGranted = null,
    Object? grantedAt = null,
    Object? revokedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$PermissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      familyLinkId: null == familyLinkId
          ? _value.familyLinkId
          : familyLinkId // ignore: cast_nullable_to_non_nullable
              as String,
      grantedTo: null == grantedTo
          ? _value.grantedTo
          : grantedTo // ignore: cast_nullable_to_non_nullable
              as String,
      grantedBy: null == grantedBy
          ? _value.grantedBy
          : grantedBy // ignore: cast_nullable_to_non_nullable
              as String,
      permissionType: null == permissionType
          ? _value.permissionType
          : permissionType // ignore: cast_nullable_to_non_nullable
              as String,
      isGranted: null == isGranted
          ? _value.isGranted
          : isGranted // ignore: cast_nullable_to_non_nullable
              as bool,
      grantedAt: null == grantedAt
          ? _value.grantedAt
          : grantedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revokedAt: freezed == revokedAt
          ? _value.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionImpl implements _Permission {
  const _$PermissionImpl(
      {required this.id,
      required this.familyLinkId,
      required this.grantedTo,
      required this.grantedBy,
      required this.permissionType,
      required this.isGranted,
      required this.grantedAt,
      this.revokedAt,
      this.notes});

  factory _$PermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionImplFromJson(json);

  @override
  final String id;
  @override
  final String familyLinkId;
  @override
  final String grantedTo;
// childId
  @override
  final String grantedBy;
// parentId
  @override
  final String permissionType;
// 'calendar_view', 'reminder_assign', 'data_access'
  @override
  final bool isGranted;
  @override
  final DateTime grantedAt;
  @override
  final DateTime? revokedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Permission(id: $id, familyLinkId: $familyLinkId, grantedTo: $grantedTo, grantedBy: $grantedBy, permissionType: $permissionType, isGranted: $isGranted, grantedAt: $grantedAt, revokedAt: $revokedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.familyLinkId, familyLinkId) ||
                other.familyLinkId == familyLinkId) &&
            (identical(other.grantedTo, grantedTo) ||
                other.grantedTo == grantedTo) &&
            (identical(other.grantedBy, grantedBy) ||
                other.grantedBy == grantedBy) &&
            (identical(other.permissionType, permissionType) ||
                other.permissionType == permissionType) &&
            (identical(other.isGranted, isGranted) ||
                other.isGranted == isGranted) &&
            (identical(other.grantedAt, grantedAt) ||
                other.grantedAt == grantedAt) &&
            (identical(other.revokedAt, revokedAt) ||
                other.revokedAt == revokedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, familyLinkId, grantedTo,
      grantedBy, permissionType, isGranted, grantedAt, revokedAt, notes);

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      __$$PermissionImplCopyWithImpl<_$PermissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionImplToJson(
      this,
    );
  }
}

abstract class _Permission implements Permission {
  const factory _Permission(
      {required final String id,
      required final String familyLinkId,
      required final String grantedTo,
      required final String grantedBy,
      required final String permissionType,
      required final bool isGranted,
      required final DateTime grantedAt,
      final DateTime? revokedAt,
      final String? notes}) = _$PermissionImpl;

  factory _Permission.fromJson(Map<String, dynamic> json) =
      _$PermissionImpl.fromJson;

  @override
  String get id;
  @override
  String get familyLinkId;
  @override
  String get grantedTo; // childId
  @override
  String get grantedBy; // parentId
  @override
  String
      get permissionType; // 'calendar_view', 'reminder_assign', 'data_access'
  @override
  bool get isGranted;
  @override
  DateTime get grantedAt;
  @override
  DateTime? get revokedAt;
  @override
  String? get notes;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
