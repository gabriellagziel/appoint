import 'package:appoint/features/admin/survey/survey_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for SurveyService
final surveyServiceProvider = Provider<SurveyService>((ref) => SurveyService());

// Provider for surveys stream
final surveysStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final surveyService = ref.watch(surveyServiceProvider);
  return surveyService.fetchSurveys();
});

// Provider for survey responses
final StreamProviderFamily<List<Map<String, dynamic>>, String> surveyResponsesProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>(
        (ref, final surveyId) {
  final surveyService = ref.watch(surveyServiceProvider);
  return surveyService.getSurveyResponses(surveyId);
});

// Notifier for survey actions
class SurveyNotifier extends StateNotifier<AsyncValue<void>> {

  SurveyNotifier(this._surveyService) : super(const AsyncValue.data(null));
  final SurveyService _surveyService;

  Future<void> submitResponse(
      String surveyId, final Map<String, dynamic> response,) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.submitResponse(surveyId, response);
      state = const AsyncValue.data(null);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createSurvey(Map<String, dynamic> surveyData) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.createSurvey(surveyData);
      state = const AsyncValue.data(null);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSurvey(
      String surveyId, final Map<String, dynamic> updates,) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.updateSurvey(surveyId, updates);
      state = const AsyncValue.data(null);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSurvey(String surveyId) async {
    state = const AsyncValue.loading();
    try {
      await _surveyService.deleteSurvey(surveyId);
      state = const AsyncValue.data(null);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Provider for SurveyNotifier
final surveyNotifierProvider =
    StateNotifierProvider<SurveyNotifier, AsyncValue<void>>((ref) {
  final surveyService = ref.watch(surveyServiceProvider);
  return SurveyNotifier(surveyService);
});
