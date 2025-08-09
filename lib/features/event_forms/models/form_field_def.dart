import 'package:flutter/material.dart';

enum FormFieldType {
  text,
  textarea,
  number,
  date,
  dropdown,
  multiselect,
  checkbox,
}

class FormFieldDef {
  final String id;
  final String formId;
  final String label;
  final FormFieldType type;
  final bool required;
  final String? placeholder;
  final String? helpText;
  final List<String>? options; // for dropdown/multiselect
  final int? min; // for number length/value
  final int? max; // for number length/value
  final String? regex; // validation pattern
  final Map<String, dynamic>? visibleIf; // conditional visibility
  final List<String> editableRoles; // default: all
  final List<String> viewableRoles; // default: all
  final int orderIndex;

  const FormFieldDef({
    required this.id,
    required this.formId,
    required this.label,
    required this.type,
    required this.required,
    this.placeholder,
    this.helpText,
    this.options,
    this.min,
    this.max,
    this.regex,
    this.visibleIf,
    this.editableRoles = const ['owner', 'admin', 'member'],
    this.viewableRoles = const ['owner', 'admin', 'member'],
    required this.orderIndex,
  });

  factory FormFieldDef.fromMap(String id, Map<String, dynamic> map) {
    return FormFieldDef(
      id: id,
      formId: map['formId'] as String,
      label: map['label'] as String,
      type: _parseFieldType(map['type'] as String),
      required: map['required'] as bool? ?? false,
      placeholder: map['placeholder'] as String?,
      helpText: map['helpText'] as String?,
      options: map['options'] != null
          ? List<String>.from(map['options'] as List)
          : null,
      min: map['min'] as int?,
      max: map['max'] as int?,
      regex: map['regex'] as String?,
      visibleIf: map['visibleIf'] as Map<String, dynamic>?,
      editableRoles: map['editableRoles'] != null
          ? List<String>.from(map['editableRoles'] as List)
          : const ['owner', 'admin', 'member'],
      viewableRoles: map['viewableRoles'] != null
          ? List<String>.from(map['viewableRoles'] as List)
          : const ['owner', 'admin', 'member'],
      orderIndex: map['orderIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'formId': formId,
      'label': label,
      'type': type.name,
      'required': required,
      'placeholder': placeholder,
      'helpText': helpText,
      'options': options,
      'min': min,
      'max': max,
      'regex': regex,
      'visibleIf': visibleIf,
      'editableRoles': editableRoles,
      'viewableRoles': viewableRoles,
      'orderIndex': orderIndex,
    };
  }

  static FormFieldType _parseFieldType(String type) {
    switch (type) {
      case 'text':
        return FormFieldType.text;
      case 'textarea':
        return FormFieldType.textarea;
      case 'number':
        return FormFieldType.number;
      case 'date':
        return FormFieldType.date;
      case 'dropdown':
        return FormFieldType.dropdown;
      case 'multiselect':
        return FormFieldType.multiselect;
      case 'checkbox':
        return FormFieldType.checkbox;
      default:
        return FormFieldType.text;
    }
  }

  FormFieldDef copyWith({
    String? id,
    String? formId,
    String? label,
    FormFieldType? type,
    bool? required,
    String? placeholder,
    String? helpText,
    List<String>? options,
    int? min,
    int? max,
    String? regex,
    Map<String, dynamic>? visibleIf,
    List<String>? editableRoles,
    List<String>? viewableRoles,
    int? orderIndex,
  }) {
    return FormFieldDef(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      label: label ?? this.label,
      type: type ?? this.type,
      required: required ?? this.required,
      placeholder: placeholder ?? this.placeholder,
      helpText: helpText ?? this.helpText,
      options: options ?? this.options,
      min: min ?? this.min,
      max: max ?? this.max,
      regex: regex ?? this.regex,
      visibleIf: visibleIf ?? this.visibleIf,
      editableRoles: editableRoles ?? this.editableRoles,
      viewableRoles: viewableRoles ?? this.viewableRoles,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  // Validation methods
  String? validateValue(dynamic value) {
    if (required && (value == null || value.toString().isEmpty)) {
      return '$label is required';
    }

    if (value == null || value.toString().isEmpty) {
      return null; // Empty non-required field is OK
    }

    final stringValue = value.toString();

    // Type-specific validation
    switch (type) {
      case FormFieldType.number:
        return _validateNumber(stringValue);
      case FormFieldType.date:
        return _validateDate(stringValue);
      case FormFieldType.dropdown:
      case FormFieldType.multiselect:
        return _validateOptions(value);
      default:
        return _validateText(stringValue);
    }
  }

  String? _validateNumber(String value) {
    final number = int.tryParse(value);
    if (number == null) {
      return '$label must be a valid number';
    }

    if (min != null && number < min!) {
      return '$label must be at least $min';
    }

    if (max != null && number > max!) {
      return '$label must be at most $max';
    }

    return null;
  }

  String? _validateDate(String value) {
    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();

      if (min != null) {
        final minDate = now.add(Duration(days: min!));
        if (date.isBefore(minDate)) {
          return '$label must be at least ${min} days from now';
        }
      }

      if (max != null) {
        final maxDate = now.add(Duration(days: max!));
        if (date.isAfter(maxDate)) {
          return '$label must be at most ${max} days from now';
        }
      }

      return null;
    } catch (e) {
      return '$label must be a valid date';
    }
  }

  String? _validateOptions(dynamic value) {
    if (options == null || options!.isEmpty) {
      return null;
    }

    if (type == FormFieldType.multiselect) {
      if (value is! List) {
        return '$label must be a list of options';
      }

      for (final item in value) {
        if (!options!.contains(item.toString())) {
          return '$label contains invalid option: $item';
        }
      }
    } else {
      if (!options!.contains(value.toString())) {
        return '$label must be one of: ${options!.join(', ')}';
      }
    }

    return null;
  }

  String? _validateText(String value) {
    if (regex != null) {
      try {
        final pattern = RegExp(regex!);
        if (!pattern.hasMatch(value)) {
          return '$label format is invalid';
        }
      } catch (e) {
        // Invalid regex pattern
        return null;
      }
    }

    if (min != null && value.length < min!) {
      return '$label must be at least $min characters';
    }

    if (max != null && value.length > max!) {
      return '$label must be at most $max characters';
    }

    return null;
  }

  // Conditional visibility evaluation
  bool isVisible(Map<String, dynamic> answers) {
    if (visibleIf == null) return true;

    final fieldId = visibleIf!['fieldId'] as String?;
    final expectedValue = visibleIf!['equals'];

    if (fieldId == null || expectedValue == null) return true;

    final fieldValue = answers[fieldId];
    return fieldValue?.toString() == expectedValue.toString();
  }

  // Helper methods
  bool get isMultiSelect => type == FormFieldType.multiselect;
  bool get isSingleSelect => type == FormFieldType.dropdown;
  bool get isTextInput =>
      type == FormFieldType.text || type == FormFieldType.textarea;
  bool get isNumeric => type == FormFieldType.number;
  bool get isDateInput => type == FormFieldType.date;
  bool get isBoolean => type == FormFieldType.checkbox;

  String get displayName {
    switch (type) {
      case FormFieldType.text:
        return 'Text Input';
      case FormFieldType.textarea:
        return 'Text Area';
      case FormFieldType.number:
        return 'Number Input';
      case FormFieldType.date:
        return 'Date Picker';
      case FormFieldType.dropdown:
        return 'Dropdown';
      case FormFieldType.multiselect:
        return 'Multi-Select';
      case FormFieldType.checkbox:
        return 'Checkbox';
    }
  }

  IconData get icon {
    switch (type) {
      case FormFieldType.text:
        return Icons.text_fields;
      case FormFieldType.textarea:
        return Icons.subject;
      case FormFieldType.number:
        return Icons.numbers;
      case FormFieldType.date:
        return Icons.calendar_today;
      case FormFieldType.dropdown:
        return Icons.arrow_drop_down;
      case FormFieldType.multiselect:
        return Icons.checklist;
      case FormFieldType.checkbox:
        return Icons.check_box;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormFieldDef &&
        other.id == id &&
        other.formId == formId &&
        other.label == label &&
        other.type == type &&
        other.required == required &&
        other.placeholder == placeholder &&
        other.helpText == helpText &&
        other.options == options &&
        other.min == min &&
        other.max == max &&
        other.regex == regex &&
        other.visibleIf == visibleIf &&
        other.editableRoles == editableRoles &&
        other.viewableRoles == viewableRoles &&
        other.orderIndex == orderIndex;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      formId,
      label,
      type,
      required,
      placeholder,
      helpText,
      options,
      min,
      max,
      regex,
      visibleIf,
      editableRoles,
      viewableRoles,
      orderIndex,
    );
  }

  @override
  String toString() {
    return 'FormFieldDef(id: $id, label: $label, type: $type, required: $required)';
  }
}
