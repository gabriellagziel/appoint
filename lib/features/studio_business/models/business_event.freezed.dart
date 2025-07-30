// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessEvent _$BusinessEventFromJson(Map<String, dynamic> json) {
  return _BusinessEvent.fromJson(json);
}

/// @nodoc
mixin _$BusinessEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get startTime => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get endTime => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String title,
            String description,
            String type,
            @DateTimeConverter() DateTime startTime,
            @DateTimeConverter() DateTime endTime)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String title,
            String description,
            String type,
            @DateTimeConverter() DateTime startTime,
            @DateTimeConverter() DateTime endTime)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String title,
            String description,
            String type,
            @DateTimeConverter() DateTime startTime,
            @DateTimeConverter() DateTime endTime)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessEventCopyWith<BusinessEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessEventCopyWith<$Res> {
  factory $BusinessEventCopyWith(
          BusinessEvent value, $Res Function(BusinessEvent) then) =
      _$BusinessEventCopyWithImpl<$Res, BusinessEvent>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String type,
      @DateTimeConverter() DateTime startTime,
      @DateTimeConverter() DateTime endTime});
}

/// @nodoc
class _$BusinessEventCopyWithImpl<$Res, $Val extends BusinessEvent>
    implements $BusinessEventCopyWith<$Res> {
  _$BusinessEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BusinessEventImplCopyWith<$Res>
    implements $BusinessEventCopyWith<$Res> {
  factory _$$BusinessEventImplCopyWith(
          _$BusinessEventImpl value, $Res Function(_$BusinessEventImpl) then) =
      __$$BusinessEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String type,
      @DateTimeConverter() DateTime startTime,
      @DateTimeConverter() DateTime endTime});
}

/// @nodoc
class __$$BusinessEventImplCopyWithImpl<$Res>
    extends _$BusinessEventCopyWithImpl<$Res, _$BusinessEventImpl>
    implements _$$BusinessEventImplCopyWith<$Res> {
  __$$BusinessEventImplCopyWithImpl(
      _$BusinessEventImpl _value, $Res Function(_$BusinessEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$BusinessEventImpl(
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$BusinessEventImpl implements _BusinessEvent {
  const _$BusinessEventImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.type,
      @DateTimeConverter() required this.startTime,
      @DateTimeConverter() required this.endTime});

  factory _$BusinessEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String type;
  @override
  @DateTimeConverter()
  final DateTime startTime;
  @override
  @DateTimeConverter()
  final DateTime endTime;

  @override
  String toString() {
    return 'BusinessEvent(id: $id, title: $title, description: $description, type: $type, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, description, type, startTime, endTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessEventImplCopyWith<_$BusinessEventImpl> get copyWith =>
      __$$BusinessEventImplCopyWithImpl<_$BusinessEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String title,
            String description,
            String type,
            @DateTimeConverter() DateTime startTime,
            @DateTimeConverter() DateTime endTime)
        $default,
  ) {
    return $default(id, title, description, type, startTime, endTime);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String title,
            String description,
            String type,
            @DateTimeConverter() DateTime startTime,
            @DateTimeConverter() DateTime endTime)?
        $default,
  ) {
    return $default?.call(id, title, description, type, startTime, endTime);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String title,
            String description,
            String type,
            @DateTimeConverter() DateTime startTime,
            @DateTimeConverter() DateTime endTime)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, title, description, type, startTime, endTime);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessEventImplToJson(
      this,
    );
  }
}

abstract class _BusinessEvent implements BusinessEvent {
  const factory _BusinessEvent(
          {required final String id,
          required final String title,
          required final String description,
          required final String type,
          @DateTimeConverter() required final DateTime startTime,
          @DateTimeConverter() required final DateTime endTime}) =
      _$BusinessEventImpl;

  factory _BusinessEvent.fromJson(Map<String, dynamic> json) =
      _$BusinessEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get type;
  @override
  @DateTimeConverter()
  DateTime get startTime;
  @override
  @DateTimeConverter()
  DateTime get endTime;
  @override
  @JsonKey(ignore: true)
  _$$BusinessEventImplCopyWith<_$BusinessEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
