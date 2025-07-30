// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get staffId => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  @DateTimeConverter()
  @JsonKey(name: 'dateTime')
  DateTime get dateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration')
  Duration get duration => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isConfirmed => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get businessProfileId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String staffId,
            String serviceId,
            String serviceName,
            @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
            @JsonKey(name: 'duration') Duration duration,
            String? notes,
            bool isConfirmed,
            @DateTimeConverter() DateTime? createdAt,
            String? businessProfileId)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String userId,
            String staffId,
            String serviceId,
            String serviceName,
            @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
            @JsonKey(name: 'duration') Duration duration,
            String? notes,
            bool isConfirmed,
            @DateTimeConverter() DateTime? createdAt,
            String? businessProfileId)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String staffId,
            String serviceId,
            String serviceName,
            @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
            @JsonKey(name: 'duration') Duration duration,
            String? notes,
            bool isConfirmed,
            @DateTimeConverter() DateTime? createdAt,
            String? businessProfileId)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String staffId,
      String serviceId,
      String serviceName,
      @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
      @JsonKey(name: 'duration') Duration duration,
      String? notes,
      bool isConfirmed,
      @DateTimeConverter() DateTime? createdAt,
      String? businessProfileId});
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? staffId = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? dateTime = null,
    Object? duration = null,
    Object? notes = freezed,
    Object? isConfirmed = null,
    Object? createdAt = freezed,
    Object? businessProfileId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      businessProfileId: freezed == businessProfileId
          ? _value.businessProfileId
          : businessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
          _$BookingImpl value, $Res Function(_$BookingImpl) then) =
      __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String staffId,
      String serviceId,
      String serviceName,
      @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
      @JsonKey(name: 'duration') Duration duration,
      String? notes,
      bool isConfirmed,
      @DateTimeConverter() DateTime? createdAt,
      String? businessProfileId});
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
      _$BookingImpl _value, $Res Function(_$BookingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? staffId = null,
    Object? serviceId = null,
    Object? serviceName = null,
    Object? dateTime = null,
    Object? duration = null,
    Object? notes = freezed,
    Object? isConfirmed = null,
    Object? createdAt = freezed,
    Object? businessProfileId = freezed,
  }) {
    return _then(_$BookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      businessProfileId: freezed == businessProfileId
          ? _value.businessProfileId
          : businessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$BookingImpl implements _Booking {
  const _$BookingImpl(
      {required this.id,
      required this.userId,
      required this.staffId,
      required this.serviceId,
      required this.serviceName,
      @DateTimeConverter() @JsonKey(name: 'dateTime') required this.dateTime,
      @JsonKey(name: 'duration') required this.duration,
      this.notes,
      this.isConfirmed = false,
      @DateTimeConverter() this.createdAt,
      this.businessProfileId});

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String staffId;
  @override
  final String serviceId;
  @override
  final String serviceName;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'dateTime')
  final DateTime dateTime;
  @override
  @JsonKey(name: 'duration')
  final Duration duration;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isConfirmed;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  final String? businessProfileId;

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, staffId: $staffId, serviceId: $serviceId, serviceName: $serviceName, dateTime: $dateTime, duration: $duration, notes: $notes, isConfirmed: $isConfirmed, createdAt: $createdAt, businessProfileId: $businessProfileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isConfirmed, isConfirmed) ||
                other.isConfirmed == isConfirmed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.businessProfileId, businessProfileId) ||
                other.businessProfileId == businessProfileId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      staffId,
      serviceId,
      serviceName,
      dateTime,
      duration,
      notes,
      isConfirmed,
      createdAt,
      businessProfileId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String staffId,
            String serviceId,
            String serviceName,
            @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
            @JsonKey(name: 'duration') Duration duration,
            String? notes,
            bool isConfirmed,
            @DateTimeConverter() DateTime? createdAt,
            String? businessProfileId)
        $default,
  ) {
    return $default(id, userId, staffId, serviceId, serviceName, dateTime,
        duration, notes, isConfirmed, createdAt, businessProfileId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String userId,
            String staffId,
            String serviceId,
            String serviceName,
            @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
            @JsonKey(name: 'duration') Duration duration,
            String? notes,
            bool isConfirmed,
            @DateTimeConverter() DateTime? createdAt,
            String? businessProfileId)?
        $default,
  ) {
    return $default?.call(id, userId, staffId, serviceId, serviceName, dateTime,
        duration, notes, isConfirmed, createdAt, businessProfileId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String staffId,
            String serviceId,
            String serviceName,
            @DateTimeConverter() @JsonKey(name: 'dateTime') DateTime dateTime,
            @JsonKey(name: 'duration') Duration duration,
            String? notes,
            bool isConfirmed,
            @DateTimeConverter() DateTime? createdAt,
            String? businessProfileId)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, userId, staffId, serviceId, serviceName, dateTime,
          duration, notes, isConfirmed, createdAt, businessProfileId);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(
      this,
    );
  }
}

abstract class _Booking implements Booking {
  const factory _Booking(
      {required final String id,
      required final String userId,
      required final String staffId,
      required final String serviceId,
      required final String serviceName,
      @DateTimeConverter()
      @JsonKey(name: 'dateTime')
      required final DateTime dateTime,
      @JsonKey(name: 'duration') required final Duration duration,
      final String? notes,
      final bool isConfirmed,
      @DateTimeConverter() final DateTime? createdAt,
      final String? businessProfileId}) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get staffId;
  @override
  String get serviceId;
  @override
  String get serviceName;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'dateTime')
  DateTime get dateTime;
  @override
  @JsonKey(name: 'duration')
  Duration get duration;
  @override
  String? get notes;
  @override
  bool get isConfirmed;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  String? get businessProfileId;
  @override
  @JsonKey(ignore: true)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
