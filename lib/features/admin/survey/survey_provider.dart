import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/admin/survey/survey_service.dart';

// Provider for SurveyService
final surveyServiceProvider = Provider<SurveyService>((final ref) {
  return SurveyService();
});

// Provider for surveys stream
final surveysStreamProvider = StreamProvider<List<Map<String, dynamic>>>((final ref) {
  final surveyService = ref.watch(surveyServiceProvider);
  return surveyService.fetchSurveys();
});

// Provider for survey responses
final surveyResponsesProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((final ref, final surveyId) {
  final surveyService = ref.watch(surveyServiceProvider);
  return surveyService.getSurveyResponses(surveyId);
});

// Notifier for survey actions
class SurveyNotifier extends StateNotifier<AsyncValue<void>> {
  final SurveyService _surveyService;

  SurveyNotifier(this._surveyService) : super(const AsyncValue.data(null));

  Future<void> submitResponse(
      final String surveyId, final Map<String, dynamic> response) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.submitResponse(surveyId, response);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createSurvey(final Map<String, dynamic> surveyData) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.createSurvey(surveyData);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSurvey(
      final String surveyId, final Map<String, dynamic> updates) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.updateSurvey(surveyId, updates);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSurvey(final String surveyId) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.deleteSurvey(surveyId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Provider for SurveyNotifier
final surveyNotifierProvider =
    StateNotifierProvider<SurveyNotifier, AsyncValue<void>>((final ref) {
  final surveyService = ref.watch(surveyServiceProvider);
  return SurveyNotifier(surveyService);
});
