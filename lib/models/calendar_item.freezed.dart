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
  DateTime get startAt => throw _privateConstructorUsedError;
  DateTime? get endAt => throw _privateConstructorUsedError;
  CalendarItemType get type => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError; // who created
  String? get assigneeId =>
      throw _privateConstructorUsedError; // who it's for (nullable)
  String? get familyId =>
      throw _privateConstructorUsedError; // family context (nullable)
  CalendarVisibility get visibility => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool? get isCompleted => throw _privateConstructorUsedError;

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
      DateTime startAt,
      DateTime? endAt,
      CalendarItemType type,
      String ownerId,
      String? assigneeId,
      String? familyId,
      CalendarVisibility visibility,
      Map<String, dynamic>? metadata,
      bool? isCompleted});
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
    Object? startAt = null,
    Object? endAt = freezed,
    Object? type = null,
    Object? ownerId = null,
    Object? assigneeId = freezed,
    Object? familyId = freezed,
    Object? visibility = null,
    Object? metadata = freezed,
    Object? isCompleted = freezed,
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
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CalendarItemType,
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
              as CalendarVisibility,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      DateTime startAt,
      DateTime? endAt,
      CalendarItemType type,
      String ownerId,
      String? assigneeId,
      String? familyId,
      CalendarVisibility visibility,
      Map<String, dynamic>? metadata,
      bool? isCompleted});
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
    Object? startAt = null,
    Object? endAt = freezed,
    Object? type = null,
    Object? ownerId = null,
    Object? assigneeId = freezed,
    Object? familyId = freezed,
    Object? visibility = null,
    Object? metadata = freezed,
    Object? isCompleted = freezed,
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
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CalendarItemType,
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
              as CalendarVisibility,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      required this.startAt,
      this.endAt,
      required this.type,
      required this.ownerId,
      this.assigneeId,
      this.familyId,
      required this.visibility,
      final Map<String, dynamic>? metadata,
      this.isCompleted})
      : _metadata = metadata;

  factory _$CalendarItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime startAt;
  @override
  final DateTime? endAt;
  @override
  final CalendarItemType type;
  @override
  final String ownerId;
// who created
  @override
  final String? assigneeId;
// who it's for (nullable)
  @override
  final String? familyId;
// family context (nullable)
  @override
  final CalendarVisibility visibility;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isCompleted;

  @override
  String toString() {
    return 'CalendarItem(id: $id, title: $title, description: $description, startAt: $startAt, endAt: $endAt, type: $type, ownerId: $ownerId, assigneeId: $assigneeId, familyId: $familyId, visibility: $visibility, metadata: $metadata, isCompleted: $isCompleted)';
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
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.assigneeId, assigneeId) ||
                other.assigneeId == assigneeId) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      startAt,
      endAt,
      type,
      ownerId,
      assigneeId,
      familyId,
      visibility,
      const DeepCollectionEquality().hash(_metadata),
      isCompleted);

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
      required final DateTime startAt,
      final DateTime? endAt,
      required final CalendarItemType type,
      required final String ownerId,
      final String? assigneeId,
      final String? familyId,
      required final CalendarVisibility visibility,
      final Map<String, dynamic>? metadata,
      final bool? isCompleted}) = _$CalendarItemImpl;

  factory _CalendarItem.fromJson(Map<String, dynamic> json) =
      _$CalendarItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get startAt;
  @override
  DateTime? get endAt;
  @override
  CalendarItemType get type;
  @override
  String get ownerId; // who created
  @override
  String? get assigneeId; // who it's for (nullable)
  @override
  String? get familyId; // family context (nullable)
  @override
  CalendarVisibility get visibility;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool? get isCompleted;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarItemImplCopyWith<_$CalendarItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FamilyFilterState {
  FamilyFilter get filter => throw _privateConstructorUsedError;
  String? get selectedChildId => throw _privateConstructorUsedError;

  /// Create a copy of FamilyFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyFilterStateCopyWith<FamilyFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyFilterStateCopyWith<$Res> {
  factory $FamilyFilterStateCopyWith(
          FamilyFilterState value, $Res Function(FamilyFilterState) then) =
      _$FamilyFilterStateCopyWithImpl<$Res, FamilyFilterState>;
  @useResult
  $Res call({FamilyFilter filter, String? selectedChildId});
}

/// @nodoc
class _$FamilyFilterStateCopyWithImpl<$Res, $Val extends FamilyFilterState>
    implements $FamilyFilterStateCopyWith<$Res> {
  _$FamilyFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
    Object? selectedChildId = freezed,
  }) {
    return _then(_value.copyWith(
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as FamilyFilter,
      selectedChildId: freezed == selectedChildId
          ? _value.selectedChildId
          : selectedChildId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyFilterStateImplCopyWith<$Res>
    implements $FamilyFilterStateCopyWith<$Res> {
  factory _$$FamilyFilterStateImplCopyWith(_$FamilyFilterStateImpl value,
          $Res Function(_$FamilyFilterStateImpl) then) =
      __$$FamilyFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FamilyFilter filter, String? selectedChildId});
}

/// @nodoc
class __$$FamilyFilterStateImplCopyWithImpl<$Res>
    extends _$FamilyFilterStateCopyWithImpl<$Res, _$FamilyFilterStateImpl>
    implements _$$FamilyFilterStateImplCopyWith<$Res> {
  __$$FamilyFilterStateImplCopyWithImpl(_$FamilyFilterStateImpl _value,
      $Res Function(_$FamilyFilterStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
    Object? selectedChildId = freezed,
  }) {
    return _then(_$FamilyFilterStateImpl(
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as FamilyFilter,
      selectedChildId: freezed == selectedChildId
          ? _value.selectedChildId
          : selectedChildId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FamilyFilterStateImpl implements _FamilyFilterState {
  const _$FamilyFilterStateImpl({required this.filter, this.selectedChildId});

  @override
  final FamilyFilter filter;
  @override
  final String? selectedChildId;

  @override
  String toString() {
    return 'FamilyFilterState(filter: $filter, selectedChildId: $selectedChildId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyFilterStateImpl &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.selectedChildId, selectedChildId) ||
                other.selectedChildId == selectedChildId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter, selectedChildId);

  /// Create a copy of FamilyFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyFilterStateImplCopyWith<_$FamilyFilterStateImpl> get copyWith =>
      __$$FamilyFilterStateImplCopyWithImpl<_$FamilyFilterStateImpl>(
          this, _$identity);
}

abstract class _FamilyFilterState implements FamilyFilterState {
  const factory _FamilyFilterState(
      {required final FamilyFilter filter,
      final String? selectedChildId}) = _$FamilyFilterStateImpl;

  @override
  FamilyFilter get filter;
  @override
  String? get selectedChildId;

  /// Create a copy of FamilyFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyFilterStateImplCopyWith<_$FamilyFilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
