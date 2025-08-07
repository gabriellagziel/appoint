// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

Reminder _$ReminderFromJson(Map<String, dynamic> json) {
  return _Reminder.fromJson(json);
}

/// @nodoc
mixin _$Reminder {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get scheduledAt => throw _privateConstructorUsedError;
  String get ownerId =>
      throw _privateConstructorUsedError; // who created the reminder
  String? get assigneeId =>
      throw _privateConstructorUsedError; // who the reminder is for (nullable)
  String? get familyId =>
      throw _privateConstructorUsedError; // family context (nullable)
  ReminderType get type => throw _privateConstructorUsedError;
  ReminderRecurrence get recurrence => throw _privateConstructorUsedError;
  bool? get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Reminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderCopyWith<Reminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderCopyWith<$Res> {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) then) =
      _$ReminderCopyWithImpl<$Res, Reminder>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      DateTime scheduledAt,
      String ownerId,
      String? assigneeId,
      String? familyId,
      ReminderType type,
      ReminderRecurrence recurrence,
      bool? isCompleted,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$ReminderCopyWithImpl<$Res, $Val extends Reminder>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? scheduledAt = null,
    Object? ownerId = null,
    Object? assigneeId = freezed,
    Object? familyId = freezed,
    Object? type = null,
    Object? recurrence = null,
    Object? isCompleted = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
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
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      recurrence: null == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as ReminderRecurrence,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReminderImplCopyWith<$Res>
    implements $ReminderCopyWith<$Res> {
  factory _$$ReminderImplCopyWith(
          _$ReminderImpl value, $Res Function(_$ReminderImpl) then) =
      __$$ReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      DateTime scheduledAt,
      String ownerId,
      String? assigneeId,
      String? familyId,
      ReminderType type,
      ReminderRecurrence recurrence,
      bool? isCompleted,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$ReminderImplCopyWithImpl<$Res>
    extends _$ReminderCopyWithImpl<$Res, _$ReminderImpl>
    implements _$$ReminderImplCopyWith<$Res> {
  __$$ReminderImplCopyWithImpl(
      _$ReminderImpl _value, $Res Function(_$ReminderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? scheduledAt = null,
    Object? ownerId = null,
    Object? assigneeId = freezed,
    Object? familyId = freezed,
    Object? type = null,
    Object? recurrence = null,
    Object? isCompleted = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ReminderImpl(
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
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      recurrence: null == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as ReminderRecurrence,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReminderImpl implements _Reminder {
  const _$ReminderImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.scheduledAt,
      required this.ownerId,
      this.assigneeId,
      this.familyId,
      required this.type,
      required this.recurrence,
      this.isCompleted,
      this.completedAt,
      this.createdAt,
      this.updatedAt,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$ReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime scheduledAt;
  @override
  final String ownerId;
// who created the reminder
  @override
  final String? assigneeId;
// who the reminder is for (nullable)
  @override
  final String? familyId;
// family context (nullable)
  @override
  final ReminderType type;
  @override
  final ReminderRecurrence recurrence;
  @override
  final bool? isCompleted;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
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
  String toString() {
    return 'Reminder(id: $id, title: $title, description: $description, scheduledAt: $scheduledAt, ownerId: $ownerId, assigneeId: $assigneeId, familyId: $familyId, type: $type, recurrence: $recurrence, isCompleted: $isCompleted, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.assigneeId, assigneeId) ||
                other.assigneeId == assigneeId) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      scheduledAt,
      ownerId,
      assigneeId,
      familyId,
      type,
      recurrence,
      isCompleted,
      completedAt,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      __$$ReminderImplCopyWithImpl<_$ReminderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderImplToJson(
      this,
    );
  }
}

abstract class _Reminder implements Reminder {
  const factory _Reminder(
      {required final String id,
      required final String title,
      required final String description,
      required final DateTime scheduledAt,
      required final String ownerId,
      final String? assigneeId,
      final String? familyId,
      required final ReminderType type,
      required final ReminderRecurrence recurrence,
      final bool? isCompleted,
      final DateTime? completedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final Map<String, dynamic>? metadata}) = _$ReminderImpl;

  factory _Reminder.fromJson(Map<String, dynamic> json) =
      _$ReminderImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get scheduledAt;
  @override
  String get ownerId; // who created the reminder
  @override
  String? get assigneeId; // who the reminder is for (nullable)
  @override
  String? get familyId; // family context (nullable)
  @override
  ReminderType get type;
  @override
  ReminderRecurrence get recurrence;
  @override
  bool? get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReminderAssigneeOption {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  ReminderAssigneeType get type => throw _privateConstructorUsedError;
  bool? get isAvailable => throw _privateConstructorUsedError;

  /// Create a copy of ReminderAssigneeOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderAssigneeOptionCopyWith<ReminderAssigneeOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderAssigneeOptionCopyWith<$Res> {
  factory $ReminderAssigneeOptionCopyWith(ReminderAssigneeOption value,
          $Res Function(ReminderAssigneeOption) then) =
      _$REDACTED_TOKEN<$Res, ReminderAssigneeOption>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      ReminderAssigneeType type,
      bool? isAvailable});
}

/// @nodoc
class _$REDACTED_TOKEN<$Res,
        $Val extends ReminderAssigneeOption>
    implements $ReminderAssigneeOptionCopyWith<$Res> {
  _$REDACTED_TOKEN(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderAssigneeOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? type = null,
    Object? isAvailable = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderAssigneeType,
      isAvailable: freezed == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$REDACTED_TOKEN<$Res>
    implements $ReminderAssigneeOptionCopyWith<$Res> {
  factory _$$REDACTED_TOKEN(
          _$ReminderAssigneeOptionImpl value,
          $Res Function(_$ReminderAssigneeOptionImpl) then) =
      __$$REDACTED_TOKEN<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      ReminderAssigneeType type,
      bool? isAvailable});
}

/// @nodoc
class __$$REDACTED_TOKEN<$Res>
    extends _$REDACTED_TOKEN<$Res,
        _$ReminderAssigneeOptionImpl>
    implements _$$REDACTED_TOKEN<$Res> {
  __$$REDACTED_TOKEN(
      _$ReminderAssigneeOptionImpl _value,
      $Res Function(_$ReminderAssigneeOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReminderAssigneeOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? type = null,
    Object? isAvailable = freezed,
  }) {
    return _then(_$ReminderAssigneeOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderAssigneeType,
      isAvailable: freezed == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$ReminderAssigneeOptionImpl implements _ReminderAssigneeOption {
  const _$ReminderAssigneeOptionImpl(
      {required this.id,
      required this.displayName,
      required this.type,
      this.isAvailable});

  @override
  final String id;
  @override
  final String displayName;
  @override
  final ReminderAssigneeType type;
  @override
  final bool? isAvailable;

  @override
  String toString() {
    return 'ReminderAssigneeOption(id: $id, displayName: $displayName, type: $type, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderAssigneeOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, displayName, type, isAvailable);

  /// Create a copy of ReminderAssigneeOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$REDACTED_TOKEN<_$ReminderAssigneeOptionImpl>
      get copyWith => __$$REDACTED_TOKEN<
          _$ReminderAssigneeOptionImpl>(this, _$identity);
}

abstract class _ReminderAssigneeOption implements ReminderAssigneeOption {
  const factory _ReminderAssigneeOption(
      {required final String id,
      required final String displayName,
      required final ReminderAssigneeType type,
      final bool? isAvailable}) = _$ReminderAssigneeOptionImpl;

  @override
  String get id;
  @override
  String get displayName;
  @override
  ReminderAssigneeType get type;
  @override
  bool? get isAvailable;

  /// Create a copy of ReminderAssigneeOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$REDACTED_TOKEN<_$ReminderAssigneeOptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
