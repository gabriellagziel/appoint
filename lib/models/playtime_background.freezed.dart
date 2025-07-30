// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playtime_background.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaytimeBackground _$PlaytimeBackgroundFromJson(Map<String, dynamic> json) {
  return _PlaytimeBackground.fromJson(json);
}

/// @nodoc
mixin _$PlaytimeBackground {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String imageUrl, String createdBy) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String imageUrl, String createdBy)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String imageUrl, String createdBy)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaytimeBackgroundCopyWith<PlaytimeBackground> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaytimeBackgroundCopyWith<$Res> {
  factory $PlaytimeBackgroundCopyWith(
          PlaytimeBackground value, $Res Function(PlaytimeBackground) then) =
      _$PlaytimeBackgroundCopyWithImpl<$Res, PlaytimeBackground>;
  @useResult
  $Res call({String id, String imageUrl, String createdBy});
}

/// @nodoc
class _$PlaytimeBackgroundCopyWithImpl<$Res, $Val extends PlaytimeBackground>
    implements $PlaytimeBackgroundCopyWith<$Res> {
  _$PlaytimeBackgroundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? createdBy = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaytimeBackgroundImplCopyWith<$Res>
    implements $PlaytimeBackgroundCopyWith<$Res> {
  factory _$$PlaytimeBackgroundImplCopyWith(_$PlaytimeBackgroundImpl value,
          $Res Function(_$PlaytimeBackgroundImpl) then) =
      __$$PlaytimeBackgroundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String imageUrl, String createdBy});
}

/// @nodoc
class __$$PlaytimeBackgroundImplCopyWithImpl<$Res>
    extends _$PlaytimeBackgroundCopyWithImpl<$Res, _$PlaytimeBackgroundImpl>
    implements _$$PlaytimeBackgroundImplCopyWith<$Res> {
  __$$PlaytimeBackgroundImplCopyWithImpl(_$PlaytimeBackgroundImpl _value,
      $Res Function(_$PlaytimeBackgroundImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? createdBy = null,
  }) {
    return _then(_$PlaytimeBackgroundImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaytimeBackgroundImpl implements _PlaytimeBackground {
  const _$PlaytimeBackgroundImpl(
      {required this.id, required this.imageUrl, required this.createdBy});

  factory _$PlaytimeBackgroundImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaytimeBackgroundImplFromJson(json);

  @override
  final String id;
  @override
  final String imageUrl;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'PlaytimeBackground(id: $id, imageUrl: $imageUrl, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaytimeBackgroundImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageUrl, createdBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaytimeBackgroundImplCopyWith<_$PlaytimeBackgroundImpl> get copyWith =>
      __$$PlaytimeBackgroundImplCopyWithImpl<_$PlaytimeBackgroundImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String imageUrl, String createdBy) $default,
  ) {
    return $default(id, imageUrl, createdBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String imageUrl, String createdBy)? $default,
  ) {
    return $default?.call(id, imageUrl, createdBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String imageUrl, String createdBy)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, imageUrl, createdBy);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaytimeBackgroundImplToJson(
      this,
    );
  }
}

abstract class _PlaytimeBackground implements PlaytimeBackground {
  const factory _PlaytimeBackground(
      {required final String id,
      required final String imageUrl,
      required final String createdBy}) = _$PlaytimeBackgroundImpl;

  factory _PlaytimeBackground.fromJson(Map<String, dynamic> json) =
      _$PlaytimeBackgroundImpl.fromJson;

  @override
  String get id;
  @override
  String get imageUrl;
  @override
  String get createdBy;
  @override
  @JsonKey(ignore: true)
  _$$PlaytimeBackgroundImplCopyWith<_$PlaytimeBackgroundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
