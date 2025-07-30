// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

PriceModel _$PriceModelFromJson(Map<String, dynamic> json) {
  return _PriceModel.fromJson(json);
}

/// @nodoc
mixin _$PriceModel {
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  int get discountPercent => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(double amount, String currency, int discountPercent)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(double amount, String currency, int discountPercent)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(double amount, String currency, int discountPercent)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PriceModelCopyWith<PriceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceModelCopyWith<$Res> {
  factory $PriceModelCopyWith(
          PriceModel value, $Res Function(PriceModel) then) =
      _$PriceModelCopyWithImpl<$Res, PriceModel>;
  @useResult
  $Res call({double amount, String currency, int discountPercent});
}

/// @nodoc
class _$PriceModelCopyWithImpl<$Res, $Val extends PriceModel>
    implements $PriceModelCopyWith<$Res> {
  _$PriceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currency = null,
    Object? discountPercent = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceModelImplCopyWith<$Res>
    implements $PriceModelCopyWith<$Res> {
  factory _$$PriceModelImplCopyWith(
          _$PriceModelImpl value, $Res Function(_$PriceModelImpl) then) =
      __$$PriceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double amount, String currency, int discountPercent});
}

/// @nodoc
class __$$PriceModelImplCopyWithImpl<$Res>
    extends _$PriceModelCopyWithImpl<$Res, _$PriceModelImpl>
    implements _$$PriceModelImplCopyWith<$Res> {
  __$$PriceModelImplCopyWithImpl(
      _$PriceModelImpl _value, $Res Function(_$PriceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currency = null,
    Object? discountPercent = null,
  }) {
    return _then(_$PriceModelImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceModelImpl implements _PriceModel {
  const _$PriceModelImpl(
      {required this.amount, required this.currency, this.discountPercent = 0});

  factory _$PriceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceModelImplFromJson(json);

  @override
  final double amount;
  @override
  final String currency;
  @override
  @JsonKey()
  final int discountPercent;

  @override
  String toString() {
    return 'PriceModel(amount: $amount, currency: $currency, discountPercent: $discountPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceModelImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, amount, currency, discountPercent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceModelImplCopyWith<_$PriceModelImpl> get copyWith =>
      __$$PriceModelImplCopyWithImpl<_$PriceModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(double amount, String currency, int discountPercent)
        $default,
  ) {
    return $default(amount, currency, discountPercent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(double amount, String currency, int discountPercent)?
        $default,
  ) {
    return $default?.call(amount, currency, discountPercent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(double amount, String currency, int discountPercent)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(amount, currency, discountPercent);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceModelImplToJson(
      this,
    );
  }
}

abstract class _PriceModel implements PriceModel {
  const factory _PriceModel(
      {required final double amount,
      required final String currency,
      final int discountPercent}) = _$PriceModelImpl;

  factory _PriceModel.fromJson(Map<String, dynamic> json) =
      _$PriceModelImpl.fromJson;

  @override
  double get amount;
  @override
  String get currency;
  @override
  int get discountPercent;
  @override
  @JsonKey(ignore: true)
  _$$PriceModelImplCopyWith<_$PriceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
