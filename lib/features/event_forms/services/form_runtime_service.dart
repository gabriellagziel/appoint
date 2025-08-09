import 'package:appoint/features/event_forms/models/form_field_def.dart';
import 'package:appoint/features/event_forms/models/form_submission.dart';

class FormRuntimeService {
  /// Evaluate which fields should be visible based on current answers
  List<FormFieldDef> evaluateVisibility(
    List<FormFieldDef> fields,
    Map<String, dynamic> answers,
  ) {
    return fields.where((field) => field.isVisible(answers)).toList();
  }

  /// Validate all answers against field definitions
  List<String> validateAnswers(
    List<FormFieldDef> fields,
    Map<String, dynamic> answers,
  ) {
    final errors = <String>[];

    for (final field in fields) {
      final answer = answers[field.id];
      final error = field.validateValue(answer);
      if (error != null) {
        errors.add(error);
      }
    }

    return errors;
  }

  /// Check if a submission is complete (all required fields filled)
  bool isSubmissionComplete(
    List<FormFieldDef> fields,
    Map<String, dynamic> answers,
  ) {
    for (final field in fields) {
      if (field.required) {
        final answer = answers[field.id];
        if (answer == null || answer.toString().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  /// Get validation errors for a specific field
  String? validateField(FormFieldDef field, dynamic value) {
    return field.validateValue(value);
  }

  /// Check if a field should be visible based on current answers
  bool isFieldVisible(FormFieldDef field, Map<String, dynamic> answers) {
    return field.isVisible(answers);
  }

  /// Get all visible fields for a form
  List<FormFieldDef> getVisibleFields(
    List<FormFieldDef> fields,
    Map<String, dynamic> answers,
  ) {
    return fields.where((field) => field.isVisible(answers)).toList();
  }

  /// Get required fields that are currently visible
  List<FormFieldDef> getRequiredVisibleFields(
    List<FormFieldDef> fields,
    Map<String, dynamic> answers,
  ) {
    return fields
        .where((field) => field.required && field.isVisible(answers))
        .toList();
  }

  /// Get completion percentage for a form
  double getCompletionPercentage(
    List<FormFieldDef> fields,
    Map<String, dynamic> answers,
  ) {
    final requiredFields = fields.where((field) => field.required).toList();
    if (requiredFields.isEmpty) return 1.0;

    final visibleRequiredFields =
        requiredFields.where((field) => field.isVisible(answers)).toList();

    if (visibleRequiredFields.isEmpty) return 1.0;

    final completedFields = visibleRequiredFields.where((field) {
      final answer = answers[field.id];
      return answer != null && answer.toString().isNotEmpty;
    }).length;

    return completedFields / visibleRequiredFields.length;
  }

  /// Get field dependencies (which fields affect visibility of others)
  Map<String, List<String>> getFieldDependencies(List<FormFieldDef> fields) {
    final dependencies = <String, List<String>>{};

    for (final field in fields) {
      if (field.visibleIf != null) {
        final fieldId = field.visibleIf!['fieldId'] as String?;
        if (fieldId != null) {
          dependencies[fieldId] = [...(dependencies[fieldId] ?? []), field.id];
        }
      }
    }

    return dependencies;
  }

  /// Get fields that would be affected by changing a specific field
  List<String> getAffectedFields(
    String fieldId,
    List<FormFieldDef> fields,
  ) {
    final dependencies = getFieldDependencies(fields);
    return dependencies[fieldId] ?? [];
  }

  /// Validate a single field and return error message
  String? validateSingleField(
    FormFieldDef field,
    dynamic value,
    Map<String, dynamic> allAnswers,
  ) {
    // Check if field should be visible
    if (!field.isVisible(allAnswers)) {
      return null; // Hidden fields don't need validation
    }

    // Validate the value
    return field.validateValue(value);
  }

  /// Get field options for dropdown/multiselect fields
  List<String> getFieldOptions(FormFieldDef field) {
    return field.options ?? [];
  }

  /// Check if a field value is valid for its type
  bool isValidFieldValue(FormFieldDef field, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return !field.required;
    }

    switch (field.type) {
      case FormFieldType.number:
        return int.tryParse(value.toString()) != null;
      case FormFieldType.date:
        try {
          DateTime.parse(value.toString());
          return true;
        } catch (e) {
          return false;
        }
      case FormFieldType.dropdown:
        return field.options?.contains(value.toString()) ?? false;
      case FormFieldType.multiselect:
        if (value is! List) return false;
        return value
            .every((item) => field.options?.contains(item.toString()) ?? false);
      case FormFieldType.checkbox:
        return value is bool;
      default:
        return true; // Text fields accept any string
    }
  }

  /// Format field value for display
  String formatFieldValue(FormFieldDef field, dynamic value) {
    if (value == null) return '';

    switch (field.type) {
      case FormFieldType.date:
        try {
          final date = DateTime.parse(value.toString());
          return '${date.day}/${date.month}/${date.year}';
        } catch (e) {
          return value.toString();
        }
      case FormFieldType.multiselect:
        if (value is List) {
          return value.join(', ');
        }
        return value.toString();
      case FormFieldType.checkbox:
        return value == true ? 'Yes' : 'No';
      default:
        return value.toString();
    }
  }

  /// Get field validation rules for display
  Map<String, dynamic> getFieldValidationRules(FormFieldDef field) {
    final rules = <String, dynamic>{};

    if (field.required) {
      rules['required'] = true;
    }

    if (field.min != null) {
      rules['min'] = field.min;
    }

    if (field.max != null) {
      rules['max'] = field.max;
    }

    if (field.regex != null) {
      rules['pattern'] = field.regex;
    }

    if (field.options != null) {
      rules['options'] = field.options;
    }

    return rules;
  }

  /// Check if a form submission is valid for RSVP acceptance
  bool isValidForRSVP(
    List<FormFieldDef> fields,
    Map<String, dynamic> answers,
  ) {
    final visibleFields = getVisibleFields(fields, answers);
    final requiredFields =
        visibleFields.where((field) => field.required).toList();

    for (final field in requiredFields) {
      final answer = answers[field.id];
      if (answer == null || answer.toString().isEmpty) {
        return false;
      }

      final error = field.validateValue(answer);
      if (error != null) {
        return false;
      }
    }

    return true;
  }
}
