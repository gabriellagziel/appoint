// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffAvailability _$StaffAvailabilityFromJson(Map<String, dynamic> json) {
  return _StaffAvailability.fromJson(json);
}

/// @nodoc
mixin _$StaffAvailability {
  String get staffId => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get date => throw _privateConstructorUsedError;
  List<String>? get availableSlots => throw _privateConstructorUsedError;

  /// Serializes this StaffAvailability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffAvailabilityCopyWith<StaffAvailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffAvailabilityCopyWith<$Res> {
  factory $StaffAvailabilityCopyWith(
          StaffAvailability value, $Res Function(StaffAvailability) then) =
      _$StaffAvailabilityCopyWithImpl<$Res, StaffAvailability>;
  @useResult
  $Res call(
      {String staffId,
      @DateTimeConverter() DateTime date,
      List<String>? availableSlots});
}

/// @nodoc
class _$StaffAvailabilityCopyWithImpl<$Res, $Val extends StaffAvailability>
    implements $StaffAvailabilityCopyWith<$Res> {
  _$StaffAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? staffId = null,
    Object? date = null,
    Object? availableSlots = freezed,
  }) {
    return _then(_value.copyWith(
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSlots: freezed == availableSlots
          ? _value.availableSlots
          : availableSlots // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffAvailabilityImplCopyWith<$Res>
    implements $StaffAvailabilityCopyWith<$Res> {
  factory _$$StaffAvailabilityImplCopyWith(_$StaffAvailabilityImpl value,
          $Res Function(_$StaffAvailabilityImpl) then) =
      __$$StaffAvailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String staffId,
      @DateTimeConverter() DateTime date,
      List<String>? availableSlots});
}

/// @nodoc
class __$$StaffAvailabilityImplCopyWithImpl<$Res>
    extends _$StaffAvailabilityCopyWithImpl<$Res, _$StaffAvailabilityImpl>
    implements _$$StaffAvailabilityImplCopyWith<$Res> {
  __$$StaffAvailabilityImplCopyWithImpl(_$StaffAvailabilityImpl _value,
      $Res Function(_$StaffAvailabilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of StaffAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? staffId = null,
    Object? date = null,
    Object? availableSlots = freezed,
  }) {
    return _then(_$StaffAvailabilityImpl(
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSlots: freezed == availableSlots
          ? _value._availableSlots
          : availableSlots // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffAvailabilityImpl implements _StaffAvailability {
  const _$StaffAvailabilityImpl(
      {required this.staffId,
      @DateTimeConverter() required this.date,
      final List<String>? availableSlots})
      : _availableSlots = availableSlots;

  factory _$StaffAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffAvailabilityImplFromJson(json);

  @override
  final String staffId;
  @override
  @DateTimeConverter()
  final DateTime date;
  final List<String>? _availableSlots;
  @override
  List<String>? get availableSlots {
    final value = _availableSlots;
    if (value == null) return null;
    if (_availableSlots is EqualUnmodifiableListView) return _availableSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StaffAvailability(staffId: $staffId, date: $date, availableSlots: $availableSlots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffAvailabilityImpl &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._availableSlots, _availableSlots));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, staffId, date,
      const DeepCollectionEquality().hash(_availableSlots));

  /// Create a copy of StaffAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffAvailabilityImplCopyWith<_$StaffAvailabilityImpl> get copyWith =>
      __$$StaffAvailabilityImplCopyWithImpl<_$StaffAvailabilityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffAvailabilityImplToJson(
      this,
    );
  }
}

abstract class _StaffAvailability implements StaffAvailability {
  const factory _StaffAvailability(
      {required final String staffId,
      @DateTimeConverter() required final DateTime date,
      final List<String>? availableSlots}) = _$StaffAvailabilityImpl;

  factory _StaffAvailability.fromJson(Map<String, dynamic> json) =
      _$StaffAvailabilityImpl.fromJson;

  @override
  String get staffId;
  @override
  @DateTimeConverter()
  DateTime get date;
  @override
  List<String>? get availableSlots;

  /// Create a copy of StaffAvailability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffAvailabilityImplCopyWith<_$StaffAvailabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
