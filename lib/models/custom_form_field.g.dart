// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_form_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomFormFieldImpl _$$CustomFormFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomFormFieldImpl(
      id: json['id'] as String,
      type: $enumDecode(_$CustomFormFieldTypeEnumMap, json['type']),
      label: json['label'] as String,
      order: (json['order'] as num).toInt(),
      required: json['required'] as bool? ?? false,
      description: json['description'] as String?,
      placeholder: json['placeholder'] as String?,
      defaultValue: json['default_value'] as String?,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      minValue: (json['min_value'] as num?)?.toInt(),
      maxValue: (json['max_value'] as num?)?.toInt(),
      minLength: (json['min_length'] as num?)?.toInt(),
      maxLength: (json['max_length'] as num?)?.toInt(),
      validationPattern: json['validation_pattern'] as String?,
      validationMessage: json['validation_message'] as String?,
    );

Map<String, dynamic> _$$CustomFormFieldImplToJson(
    _$CustomFormFieldImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': _$CustomFormFieldTypeEnumMap[instance.type]!,
    'label': instance.label,
    'order': instance.order,
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('placeholder', instance.placeholder);
  writeNotNull('default_value', instance.defaultValue);
  writeNotNull('options', instance.options);
  writeNotNull('min_value', instance.minValue);
  writeNotNull('max_value', instance.maxValue);
  writeNotNull('min_length', instance.minLength);
  writeNotNull('max_length', instance.maxLength);
  writeNotNull('validation_pattern', instance.validationPattern);
  writeNotNull('validation_message', instance.validationMessage);
  return val;
}

const _$CustomFormFieldTypeEnumMap = {
  CustomFormFieldType.text: 'text',
  CustomFormFieldType.number: 'number',
  CustomFormFieldType.email: 'email',
  CustomFormFieldType.phone: 'phone',
  CustomFormFieldType.choice: 'choice',
  CustomFormFieldType.multiselect: 'multiselect',
  CustomFormFieldType.date: 'date',
  CustomFormFieldType.time: 'time',
  CustomFormFieldType.datetime: 'datetime',
  CustomFormFieldType.boolean: 'boolean',
  CustomFormFieldType.rating: 'rating',
  CustomFormFieldType.textarea: 'textarea',
};

_$FormResponseImpl _$$FormResponseImplFromJson(Map<String, dynamic> json) =>
    _$FormResponseImpl(
      id: json['id'] as String,
      messageId: json['message_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      responses: json['responses'] as Map<String, dynamic>,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      userEmail: json['user_email'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$FormResponseImplToJson(_$FormResponseImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'message_id': instance.messageId,
    'user_id': instance.userId,
    'user_name': instance.userName,
    'responses': instance.responses,
    'submitted_at': instance.submittedAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_email', instance.userEmail);
  writeNotNull('metadata', instance.metadata);
  return val;
}

_$FormFieldStatisticsImpl _$$FormFieldStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$FormFieldStatisticsImpl(
      fieldId: json['field_id'] as String,
      fieldLabel: json['field_label'] as String,
      fieldType: $enumDecode(_$CustomFormFieldTypeEnumMap, json['field_type']),
      totalResponses: (json['total_responses'] as num).toInt(),
      validResponses: (json['valid_responses'] as num).toInt(),
      averageValue: (json['average_value'] as num?)?.toDouble(),
      mostCommonValue: json['most_common_value'] as String?,
      choiceDistribution:
          (json['choice_distribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      allResponses: (json['all_responses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$FormFieldStatisticsImplToJson(
    _$FormFieldStatisticsImpl instance) {
  final val = <String, dynamic>{
    'field_id': instance.fieldId,
    'field_label': instance.fieldLabel,
    'field_type': _$CustomFormFieldTypeEnumMap[instance.fieldType]!,
    'total_responses': instance.totalResponses,
    'valid_responses': instance.validResponses,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('average_value', instance.averageValue);
  writeNotNull('most_common_value', instance.mostCommonValue);
  writeNotNull('choice_distribution', instance.choiceDistribution);
  writeNotNull('all_responses', instance.allResponses);
  return val;
}
