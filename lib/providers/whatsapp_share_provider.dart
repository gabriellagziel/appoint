import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/whatsapp_share_service.dart';
import 'package:appoint/models/smart_share_link.dart';

// Provider for WhatsAppShareService
final whatsappShareServiceProvider =
    Provider<WhatsAppShareService>((final ref) {
  return WhatsAppShareService();
});

// Provider for share statistics
final shareStatsProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (final ref, final meetingId) async {
    final service = ref.read(whatsappShareServiceProvider);
    return await service.getShareStats(meetingId);
  },
);

// Provider for group recognition
final groupRecognitionProvider =
    FutureProvider.family<GroupRecognition?, String>(
  (final ref, final phoneNumber) async {
    final service = ref.read(whatsappShareServiceProvider);
    return await service.recognizeGroup(phoneNumber);
  },
);

// State notifier for share dialog
class ShareDialogState {
  final bool isLoading;
  final String? error;
  final bool showGroupOptions;
  final List<GroupRecognition> knownGroups;

  const ShareDialogState({
    this.isLoading = false,
    this.error,
    this.showGroupOptions = false,
    this.knownGroups = const [],
  });

  ShareDialogState copyWith({
    final bool? isLoading,
    final String? error,
    final bool? showGroupOptions,
    final List<GroupRecognition>? knownGroups,
  }) {
    return ShareDialogState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      showGroupOptions: showGroupOptions ?? this.showGroupOptions,
      knownGroups: knownGroups ?? this.knownGroups,
    );
  }
}

class ShareDialogNotifier extends StateNotifier<ShareDialogState> {
  final WhatsAppShareService _service;

  ShareDialogNotifier(this._service) : super(const ShareDialogState());

  Future<void> shareToWhatsApp({
    required final String meetingId,
    required final String creatorId,
    required final String customMessage,
    final String? contextId,
    final String? groupId,
    final String? recipientPhone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

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

  Future<void> saveGroupForRecognition({
    required final String groupId,
    required final String groupName,
    required final String phoneNumber,
    required final String meetingId,
  }) async {
    try {
      await _service.saveGroupForRecognition(
        groupId: groupId,
        groupName: groupName,
        phoneNumber: phoneNumber,
        meetingId: meetingId,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void toggleGroupOptions() {
    state = state.copyWith(showGroupOptions: !state.showGroupOptions);
  }
}

final shareDialogProvider =
    StateNotifierProvider<ShareDialogNotifier, ShareDialogState>(
  (final ref) => ShareDialogNotifier(ref.read(whatsappShareServiceProvider)),
);
