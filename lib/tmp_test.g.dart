// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmp_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TmpImpl _$$TmpImplFromJson(Map<String, dynamic> json) => _$TmpImpl(
      id: json['id'] as String,
      time: const DateTimeConverter().fromJson(json['time'] as String),
    );

Map<String, dynamic> _$$TmpImplToJson(_$TmpImpl instance) => <String, dynamic>{
      'id': instance.id,
      'time': const DateTimeConverter().toJson(instance.time),
    };
