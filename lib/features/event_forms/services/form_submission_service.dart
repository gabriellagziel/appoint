import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/features/event_forms/models/form_submission.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';
import 'package:appoint/features/event_forms/services/form_runtime_service.dart';

class FormSubmissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FormRuntimeService _runtimeService = FormRuntimeService();

  String _getCurrentUserId() {
    // TODO: Get from auth service
    return 'current-user-id';
  }

  /// Save a draft submission
  Future<String> saveDraft(
    String meetingId,
    String formId,
    Map<String, dynamic> answers, {
    String? userId,
    String? guestToken,
  }) async {
    try {
      // Check for existing draft
      final existingDraft = await _getExistingSubmission(
        meetingId,
        formId,
        userId: userId,
        guestToken: guestToken,
      );

      final submissionData = {
        'meetingId': meetingId,
        'formId': formId,
        'userId': userId,
        'guestToken': guestToken,
        'status': 'draft',
        'answers': answers,
        'updatedAt': Timestamp.now(),
      };

      String submissionId;
      if (existingDraft != null) {
        // Update existing draft
        await _firestore
            .collection('meetings')
            .doc(meetingId)
            .collection('form_submissions')
            .doc(existingDraft.id)
            .update(submissionData);
        submissionId = existingDraft.id;
      } else {
        // Create new draft
        submissionData['createdAt'] = Timestamp.now();
        final docRef = await _firestore
            .collection('meetings')
            .doc(meetingId)
            .collection('form_submissions')
            .add(submissionData);
        submissionId = docRef.id;
      }

      return submissionId;
    } catch (e) {
      throw Exception('Failed to save draft: $e');
    }
  }

  /// Submit a form (validate and save as submitted)
  Future<String> submit(
    String meetingId,
    String formId,
    Map<String, dynamic> answers,
    List<FormFieldDef> fields, {
    String? userId,
    String? guestToken,
  }) async {
    try {
      // Validate answers
      final errors = _runtimeService.validateAnswers(fields, answers);
      if (errors.isNotEmpty) {
        throw Exception('Validation failed: ${errors.join(', ')}');
      }

      // Check if submission is complete
      if (!_runtimeService.isSubmissionComplete(fields, answers)) {
        throw Exception('Please fill all required fields');
      }

      // Check for existing submission
      final existingSubmission = await _getExistingSubmission(
        meetingId,
        formId,
        userId: userId,
        guestToken: guestToken,
      );

      final submissionData = {
        'meetingId': meetingId,
        'formId': formId,
        'userId': userId,
        'guestToken': guestToken,
        'status': 'submitted',
        'answers': answers,
        'updatedAt': Timestamp.now(),
      };

      String submissionId;
      if (existingSubmission != null) {
        // Update existing submission
        await _firestore
            .collection('meetings')
            .doc(meetingId)
            .collection('form_submissions')
            .doc(existingSubmission.id)
            .update(submissionData);
        submissionId = existingSubmission.id;
      } else {
        // Create new submission
        submissionData['createdAt'] = Timestamp.now();
        final docRef = await _firestore
            .collection('meetings')
            .doc(meetingId)
            .collection('form_submissions')
            .add(submissionData);
        submissionId = docRef.id;
      }

      return submissionId;
    } catch (e) {
      throw Exception('Failed to submit form: $e');
    }
  }

  /// Check if user has a valid submission
  Future<bool> hasValidSubmission(
    String meetingId,
    String formId, {
    String? userId,
    String? guestToken,
  }) async {
    try {
      final submission = await _getExistingSubmission(
        meetingId,
        formId,
        userId: userId,
        guestToken: guestToken,
      );

      return submission?.isSubmitted == true;
    } catch (e) {
      return false;
    }
  }

  /// Get existing submission for user/guest
  Future<FormSubmission?> _getExistingSubmission(
    String meetingId,
    String formId, {
    String? userId,
    String? guestToken,
  }) async {
    try {
      Query query = _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('form_submissions')
          .where('formId', isEqualTo: formId);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      } else if (guestToken != null) {
        query = query.where('guestToken', isEqualTo: guestToken);
      } else {
        return null;
      }

      final snapshot = await query.limit(1).get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return FormSubmission.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get submission for user/guest
  Future<FormSubmission?> getSubmission(
    String meetingId,
    String formId, {
    String? userId,
    String? guestToken,
  }) async {
    return _getExistingSubmission(
      meetingId,
      formId,
      userId: userId,
      guestToken: guestToken,
    );
  }

  /// Get all submissions for a form
  Future<List<FormSubmission>> getFormSubmissions(
    String meetingId,
    String formId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('form_submissions')
          .where('formId', isEqualTo: formId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FormSubmission.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get form submissions: $e');
    }
  }

  /// Delete a submission
  Future<void> deleteSubmission(
    String meetingId,
    String submissionId,
  ) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('form_submissions')
          .doc(submissionId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete submission: $e');
    }
  }

  /// Get submission statistics
  Future<Map<String, dynamic>> getSubmissionStats(
    String meetingId,
    String formId,
  ) async {
    try {
      final submissions = await getFormSubmissions(meetingId, formId);

      final totalSubmissions = submissions.length;
      final submittedCount = submissions.where((s) => s.isSubmitted).length;
      final draftCount = totalSubmissions - submittedCount;
      final guestSubmissions =
          submissions.where((s) => s.isGuestSubmission).length;
      final memberSubmissions = totalSubmissions - guestSubmissions;

      return {
        'totalSubmissions': totalSubmissions,
        'submittedCount': submittedCount,
        'draftCount': draftCount,
        'guestSubmissions': guestSubmissions,
        'memberSubmissions': memberSubmissions,
        'completionRate': totalSubmissions > 0
            ? (submittedCount / totalSubmissions * 100).round()
            : 0,
      };
    } catch (e) {
      throw Exception('Failed to get submission stats: $e');
    }
  }

  /// Export submissions to CSV format
  Future<String> exportSubmissionsToCSV(
    String meetingId,
    String formId,
    List<FormFieldDef> fields,
  ) async {
    try {
      final submissions = await getFormSubmissions(meetingId, formId);

      if (submissions.isEmpty) {
        return '';
      }

      // Build CSV header
      final headers = [
        'User ID',
        'Guest Token',
        'Status',
        'Created At',
        'Updated At'
      ];
      headers.addAll(fields.map((field) => field.label));

      // Build CSV rows
      final rows = <List<String>>[];
      for (final submission in submissions) {
        final row = [
          submission.userId ?? '',
          submission.guestToken ?? '',
          submission.status.name,
          submission.createdAt.toIso8601String(),
          submission.updatedAt.toIso8601String(),
        ];

        // Add field values
        for (final field in fields) {
          final value = submission.getAnswer(field.id);
          row.add(_formatValueForCSV(field, value));
        }

        rows.add(row);
      }

      // Combine header and rows
      final csvLines = [headers.join(',')];
      csvLines.addAll(rows.map((row) => row.join(',')));

      return csvLines.join('\n');
    } catch (e) {
      throw Exception('Failed to export submissions: $e');
    }
  }

  String _formatValueForCSV(FormFieldDef field, dynamic value) {
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
          return value.join('; ');
        }
        return value.toString();
      case FormFieldType.checkbox:
        return value == true ? 'Yes' : 'No';
      default:
        return value.toString();
    }
  }

  /// Check if a submission is valid for RSVP acceptance
  Future<bool> isValidForRSVP(
    String meetingId,
    String formId,
    List<FormFieldDef> fields, {
    String? userId,
    String? guestToken,
  }) async {
    try {
      final submission = await _getExistingSubmission(
        meetingId,
        formId,
        userId: userId,
        guestToken: guestToken,
      );

      if (submission == null || !submission.isSubmitted) {
        return false;
      }

      return _runtimeService.isValidForRSVP(fields, submission.answers);
    } catch (e) {
      return false;
    }
  }
}
