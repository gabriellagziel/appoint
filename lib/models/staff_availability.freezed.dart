// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

StaffAvailability _$StaffAvailabilityFromJson(Map<String, dynamic> json) {
  return _StaffAvailability.fromJson(json);
}

/// @nodoc
mixin _$StaffAvailability {
  String get staffId => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get availableFrom => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get availableTo => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  List<TimeOfDay>? get availableSlots => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      @DateTimeConverter() DateTime availableFrom,
      @DateTimeConverter() DateTime availableTo,
      @TimeOfDayConverter() List<TimeOfDay>? availableSlots});
}

/// @nodoc
class _$StaffAvailabilityCopyWithImpl<$Res, $Val extends StaffAvailability>
    implements $StaffAvailabilityCopyWith<$Res> {
  _$StaffAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? staffId = null,
    Object? availableFrom = null,
    Object? availableTo = null,
    Object? availableSlots = freezed,
  }) {
    return _then(_value.copyWith(
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      availableFrom: null == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableTo: null == availableTo
          ? _value.availableTo
          : availableTo // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSlots: freezed == availableSlots
          ? _value.availableSlots
          : availableSlots // ignore: cast_nullable_to_non_nullable
              as List<TimeOfDay>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffAvailabilityImplCopyWith<$Res>
    implements $StaffAvailabilityCopyWith<$Res> {
  factory _$$StaffAvailabilityImplCopyWith(_$StaffAvailabilityImpl value,
          $Res Function(_$StaffAvailabilityImpl) then) =
      __$$REDACTED_TOKEN<$Res>;
  @override
  @useResult
  $Res call(
      {String staffId,
      @DateTimeConverter() DateTime availableFrom,
      @DateTimeConverter() DateTime availableTo,
      @TimeOfDayConverter() List<TimeOfDay>? availableSlots});
}

/// @nodoc
class __$$REDACTED_TOKEN<$Res>
    extends _$StaffAvailabilityCopyWithImpl<$Res, _$StaffAvailabilityImpl>
    implements _$$StaffAvailabilityImplCopyWith<$Res> {
  __$$REDACTED_TOKEN(_$StaffAvailabilityImpl _value,
      $Res Function(_$StaffAvailabilityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? staffId = null,
    Object? availableFrom = null,
    Object? availableTo = null,
    Object? availableSlots = freezed,
  }) {
    return _then(_$StaffAvailabilityImpl(
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      availableFrom: null == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableTo: null == availableTo
          ? _value.availableTo
          : availableTo // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSlots: freezed == availableSlots
          ? _value._availableSlots
          : availableSlots // ignore: cast_nullable_to_non_nullable
              as List<TimeOfDay>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffAvailabilityImpl implements _StaffAvailability {
  const _$StaffAvailabilityImpl(
      {required this.staffId,
      @DateTimeConverter() required this.availableFrom,
      @DateTimeConverter() required this.availableTo,
      @TimeOfDayConverter() final List<TimeOfDay>? availableSlots})
      : _availableSlots = availableSlots;

  factory _$StaffAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffAvailabilityImplFromJson(json);

  @override
  final String staffId;
  @override
  @DateTimeConverter()
  final DateTime availableFrom;
  @override
  @DateTimeConverter()
  final DateTime availableTo;
  final List<TimeOfDay>? _availableSlots;
  @override
  @TimeOfDayConverter()
  List<TimeOfDay>? get availableSlots {
    final value = _availableSlots;
    if (value == null) return null;
    if (_availableSlots is EqualUnmodifiableListView) return _availableSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StaffAvailability(staffId: $staffId, availableFrom: $availableFrom, availableTo: $availableTo, availableSlots: $availableSlots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffAvailabilityImpl &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.availableTo, availableTo) ||
                other.availableTo == availableTo) &&
            const DeepCollectionEquality()
                .equals(other._availableSlots, _availableSlots));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, staffId, availableFrom,
      availableTo, const DeepCollectionEquality().hash(_availableSlots));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffAvailabilityImplCopyWith<_$StaffAvailabilityImpl> get copyWith =>
      __$$REDACTED_TOKEN<_$StaffAvailabilityImpl>(
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
          @DateTimeConverter() required final DateTime availableFrom,
          @DateTimeConverter() required final DateTime availableTo,
          @TimeOfDayConverter() final List<TimeOfDay>? availableSlots}) =
      _$StaffAvailabilityImpl;

  factory _StaffAvailability.fromJson(Map<String, dynamic> json) =
      _$StaffAvailabilityImpl.fromJson;

  @override
  String get staffId;
  @override
  @DateTimeConverter()
  DateTime get availableFrom;
  @override
  @DateTimeConverter()
  DateTime get availableTo;
  @override
  @TimeOfDayConverter()
  List<TimeOfDay>? get availableSlots;
  @override
  @JsonKey(ignore: true)
  _$$StaffAvailabilityImplCopyWith<_$StaffAvailabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
