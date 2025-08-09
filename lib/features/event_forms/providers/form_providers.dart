import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/event_forms/models/meeting_form.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';
import 'package:appoint/features/event_forms/models/form_submission.dart';
import 'package:appoint/features/event_forms/services/form_builder_service.dart';
import 'package:appoint/features/event_forms/services/form_runtime_service.dart';
import 'package:appoint/features/event_forms/services/form_submission_service.dart';

// Services
final formBuilderServiceProvider = Provider<FormBuilderService>((ref) {
  return FormBuilderService();
});

final formRuntimeServiceProvider = Provider<FormRuntimeService>((ref) {
  return FormRuntimeService();
});

final formSubmissionServiceProvider = Provider<FormSubmissionService>((ref) {
  return FormSubmissionService();
});

// Active form with fields
final activeFormProvider =
    StreamProvider.family<MeetingForm?, String>((ref, meetingId) {
  final service = ref.watch(formBuilderServiceProvider);
  return service.getActiveForm(meetingId).asStream();
});

final formFieldsProvider =
    StreamProvider.family<List<FormFieldDef>, String>((ref, formId) {
  final service = ref.watch(formBuilderServiceProvider);
  // TODO: Get meetingId from formId or pass as parameter
  final meetingId = 'meeting-id'; // This should be derived from formId
  return service.getFields(meetingId, formId).asStream();
});

// Form with fields combined
final activeFormWithFieldsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, meetingId) async {
  final formAsync = ref.watch(activeFormProvider(meetingId));
  final form = await formAsync.value;

  if (form == null) return {};

  final fieldsAsync = ref.watch(formFieldsProvider(form.id));
  final fields = await fieldsAsync.value ?? [];

  return {
    'form': form,
    'fields': fields,
  };
});

// Form submissions
final formSubmissionProvider =
    StreamProvider.family<FormSubmission?, Map<String, dynamic>>((ref, params) {
  final meetingId = params['meetingId'] as String;
  final formId = params['formId'] as String;
  final userId = params['userId'] as String?;
  final guestToken = params['guestToken'] as String?;

  final service = ref.watch(formSubmissionServiceProvider);
  return service
      .getSubmission(
        meetingId,
        formId,
        userId: userId,
        guestToken: guestToken,
      )
      .asStream();
});

// All form submissions
final formSubmissionsProvider =
    StreamProvider.family<List<FormSubmission>, String>((ref, formId) {
  final service = ref.watch(formSubmissionServiceProvider);
  // TODO: Get meetingId from formId or pass as parameter
  final meetingId = 'meeting-id'; // This should be derived from formId
  return service.getFormSubmissions(meetingId, formId).asStream();
});

// Form statistics
final formStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, formId) {
  final service = ref.watch(formBuilderServiceProvider);
  // TODO: Get meetingId from formId or pass as parameter
  final meetingId = 'meeting-id'; // This should be derived from formId
  return service.getFormStats(meetingId, formId);
});

// Submission statistics
final submissionStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, formId) {
  final service = ref.watch(formSubmissionServiceProvider);
  // TODO: Get meetingId from formId or pass as parameter
  final meetingId = 'meeting-id'; // This should be derived from formId
  return service.getSubmissionStats(meetingId, formId);
});

// Action providers
class CreateFormNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    throw UnimplementedError();
  }

  Future<String> createForm(
      String meetingId, Map<String, dynamic> payload) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(formBuilderServiceProvider);
      final formId = await service.createForm(meetingId, payload);

      state = AsyncData(formId);

      // Invalidate related providers
      ref.invalidate(activeFormProvider(meetingId));

      return formId;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final createFormProvider =
    AsyncNotifierProvider<CreateFormNotifier, String>(() {
  return CreateFormNotifier();
});

class AddFieldNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    throw UnimplementedError();
  }

  Future<String> addField(
      String meetingId, String formId, FormFieldDef fieldDef) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(formBuilderServiceProvider);
      final fieldId = await service.addField(meetingId, formId, fieldDef);

      state = AsyncData(fieldId);

      // Invalidate related providers
      ref.invalidate(formFieldsProvider(formId));
      ref.invalidate(activeFormWithFieldsProvider(meetingId));

      return fieldId;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final addFieldProvider = AsyncNotifierProvider<AddFieldNotifier, String>(() {
  return AddFieldNotifier();
});

class UpdateFieldNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial state
  }

  Future<void> updateField(String meetingId, String formId, String fieldId,
      Map<String, dynamic> updates) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(formBuilderServiceProvider);
      await service.updateField(meetingId, formId, fieldId, updates);

      state = const AsyncData(null);

      // Invalidate related providers
      ref.invalidate(formFieldsProvider(formId));
      ref.invalidate(activeFormWithFieldsProvider(meetingId));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final updateFieldProvider =
    AsyncNotifierProvider<UpdateFieldNotifier, void>(() {
  return UpdateFieldNotifier();
});

class RemoveFieldNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial state
  }

  Future<void> removeField(
      String meetingId, String formId, String fieldId) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(formBuilderServiceProvider);
      await service.removeField(meetingId, formId, fieldId);

      state = const AsyncData(null);

      // Invalidate related providers
      ref.invalidate(formFieldsProvider(formId));
      ref.invalidate(activeFormWithFieldsProvider(meetingId));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final removeFieldProvider =
    AsyncNotifierProvider<RemoveFieldNotifier, void>(() {
  return RemoveFieldNotifier();
});

class ActivateFormNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial state
  }

  Future<void> activateForm(
      String meetingId, String formId, bool active) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(formBuilderServiceProvider);
      await service.activateForm(meetingId, formId, active);

      state = const AsyncData(null);

      // Invalidate related providers
      ref.invalidate(activeFormProvider(meetingId));
      ref.invalidate(activeFormWithFieldsProvider(meetingId));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final activateFormProvider =
    AsyncNotifierProvider<ActivateFormNotifier, void>(() {
  return ActivateFormNotifier();
});

class SubmitFormNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    throw UnimplementedError();
  }

  Future<String> submit(
    String meetingId,
    String formId,
    Map<String, dynamic> answers,
    List<FormFieldDef> fields, {
    String? userId,
    String? guestToken,
  }) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(formSubmissionServiceProvider);
      final submissionId = await service.submit(
        meetingId,
        formId,
        answers,
        fields,
        userId: userId,
        guestToken: guestToken,
      );

      state = AsyncData(submissionId);

      // Invalidate related providers
      ref.invalidate(formSubmissionProvider({
        'meetingId': meetingId,
        'formId': formId,
        'userId': userId,
        'guestToken': guestToken,
      }));
      ref.invalidate(formSubmissionsProvider(formId));
      ref.invalidate(submissionStatsProvider(formId));

      return submissionId;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final submitFormProvider =
    AsyncNotifierProvider<SubmitFormNotifier, String>(() {
  return SubmitFormNotifier();
});

class SaveDraftNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    throw UnimplementedError();
  }

  Future<String> saveDraft(
    String meetingId,
    String formId,
    Map<String, dynamic> answers, {
    String? userId,
    String? guestToken,
  }) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(formSubmissionServiceProvider);
      final submissionId = await service.saveDraft(
        meetingId,
        formId,
        answers,
        userId: userId,
        guestToken: guestToken,
      );

      state = AsyncData(submissionId);

      // Invalidate related providers
      ref.invalidate(formSubmissionProvider({
        'meetingId': meetingId,
        'formId': formId,
        'userId': userId,
        'guestToken': guestToken,
      }));
      ref.invalidate(formSubmissionsProvider(formId));
      ref.invalidate(submissionStatsProvider(formId));

      return submissionId;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final saveDraftProvider = AsyncNotifierProvider<SaveDraftNotifier, String>(() {
  return SaveDraftNotifier();
});

// UI state providers
final formAnswersProvider =
    StateProvider.family<Map<String, dynamic>, String>((ref, formId) {
  return {};
});

final formValidationErrorsProvider =
    StateProvider.family<Map<String, String>, String>((ref, formId) {
  return {};
});

final formCompletionProvider =
    StateProvider.family<double, String>((ref, formId) {
  return 0.0;
});
