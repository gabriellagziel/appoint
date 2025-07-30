import 'package:appoint/services/whatsapp_share_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for WhatsAppShareService
final whatsappShareServiceProvider =
    Provider<WhatsAppShareService>((ref) => WhatsAppShareService());

// Provider for share statistics
final FutureProviderFamily<Map<String, dynamic>, String> shareStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
  (ref, final meetingId) async {
    final service = ref.read(whatsappShareServiceProvider);
    return service.getShareStats(meetingId);
  },
);

// State notifier for share dialog
class ShareDialogState {
  const ShareDialogState({
    this.isLoading = false,
    this.error,
  });
  final bool isLoading;
  final String? error;

  ShareDialogState copyWith({
    final bool? isLoading,
    final String? error,
  }) =>
      ShareDialogState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class ShareDialogNotifier extends StateNotifier<ShareDialogState> {
  ShareDialogNotifier(this._service) : super(const ShareDialogState());
  final WhatsAppShareService _service;

  Future<void> shareToWhatsApp({
    required final String meetingId,
    required final String creatorId,
    required final String customMessage,
    final String? contextId,
    final String? groupId,
    final String? recipientPhone,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final success = await _service.shareToWhatsApp(
        meetingId: meetingId,
        creatorId: creatorId,
        customMessage: customMessage,
        contextId: contextId,
        groupId: groupId,
        recipientPhone: recipientPhone,
      );

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to share to WhatsApp',
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith();
  }
}

final shareDialogProvider =
    StateNotifierProvider<ShareDialogNotifier, ShareDialogState>(
  (ref) => ShareDialogNotifier(ref.read(whatsappShareServiceProvider)),
);
