import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_form_field.freezed.dart';
part 'custom_form_field.g.dart';

enum CustomFormFieldType {
  text,
  number,
  email,
  phone,
  choice,
  multiselect,
  date,
  time,
  datetime,
  boolean,
  rating,
  textarea,
}

@freezed
class CustomFormField with _$CustomFormField {
  const factory CustomFormField({
    required String id,
    required CustomFormFieldType type,
    required String label,
    required int order,
    @Default(false) bool required,
    String? description,
    String? placeholder,
    String? defaultValue,
    List<String>? options, // for choice and multiselect
    int? minValue, // for number and rating
    int? maxValue, // for number and rating
    int? minLength, // for text fields
    int? maxLength, // for text fields
    String? validationPattern, // regex for validation
    String? validationMessage, // custom validation error
  }) = _CustomFormField;

  factory CustomFormField.fromJson(Map<String, dynamic> json) =>
      _$CustomFormFieldFromJson(json);
}

@freezed
class FormResponse with _$FormResponse {
  const factory FormResponse({
    required String id,
    required String messageId,
    required String userId,
    required String userName,
    required Map<String, dynamic> responses, // fieldId -> response value
    required DateTime submittedAt,
    String? userEmail,
    Map<String, String>? metadata, // additional user metadata
  }) = _FormResponse;

  factory FormResponse.fromJson(Map<String, dynamic> json) =>
      _$FormResponseFromJson(json);
}

@freezed
class FormFieldStatistics with _$FormFieldStatistics {
  const factory FormFieldStatistics({
    required String fieldId,
    required String fieldLabel,
    required CustomFormFieldType fieldType,
    required int totalResponses,
    required int validResponses,
    double? averageValue, // for numeric fields
    String? mostCommonValue,
    Map<String, int>? choiceDistribution, // for choice fields
    List<String>? allResponses, // for analysis
  }) = _FormFieldStatistics;

  factory FormFieldStatistics.fromJson(Map<String, dynamic> json) =>
      _$FormFieldStatisticsFromJson(json);
}
