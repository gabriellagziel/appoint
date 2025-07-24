import 'package:appoint/services/whatsapp_group_share_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for WhatsAppGroupShareService
final whatsappGroupShareServiceProvider = Provider<WhatsAppGroupShareService>(
  (ref) => WhatsAppGroupShareService(),
);

// Provider for appointment share analytics
final appointmentShareAnalyticsProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, appointmentId) async {
    final service = ref.read(whatsappGroupShareServiceProvider);
    return service.getAppointmentShareAnalytics(appointmentId);
  },
);

// State for WhatsApp group share dialog
class WhatsAppGroupShareState {
  const WhatsAppGroupShareState({
    this.isLoading = false,
    this.error,
    this.shareUrl,
  });

  final bool isLoading;
  final String? error;
  final String? shareUrl;

  WhatsAppGroupShareState copyWith({
    bool? isLoading,
    String? error,
    String? shareUrl,
  }) => WhatsAppGroupShareState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      shareUrl: shareUrl ?? this.shareUrl,
    );
}

class WhatsAppGroupShareNotifier extends StateNotifier<WhatsAppGroupShareState> {
  WhatsAppGroupShareNotifier(this._service) : super(const WhatsAppGroupShareState());

  final WhatsAppGroupShareService _service;

  Future<void> shareToWhatsAppGroup({
    required String appointmentId,
    required String creatorId,
    required String meetingTitle,
    required DateTime meetingDate,
    String? customMessage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _service.shareToWhatsAppGroup(
        appointmentId: appointmentId,
        creatorId: creatorId,
        meetingTitle: meetingTitle,
        meetingDate: meetingDate,
        customMessage: customMessage,
      );

      if (success) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to share to WhatsApp group',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> generateShareLink({
    required String appointmentId,
    required String creatorId,
    String? meetingTitle,
    DateTime? meetingDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final shareUrl = await _service.generateGroupShareLink(
        appointmentId: appointmentId,
        creatorId: creatorId,
        meetingTitle: meetingTitle,
        meetingDate: meetingDate,
      );

      state = state.copyWith(isLoading: false, shareUrl: shareUrl);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const WhatsAppGroupShareState();
  }
}

final whatsappGroupShareProvider =
    StateNotifierProvider<WhatsAppGroupShareNotifier, WhatsAppGroupShareState>(
  (ref) => WhatsAppGroupShareNotifier(ref.read(whatsappGroupShareServiceProvider)),
);