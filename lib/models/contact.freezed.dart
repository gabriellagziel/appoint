// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return _Contact.fromJson(json);
}

/// @nodoc
mixin _$Contact {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String displayName, String? phoneNumber,
            String? email, String? location)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String displayName, String? phoneNumber,
            String? email, String? location)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String displayName, String? phoneNumber,
            String? email, String? location)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? phoneNumber,
      String? email,
      String? location});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res, $Val extends Contact>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? location = freezed,
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
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? phoneNumber,
      String? email,
      String? location});
}

/// @nodoc
class __$$ContactImplCopyWithImpl<$Res>
    extends _$ContactCopyWithImpl<$Res, _$ContactImpl>
    implements _$$ContactImplCopyWith<$Res> {
  __$$ContactImplCopyWithImpl(
      _$ContactImpl _value, $Res Function(_$ContactImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? location = freezed,
  }) {
    return _then(_$ContactImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactImpl extends _Contact {
  const _$ContactImpl(
      {required this.id,
      required this.displayName,
      this.phoneNumber,
      this.email,
      this.location})
      : super._();

  factory _$ContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? phoneNumber;
  @override
  final String? email;
  @override
  final String? location;

  @override
  String toString() {
    return 'Contact(id: $id, displayName: $displayName, phoneNumber: $phoneNumber, email: $email, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, displayName, phoneNumber, email, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      __$$ContactImplCopyWithImpl<_$ContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String displayName, String? phoneNumber,
            String? email, String? location)
        $default,
  ) {
    return $default(id, displayName, phoneNumber, email, location);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String displayName, String? phoneNumber,
            String? email, String? location)?
        $default,
  ) {
    return $default?.call(id, displayName, phoneNumber, email, location);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String displayName, String? phoneNumber,
            String? email, String? location)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, displayName, phoneNumber, email, location);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactImplToJson(
      this,
    );
  }
}

abstract class _Contact extends Contact {
  const factory _Contact(
      {required final String id,
      required final String displayName,
      final String? phoneNumber,
      final String? email,
      final String? location}) = _$ContactImpl;
  const _Contact._() : super._();

  factory _Contact.fromJson(Map<String, dynamic> json) = _$ContactImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get phoneNumber;
  @override
  String? get email;
  @override
  String? get location;
  @override
  @JsonKey(ignore: true)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
