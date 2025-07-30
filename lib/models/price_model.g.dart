// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceModelImpl _$$PriceModelImplFromJson(Map<String, dynamic> json) =>
    _$PriceModelImpl(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      discountPercent: (json['discount_percent'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PriceModelImplToJson(_$PriceModelImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'discount_percent': instance.discountPercent,
    };
