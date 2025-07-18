import 'package:appoint/models/smart_share_link.dart';
import 'package:appoint/services/whatsapp_share_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for WhatsAppShareService
final whatsappShareServiceProvider =
    Provider<WhatsAppShareService>((ref) => WhatsAppShareService());

// Provider for share statistics
final FutureProviderFamily<Map<String, dynamic>, String> shareStatsProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, final meetingId) async {
    final service = ref.read(whatsappShareServiceProvider);
    return service.getShareStats(meetingId);
  },
);

// Provider for group recognition
final FutureProviderFamily<GroupRecognition?, String> groupRecognitionProvider =
    FutureProvider.family<GroupRecognition?, String>(
  (ref, final phoneNumber) async {
    final service = ref.read(whatsappShareServiceProvider);
    return service.recognizeGroup(phoneNumber);
  },
);

// State notifier for share dialog
class ShareDialogState {

  const ShareDialogState({
    this.isLoading = false,
    this.error,
    this.showGroupOptions = false,
    this.knownGroups = const [],
  });
  final bool isLoading;
  final String? error;
  final bool showGroupOptions;
  final List<GroupRecognition> knownGroups;

  ShareDialogState copyWith({
    final bool? isLoading,
    final String? error,
    final bool? showGroupOptions,
    final List<GroupRecognition>? knownGroups,
  }) => ShareDialogState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      showGroupOptions: showGroupOptions ?? this.showGroupOptions,
      knownGroups: knownGroups ?? this.knownGroups,
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
    state = state.copyWith();
  }

  void toggleGroupOptions() {
    state = state.copyWith(showGroupOptions: !state.showGroupOptions);
  }
}

final shareDialogProvider =
    StateNotifierProvider<ShareDialogNotifier, ShareDialogState>(
  (ref) => ShareDialogNotifier(ref.read(whatsappShareServiceProvider)),
);
