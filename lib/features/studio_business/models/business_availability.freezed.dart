// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessAvailability _$BusinessAvailabilityFromJson(Map<String, dynamic> json) {
  return _BusinessAvailability.fromJson(json);
}

/// @nodoc
mixin _$BusinessAvailability {
  int get weekday =>
      throw _privateConstructorUsedError; // 0-6 (Sunday-Saturday)
  bool get isOpen => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get start => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get end => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int weekday,
            bool isOpen,
            @TimeOfDayConverter() TimeOfDay start,
            @TimeOfDayConverter() TimeOfDay end)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int weekday,
            bool isOpen,
            @TimeOfDayConverter() TimeOfDay start,
            @TimeOfDayConverter() TimeOfDay end)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int weekday,
            bool isOpen,
            @TimeOfDayConverter() TimeOfDay start,
            @TimeOfDayConverter() TimeOfDay end)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessAvailabilityCopyWith<BusinessAvailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessAvailabilityCopyWith<$Res> {
  factory $BusinessAvailabilityCopyWith(BusinessAvailability value,
          $Res Function(BusinessAvailability) then) =
      _$BusinessAvailabilityCopyWithImpl<$Res, BusinessAvailability>;
  @useResult
  $Res call(
      {int weekday,
      bool isOpen,
      @TimeOfDayConverter() TimeOfDay start,
      @TimeOfDayConverter() TimeOfDay end});
}

/// @nodoc
class _$BusinessAvailabilityCopyWithImpl<$Res,
        $Val extends BusinessAvailability>
    implements $BusinessAvailabilityCopyWith<$Res> {
  _$BusinessAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekday = null,
    Object? isOpen = null,
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      weekday: null == weekday
          ? _value.weekday
          : weekday // ignore: cast_nullable_to_non_nullable
              as int,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessAvailabilityImplCopyWith<$Res>
    implements $BusinessAvailabilityCopyWith<$Res> {
  factory _$$BusinessAvailabilityImplCopyWith(_$BusinessAvailabilityImpl value,
          $Res Function(_$BusinessAvailabilityImpl) then) =
      __$$BusinessAvailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int weekday,
      bool isOpen,
      @TimeOfDayConverter() TimeOfDay start,
      @TimeOfDayConverter() TimeOfDay end});
}

/// @nodoc
class __$$BusinessAvailabilityImplCopyWithImpl<$Res>
    extends _$BusinessAvailabilityCopyWithImpl<$Res, _$BusinessAvailabilityImpl>
    implements _$$BusinessAvailabilityImplCopyWith<$Res> {
  __$$BusinessAvailabilityImplCopyWithImpl(_$BusinessAvailabilityImpl _value,
      $Res Function(_$BusinessAvailabilityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekday = null,
    Object? isOpen = null,
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$BusinessAvailabilityImpl(
      weekday: null == weekday
          ? _value.weekday
          : weekday // ignore: cast_nullable_to_non_nullable
              as int,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessAvailabilityImpl implements _BusinessAvailability {
  const _$BusinessAvailabilityImpl(
      {required this.weekday,
      required this.isOpen,
      @TimeOfDayConverter() required this.start,
      @TimeOfDayConverter() required this.end});

  factory _$BusinessAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessAvailabilityImplFromJson(json);

  @override
  final int weekday;
// 0-6 (Sunday-Saturday)
  @override
  final bool isOpen;
  @override
  @TimeOfDayConverter()
  final TimeOfDay start;
  @override
  @TimeOfDayConverter()
  final TimeOfDay end;

  @override
  String toString() {
    return 'BusinessAvailability(weekday: $weekday, isOpen: $isOpen, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessAvailabilityImpl &&
            (identical(other.weekday, weekday) || other.weekday == weekday) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, weekday, isOpen, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessAvailabilityImplCopyWith<_$BusinessAvailabilityImpl>
      get copyWith =>
          __$$BusinessAvailabilityImplCopyWithImpl<_$BusinessAvailabilityImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int weekday,
            bool isOpen,
            @TimeOfDayConverter() TimeOfDay start,
            @TimeOfDayConverter() TimeOfDay end)
        $default,
  ) {
    return $default(weekday, isOpen, start, end);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int weekday,
            bool isOpen,
            @TimeOfDayConverter() TimeOfDay start,
            @TimeOfDayConverter() TimeOfDay end)?
        $default,
  ) {
    return $default?.call(weekday, isOpen, start, end);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int weekday,
            bool isOpen,
            @TimeOfDayConverter() TimeOfDay start,
            @TimeOfDayConverter() TimeOfDay end)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(weekday, isOpen, start, end);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessAvailabilityImplToJson(
      this,
    );
  }
}

abstract class _BusinessAvailability implements BusinessAvailability {
  const factory _BusinessAvailability(
          {required final int weekday,
          required final bool isOpen,
          @TimeOfDayConverter() required final TimeOfDay start,
          @TimeOfDayConverter() required final TimeOfDay end}) =
      _$BusinessAvailabilityImpl;

  factory _BusinessAvailability.fromJson(Map<String, dynamic> json) =
      _$BusinessAvailabilityImpl.fromJson;

  @override
  int get weekday;
  @override // 0-6 (Sunday-Saturday)
  bool get isOpen;
  @override
  @TimeOfDayConverter()
  TimeOfDay get start;
  @override
  @TimeOfDayConverter()
  TimeOfDay get end;
  @override
  @JsonKey(ignore: true)
  _$$BusinessAvailabilityImplCopyWith<_$BusinessAvailabilityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
