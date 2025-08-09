import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/features/event_forms/models/meeting_form.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';

class FormBuilderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getCurrentUserId() {
    // TODO: Get from auth service
    return 'current-user-id';
  }

  /// Create a new form for a meeting
  Future<String> createForm(
      String meetingId, Map<String, dynamic> payload) async {
    try {
      final formData = {
        'meetingId': meetingId,
        'title': payload['title'] as String,
        'description': payload['description'] as String?,
        'active': payload['active'] as bool? ?? false,
        'requiredForAccept': payload['requiredForAccept'] as bool? ?? false,
        'createdBy': _getCurrentUserId(),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      final docRef = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .add(formData);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create form: $e');
    }
  }

  /// Add a field to a form
  Future<String> addField(
      String meetingId, String formId, FormFieldDef fieldDef) async {
    try {
      // Get the next order index
      final fieldsSnapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .collection('fields')
          .orderBy('orderIndex', descending: true)
          .limit(1)
          .get();

      final nextOrderIndex = fieldsSnapshot.docs.isEmpty
          ? 0
          : (fieldsSnapshot.docs.first.data()['orderIndex'] as int) + 1;

      final fieldData = fieldDef.copyWith(orderIndex: nextOrderIndex).toMap();
      fieldData['formId'] = formId;

      final docRef = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .collection('fields')
          .add(fieldData);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add field: $e');
    }
  }

  /// Update a field
  Future<void> updateField(String meetingId, String formId, String fieldId,
      Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .collection('fields')
          .doc(fieldId)
          .update({
        ...updates,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update field: $e');
    }
  }

  /// Remove a field
  Future<void> removeField(
      String meetingId, String formId, String fieldId) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .collection('fields')
          .doc(fieldId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove field: $e');
    }
  }

  /// Reorder fields
  Future<void> reorderFields(
      String meetingId, String formId, List<String> fieldIds) async {
    try {
      final batch = _firestore.batch();

      for (int i = 0; i < fieldIds.length; i++) {
        final fieldRef = _firestore
            .collection('meetings')
            .doc(meetingId)
            .collection('forms')
            .doc(formId)
            .collection('fields')
            .doc(fieldIds[i]);

        batch.update(fieldRef, {'orderIndex': i});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to reorder fields: $e');
    }
  }

  /// Activate/deactivate a form
  Future<void> activateForm(
      String meetingId, String formId, bool active) async {
    try {
      // If activating, deactivate all other forms first
      if (active) {
        await _firestore
            .collection('meetings')
            .doc(meetingId)
            .collection('forms')
            .where('active', isEqualTo: true)
            .get()
            .then((snapshot) async {
          final batch = _firestore.batch();
          for (final doc in snapshot.docs) {
            batch.update(doc.reference, {'active': false});
          }
          await batch.commit();
        });
      }

      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .update({
        'active': active,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to activate form: $e');
    }
  }

  /// Update form metadata
  Future<void> updateForm(
      String meetingId, String formId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .update({
        ...updates,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update form: $e');
    }
  }

  /// Delete a form
  Future<void> deleteForm(String meetingId, String formId) async {
    try {
      // Delete all fields first
      final fieldsSnapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .collection('fields')
          .get();

      final batch = _firestore.batch();
      for (final doc in fieldsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(_firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete form: $e');
    }
  }

  /// Get form with fields
  Future<MeetingForm?> getForm(String meetingId, String formId) async {
    try {
      final doc = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .get();

      if (!doc.exists) return null;

      return MeetingForm.fromMap(formId, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get form: $e');
    }
  }

  /// Get all forms for a meeting
  Future<List<MeetingForm>> getForms(String meetingId) async {
    try {
      final snapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MeetingForm.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get forms: $e');
    }
  }

  /// Get active form for a meeting
  Future<MeetingForm?> getActiveForm(String meetingId) async {
    try {
      final snapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .where('active', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return MeetingForm.fromMap(doc.id, doc.data());
    } catch (e) {
      throw Exception('Failed to get active form: $e');
    }
  }

  /// Get fields for a form
  Future<List<FormFieldDef>> getFields(String meetingId, String formId) async {
    try {
      final snapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('forms')
          .doc(formId)
          .collection('fields')
          .orderBy('orderIndex')
          .get();

      return snapshot.docs
          .map((doc) => FormFieldDef.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get fields: $e');
    }
  }

  /// Get form statistics
  Future<Map<String, dynamic>> getFormStats(
      String meetingId, String formId) async {
    try {
      final submissionsSnapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('form_submissions')
          .where('formId', isEqualTo: formId)
          .get();

      final totalSubmissions = submissionsSnapshot.docs.length;
      final submittedCount = submissionsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'submitted')
          .length;
      final draftCount = totalSubmissions - submittedCount;

      return {
        'totalSubmissions': totalSubmissions,
        'submittedCount': submittedCount,
        'draftCount': draftCount,
        'completionRate': totalSubmissions > 0
            ? (submittedCount / totalSubmissions * 100).round()
            : 0,
      };
    } catch (e) {
      throw Exception('Failed to get form stats: $e');
    }
  }
}
