import 'package:appoint/models/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormResponseService {
  FormResponseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  final FirebaseFirestore _firestore;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _responsesCollection =>
      _firestore.collection('broadcast_form_responses');

  CollectionReference<Map<String, dynamic>> get _broadcastsCollection =>
      _firestore.collection('admin_broadcasts');

  /// Submit a form response
  Future<String> submitFormResponse({
    required String messageId,
    required Map<String, dynamic> responses,
    required List<CustomFormField> formFields,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to submit form');
    }

    try {
      // Validate responses against form fields
      final validationErrors = validateFormResponses(responses, formFields);
      if (validationErrors.isNotEmpty) {
        throw FormValidationException(validationErrors);
      }

      // Check if user has already submitted this form
      final existingResponse = await _responsesCollection
          .where('messageId', isEqualTo: messageId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (existingResponse.docs.isNotEmpty) {
        throw Exception('You have already submitted this form');
      }

      // Create form response
      final formResponse = FormResponse(
        id: '', // Will be set by Firestore
        messageId: messageId,
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
        userEmail: user.email,
        responses: responses,
        submittedAt: DateTime.now(),
        metadata: {
          'userAgent': 'Flutter App',
          'platform': 'mobile',
        },
      );

      // Save to Firestore
      final docRef = await _responsesCollection.add(formResponse.toJson());

      // Update analytics
      await _updateFormAnalytics(messageId, formFields, responses);

      return docRef.id;
    } catch (e) {
      if (e is FormValidationException) {
        rethrow;
      }
      throw Exception('Failed to submit form: $e');
    }
  }

  /// Get form responses for a message (admin only)
  Future<List<FormResponse>> getFormResponses(String messageId) async {
    try {
      final snapshot = await _responsesCollection
          .where('messageId', isEqualTo: messageId)
          .orderBy('submittedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => FormResponse.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get form responses: $e');
    }
  }

  /// Get form statistics for a message
  Future<Map<String, FormFieldStatistics>> getFormStatistics(
    String messageId,
    List<CustomFormField> formFields,
  ) async {
    try {
      final responses = await getFormResponses(messageId);
      final statistics = <String, FormFieldStatistics>{};

      for (final field in formFields) {
        statistics[field.id] = _calculateFieldStatistics(field, responses);
      }

      return statistics;
    } catch (e) {
      throw Exception('Failed to get form statistics: $e');
    }
  }

  /// Calculate statistics for a specific field
  FormFieldStatistics _calculateFieldStatistics(
    CustomFormField field,
    List<FormResponse> responses,
  ) {
    final fieldResponses = responses
        .where((response) => response.responses.containsKey(field.id))
        .map((response) => response.responses[field.id])
        .where((value) => value != null)
        .toList();

    final validResponses = fieldResponses.where((value) => 
      value.toString().trim().isNotEmpty
    ).toList();

    // Calculate statistics based on field type
    double? averageValue;
    String? mostCommonValue;
    Map<String, int>? choiceDistribution;

    switch (field.type) {
      case CustomFormFieldType.number:
      case CustomFormFieldType.rating:
        final numericValues = validResponses
            .map((v) => double.tryParse(v.toString()))
            .where((v) => v != null)
            .cast<double>()
            .toList();
        
        if (numericValues.isNotEmpty) {
          averageValue = numericValues.reduce((a, b) => a + b) / numericValues.length;
        }
        break;

      case CustomFormFieldType.choice:
      case CustomFormFieldType.boolean:
        choiceDistribution = <String, int>{};
        for (final value in validResponses) {
          final stringValue = value.toString();
          choiceDistribution[stringValue] = (choiceDistribution[stringValue] ?? 0) + 1;
        }
        
        if (choiceDistribution.isNotEmpty) {
          mostCommonValue = choiceDistribution.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key;
        }
        break;

      case CustomFormFieldType.multiselect:
        choiceDistribution = <String, int>{};
        for (final value in validResponses) {
          if (value is List) {
            for (final item in value) {
              final stringValue = item.toString();
              choiceDistribution[stringValue] = (choiceDistribution[stringValue] ?? 0) + 1;
            }
          }
        }
        break;

      default:
        // For text fields, find most common response
        final stringResponses = validResponses.map((v) => v.toString()).toList();
        if (stringResponses.isNotEmpty) {
          final frequency = <String, int>{};
          for (final response in stringResponses) {
            frequency[response] = (frequency[response] ?? 0) + 1;
          }
          mostCommonValue = frequency.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key;
        }
        break;
    }

    return FormFieldStatistics(
      fieldId: field.id,
      fieldLabel: field.label,
      fieldType: field.type,
      totalResponses: fieldResponses.length,
      validResponses: validResponses.length,
      averageValue: averageValue,
      mostCommonValue: mostCommonValue,
      choiceDistribution: choiceDistribution,
      allResponses: validResponses.map((v) => v.toString()).toList(),
    );
  }

  /// Update form analytics in the broadcast message
  Future<void> _updateFormAnalytics(
    String messageId,
    List<CustomFormField> formFields,
    Map<String, dynamic> responses,
  ) async {
    try {
      // Increment total form responses
      await _broadcastsCollection.doc(messageId).update({
        'formResponseCount': FieldValue.increment(1),
        'lastResponseAt': FieldValue.serverTimestamp(),
      });

      // Track individual field responses
      for (final field in formFields) {
        if (responses.containsKey(field.id)) {
          final value = responses[field.id];
          if (value != null && value.toString().trim().isNotEmpty) {
            await _trackFieldResponse(messageId, field.id, value);
          }
        }
      }
    } catch (e) {
      print('Failed to update form analytics: $e');
      // Don't fail the form submission if analytics update fails
    }
  }

  /// Track individual field response for analytics
  Future<void> _trackFieldResponse(
    String messageId,
    String fieldId,
    dynamic value,
  ) async {
    try {
      final analyticsRef = _firestore.collection('broadcast_analytics').doc();
      await analyticsRef.set({
        'messageId': messageId,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'event': 'form_field_response',
        'fieldId': fieldId,
        'fieldValue': value,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to track field response: $e');
    }
  }

  /// Export form responses as CSV
  Future<String> exportFormResponsesCSV(
    String messageId,
    List<CustomFormField> formFields,
  ) async {
    try {
      final responses = await getFormResponses(messageId);
      final csvLines = <String>[];

      // Header row
      final headers = [
        'Response ID',
        'User Name',
        'User Email',
        'Submitted At',
        ...formFields.map((field) => field.label),
      ];
      csvLines.add(headers.map((h) => '"$h"').join(','));

      // Data rows
      for (final response in responses) {
        final row = [
          response.id,
          response.userName,
          response.userEmail ?? '',
          response.submittedAt.toIso8601String(),
          ...formFields.map((field) {
            final value = response.responses[field.id];
            if (value == null) return '';
            if (value is List) {
              return value.join('; ');
            }
            return value.toString();
          }),
        ];
        csvLines.add(row.map((cell) => '"${cell.toString().replaceAll('"', '""')}"').join(','));
      }

      return csvLines.join('\n');
    } catch (e) {
      throw Exception('Failed to export form responses: $e');
    }
  }

  /// Validate form responses against field definitions
  Map<String, String> validateFormResponses(
    Map<String, dynamic> responses,
    List<CustomFormField> formFields,
  ) {
    final errors = <String, String>{};

    for (final field in formFields) {
      final value = responses[field.id];
      
      // Check required fields
      if (field.required && (value == null || value.toString().trim().isEmpty)) {
        errors[field.id] = 'This field is required';
        continue;
      }

      // Skip validation if field is not required and empty
      if (value == null || value.toString().trim().isEmpty) {
        continue;
      }

      // Type-specific validation
      switch (field.type) {
        case CustomFormFieldType.email:
          if (!_isValidEmail(value.toString())) {
            errors[field.id] = 'Please enter a valid email address';
          }
          break;

        case CustomFormFieldType.phone:
          if (!_isValidPhone(value.toString())) {
            errors[field.id] = 'Please enter a valid phone number';
          }
          break;

        case CustomFormFieldType.number:
          final numValue = double.tryParse(value.toString());
          if (numValue == null) {
            errors[field.id] = 'Please enter a valid number';
          } else {
            if (field.minValue != null && numValue < field.minValue!) {
              errors[field.id] = 'Value must be at least ${field.minValue}';
            }
            if (field.maxValue != null && numValue > field.maxValue!) {
              errors[field.id] = 'Value must be at most ${field.maxValue}';
            }
          }
          break;

        case CustomFormFieldType.rating:
          final rating = int.tryParse(value.toString());
          if (rating == null) {
            errors[field.id] = 'Please select a rating';
          } else {
            final min = field.minValue ?? 1;
            final max = field.maxValue ?? 5;
            if (rating < min || rating > max) {
              errors[field.id] = 'Rating must be between $min and $max';
            }
          }
          break;

        case CustomFormFieldType.text:
        case CustomFormFieldType.textarea:
          final text = value.toString();
          if (field.minLength != null && text.length < field.minLength!) {
            errors[field.id] = 'Must be at least ${field.minLength} characters';
          }
          if (field.maxLength != null && text.length > field.maxLength!) {
            errors[field.id] = 'Must be at most ${field.maxLength} characters';
          }
          if (field.validationPattern != null) {
            final regex = RegExp(field.validationPattern!);
            if (!regex.hasMatch(text)) {
              errors[field.id] = field.validationMessage ?? 'Invalid format';
            }
          }
          break;

        case CustomFormFieldType.choice:
          if (field.options != null && !field.options!.contains(value.toString())) {
            errors[field.id] = 'Please select a valid option';
          }
          break;

        case CustomFormFieldType.multiselect:
          if (value is List) {
            if (field.options != null) {
              for (final item in value) {
                if (!field.options!.contains(item.toString())) {
                  errors[field.id] = 'Please select only valid options';
                  break;
                }
              }
            }
          } else {
            errors[field.id] = 'Invalid selection format';
          }
          break;

        case CustomFormFieldType.date:
        case CustomFormFieldType.datetime:
          if (DateTime.tryParse(value.toString()) == null) {
            errors[field.id] = 'Please enter a valid date';
          }
          break;

        case CustomFormFieldType.time:
          if (!_isValidTime(value.toString())) {
            errors[field.id] = 'Please enter a valid time (HH:MM)';
          }
          break;

        case CustomFormFieldType.boolean:
          if (value is! bool && !['true', 'false', '0', '1'].contains(value.toString().toLowerCase())) {
            errors[field.id] = 'Invalid boolean value';
          }
          break;
      }
    }

    return errors;
  }

  /// Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  /// Phone validation (basic)
  bool _isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return cleaned.length >= 7 && cleaned.length <= 15;
  }

  /// Time validation (HH:MM format)
  bool _isValidTime(String time) {
    return RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(time);
  }

  /// Check if user has already submitted form
  Future<bool> hasUserSubmittedForm(String messageId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final snapshot = await _responsesCollection
          .where('messageId', isEqualTo: messageId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get user's form response
  Future<FormResponse?> getUserFormResponse(String messageId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final snapshot = await _responsesCollection
          .where('messageId', isEqualTo: messageId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return FormResponse.fromJson({
        'id': doc.id,
        ...doc.data(),
      });
    } catch (e) {
      return null;
    }
  }
}

/// Custom exception for form validation errors
class FormValidationException implements Exception {
  final Map<String, String> errors;
  
  FormValidationException(this.errors);

  @override
  String toString() => 'Form validation failed: ${errors.values.join(', ')}';
}

// Provider
final formResponseServiceProvider = Provider<FormResponseService>(
  (ref) => FormResponseService(),
);