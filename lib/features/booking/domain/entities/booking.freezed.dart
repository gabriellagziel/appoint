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
    'It seems like you constructed this class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({String id, DateTime startTime, DateTime endTime});
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
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$_BookingCopyWith(
          _$_Booking value, $Res Function(_$_Booking) then) =
      __$$_BookingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime startTime, DateTime endTime});
}

/// @nodoc
class __$$_BookingCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$_Booking>
    implements _$$_BookingCopyWith<$Res> {
  __$$_BookingCopyWithImpl(_$_Booking _value, $Res Function(_$_Booking) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$_Booking(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_Booking implements _Booking {
  const _$_Booking({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;

  @override
  String toString() {
    return 'Booking(id: $id, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Booking &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BookingCopyWith<_$_Booking> get copyWith =>
      __$$_BookingCopyWithImpl<_$_Booking>(this, _$identity);
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final String id,
    required final DateTime startTime,
    required final DateTime endTime,
  }) = _$_Booking;

  @override
  String get id;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  @JsonKey(ignore: true)
  _$$_BookingCopyWith<_$_Booking> get copyWith =>
      throw _privateConstructorUsedError;
}
