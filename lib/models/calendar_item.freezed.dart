// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CalendarItem _$CalendarItemFromJson(Map<String, dynamic> json) {
  return _CalendarItem.fromJson(json);
}

/// @nodoc
mixin _$CalendarItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String? get assigneeId => throw _privateConstructorUsedError;
  String? get familyId => throw _privateConstructorUsedError;
  String get visibility =>
      throw _privateConstructorUsedError; // 'private', 'family'
  String get type =>
      throw _privateConstructorUsedError; // 'meeting', 'reminder'
  String? get location => throw _privateConstructorUsedError;
  List<String>? get attendees => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CalendarItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarItemCopyWith<CalendarItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarItemCopyWith<$Res> {
  factory $CalendarItemCopyWith(
          CalendarItem value, $Res Function(CalendarItem) then) =
      _$CalendarItemCopyWithImpl<$Res, CalendarItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      DateTime startTime,
      DateTime endTime,
      String ownerId,
      String? assigneeId,
      String? familyId,
      String visibility,
      String type,
      String? location,
      List<String>? attendees,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CalendarItemCopyWithImpl<$Res, $Val extends CalendarItem>
    implements $CalendarItemCopyWith<$Res> {
  _$CalendarItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? ownerId = null,
    Object? assigneeId = freezed,
    Object? familyId = freezed,
    Object? visibility = null,
    Object? type = null,
    Object? location = freezed,
    Object? attendees = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      assigneeId: freezed == assigneeId
          ? _value.assigneeId
          : assigneeId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      attendees: freezed == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarItemImplCopyWith<$Res>
    implements $CalendarItemCopyWith<$Res> {
  factory _$$CalendarItemImplCopyWith(
          _$CalendarItemImpl value, $Res Function(_$CalendarItemImpl) then) =
      __$$CalendarItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      DateTime startTime,
      DateTime endTime,
      String ownerId,
      String? assigneeId,
      String? familyId,
      String visibility,
      String type,
      String? location,
      List<String>? attendees,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$CalendarItemImplCopyWithImpl<$Res>
    extends _$CalendarItemCopyWithImpl<$Res, _$CalendarItemImpl>
    implements _$$CalendarItemImplCopyWith<$Res> {
  __$$CalendarItemImplCopyWithImpl(
      _$CalendarItemImpl _value, $Res Function(_$CalendarItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? ownerId = null,
    Object? assigneeId = freezed,
    Object? familyId = freezed,
    Object? visibility = null,
    Object? type = null,
    Object? location = freezed,
    Object? attendees = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CalendarItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      assigneeId: freezed == assigneeId
          ? _value.assigneeId
          : assigneeId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      attendees: freezed == attendees
          ? _value._attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarItemImpl implements _CalendarItem {
  const _$CalendarItemImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.startTime,
      required this.endTime,
      required this.ownerId,
      this.assigneeId,
      this.familyId,
      required this.visibility,
      required this.type,
      this.location,
      final List<String>? attendees,
      this.notes,
      this.createdAt,
      this.updatedAt})
      : _attendees = attendees;

  factory _$CalendarItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String ownerId;
  @override
  final String? assigneeId;
  @override
  final String? familyId;
  @override
  final String visibility;
// 'private', 'family'
  @override
  final String type;
// 'meeting', 'reminder'
  @override
  final String? location;
  final List<String>? _attendees;
  @override
  List<String>? get attendees {
    final value = _attendees;
    if (value == null) return null;
    if (_attendees is EqualUnmodifiableListView) return _attendees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CalendarItem(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, ownerId: $ownerId, assigneeId: $assigneeId, familyId: $familyId, visibility: $visibility, type: $type, location: $location, attendees: $attendees, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.assigneeId, assigneeId) ||
                other.assigneeId == assigneeId) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._attendees, _attendees) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      startTime,
      endTime,
      ownerId,
      assigneeId,
      familyId,
      visibility,
      type,
      location,
      const DeepCollectionEquality().hash(_attendees),
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarItemImplCopyWith<_$CalendarItemImpl> get copyWith =>
      __$$CalendarItemImplCopyWithImpl<_$CalendarItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarItemImplToJson(
      this,
    );
  }
}

abstract class _CalendarItem implements CalendarItem {
  const factory _CalendarItem(
      {required final String id,
      required final String title,
      required final String description,
      required final DateTime startTime,
      required final DateTime endTime,
      required final String ownerId,
      final String? assigneeId,
      final String? familyId,
      required final String visibility,
      required final String type,
      final String? location,
      final List<String>? attendees,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$CalendarItemImpl;

  factory _CalendarItem.fromJson(Map<String, dynamic> json) =
      _$CalendarItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get ownerId;
  @override
  String? get assigneeId;
  @override
  String? get familyId;
  @override
  String get visibility; // 'private', 'family'
  @override
  String get type; // 'meeting', 'reminder'
  @override
  String? get location;
  @override
  List<String>? get attendees;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarItemImplCopyWith<_$CalendarItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
