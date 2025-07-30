// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_offering.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceOffering _$ServiceOfferingFromJson(Map<String, dynamic> json) {
  return _ServiceOffering.fromJson(json);
}

/// @nodoc
mixin _$ServiceOffering {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get staffIds => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String businessId,
            String name,
            String description,
            double price,
            Duration duration,
            String? category,
            List<String>? staffIds,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String businessId,
            String name,
            String description,
            double price,
            Duration duration,
            String? category,
            List<String>? staffIds,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String businessId,
            String name,
            String description,
            double price,
            Duration duration,
            String? category,
            List<String>? staffIds,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceOfferingCopyWith<ServiceOffering> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceOfferingCopyWith<$Res> {
  factory $ServiceOfferingCopyWith(
          ServiceOffering value, $Res Function(ServiceOffering) then) =
      _$ServiceOfferingCopyWithImpl<$Res, ServiceOffering>;
  @useResult
  $Res call(
      {String id,
      String businessId,
      String name,
      String description,
      double price,
      Duration duration,
      String? category,
      List<String>? staffIds,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ServiceOfferingCopyWithImpl<$Res, $Val extends ServiceOffering>
    implements $ServiceOfferingCopyWith<$Res> {
  _$ServiceOfferingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? duration = null,
    Object? category = freezed,
    Object? staffIds = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessId: null == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      staffIds: freezed == staffIds
          ? _value.staffIds
          : staffIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceOfferingImplCopyWith<$Res>
    implements $ServiceOfferingCopyWith<$Res> {
  factory _$$ServiceOfferingImplCopyWith(_$ServiceOfferingImpl value,
          $Res Function(_$ServiceOfferingImpl) then) =
      __$$ServiceOfferingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String businessId,
      String name,
      String description,
      double price,
      Duration duration,
      String? category,
      List<String>? staffIds,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ServiceOfferingImplCopyWithImpl<$Res>
    extends _$ServiceOfferingCopyWithImpl<$Res, _$ServiceOfferingImpl>
    implements _$$ServiceOfferingImplCopyWith<$Res> {
  __$$ServiceOfferingImplCopyWithImpl(
      _$ServiceOfferingImpl _value, $Res Function(_$ServiceOfferingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? duration = null,
    Object? category = freezed,
    Object? staffIds = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ServiceOfferingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessId: null == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      staffIds: freezed == staffIds
          ? _value._staffIds
          : staffIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceOfferingImpl implements _ServiceOffering {
  const _$ServiceOfferingImpl(
      {required this.id,
      required this.businessId,
      required this.name,
      required this.description,
      required this.price,
      required this.duration,
      this.category,
      final List<String>? staffIds,
      this.isActive = true,
      this.createdAt,
      this.updatedAt})
      : _staffIds = staffIds;

  factory _$ServiceOfferingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceOfferingImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  final Duration duration;
  @override
  final String? category;
  final List<String>? _staffIds;
  @override
  List<String>? get staffIds {
    final value = _staffIds;
    if (value == null) return null;
    if (_staffIds is EqualUnmodifiableListView) return _staffIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ServiceOffering(id: $id, businessId: $businessId, name: $name, description: $description, price: $price, duration: $duration, category: $category, staffIds: $staffIds, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceOfferingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._staffIds, _staffIds) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      businessId,
      name,
      description,
      price,
      duration,
      category,
      const DeepCollectionEquality().hash(_staffIds),
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceOfferingImplCopyWith<_$ServiceOfferingImpl> get copyWith =>
      __$$ServiceOfferingImplCopyWithImpl<_$ServiceOfferingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String businessId,
            String name,
            String description,
            double price,
            Duration duration,
            String? category,
            List<String>? staffIds,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    return $default(id, businessId, name, description, price, duration,
        category, staffIds, isActive, createdAt, updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String businessId,
            String name,
            String description,
            double price,
            Duration duration,
            String? category,
            List<String>? staffIds,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    return $default?.call(id, businessId, name, description, price, duration,
        category, staffIds, isActive, createdAt, updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String businessId,
            String name,
            String description,
            double price,
            Duration duration,
            String? category,
            List<String>? staffIds,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, businessId, name, description, price, duration,
          category, staffIds, isActive, createdAt, updatedAt);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceOfferingImplToJson(
      this,
    );
  }
}

abstract class _ServiceOffering implements ServiceOffering {
  const factory _ServiceOffering(
      {required final String id,
      required final String businessId,
      required final String name,
      required final String description,
      required final double price,
      required final Duration duration,
      final String? category,
      final List<String>? staffIds,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ServiceOfferingImpl;

  factory _ServiceOffering.fromJson(Map<String, dynamic> json) =
      _$ServiceOfferingImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  Duration get duration;
  @override
  String? get category;
  @override
  List<String>? get staffIds;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ServiceOfferingImplCopyWith<_$ServiceOfferingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
