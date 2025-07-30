// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_offering.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceOffering _$ServiceOfferingFromJson(Map<String, dynamic> json) =>
    ServiceOffering(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      category: json['category'] as String?,
      staffIds: (json['staff_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ServiceOfferingToJson(ServiceOffering instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'business_id': instance.businessId,
    'name': instance.name,
    'description': instance.description,
    'price': instance.price,
    'duration': instance.duration.inMicroseconds,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('category', instance.category);
  writeNotNull('staff_ids', instance.staffIds);
  val['is_active'] = instance.isActive;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

_$ServiceOfferingImpl _$$ServiceOfferingImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceOfferingImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      category: json['category'] as String?,
      staffIds: (json['staff_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceOfferingImplToJson(
    _$ServiceOfferingImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'business_id': instance.businessId,
    'name': instance.name,
    'description': instance.description,
    'price': instance.price,
    'duration': instance.duration.inMicroseconds,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('category', instance.category);
  writeNotNull('staff_ids', instance.staffIds);
  val['is_active'] = instance.isActive;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
