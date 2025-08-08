import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_meta.dart';
import '../services/user_meta_service.dart';
import '../services/pwa_prompt_service.dart';

// Current user's PWA metadata
final userMetaProvider = StreamProvider<UserMeta?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return UserMetaService.getUserMetaStream(user.uid);
});

// PWA installation status
final pwaInstallStatusProvider = StateProvider<bool>((ref) {
  return PwaPromptService.isPwaInstalled;
});

// PWA install prompt availability
final pwaInstallPromptAvailableProvider = StateProvider<bool>((ref) {
  return PwaPromptService.isInstallPromptAvailable;
});

// Should show PWA prompt logic
final shouldShowPwaPromptProvider = Provider<bool>((ref) {
  final userMeta = ref.watch(userMetaProvider);
  final isInstalled = ref.watch(pwaInstallStatusProvider);
  final isPromptAvailable = ref.watch(pwaInstallPromptAvailableProvider);

  if (isInstalled || !isPromptAvailable || !PwaPromptService.isMobileDevice) {
    return false;
  }

  return userMeta.when(
    data: (meta) => meta?.shouldShowPwaPrompt ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

// PWA prompt service notifier
class PwaPromptNotifier extends StateNotifier<AsyncValue<void>> {
  PwaPromptNotifier() : super(const AsyncValue.data(null));

  /// Handle meeting creation and check if PWA prompt should be shown
  Future<bool> handleMeetingCreation(String? userId) async {
    state = const AsyncValue.loading();

    try {
      final shouldShow =
          await PwaPromptService.shouldShowPromptAfterMeeting(userId);
      state = const AsyncValue.data(null);
      return shouldShow;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  /// Mark PWA as installed
  Future<void> markPwaAsInstalled(String? userId) async {
    state = const AsyncValue.loading();

    try {
      await UserMetaService.markPwaAsInstalled(userId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Show PWA install prompt
  Future<bool> showInstallPrompt() async {
    try {
      return await PwaPromptService.showInstallPrompt();
    } catch (error) {
      print('Error showing PWA install prompt: $error');
      return false;
    }
  }

  /// Update prompt shown timestamp
  Future<void> updatePromptShown(String? userId) async {
    try {
      await UserMetaService.updateLastPwaPromptShown(userId);
    } catch (error) {
      print('Error updating prompt shown: $error');
    }
  }
}

final pwaPromptNotifierProvider =
    StateNotifierProvider<PwaPromptNotifier, AsyncValue<void>>((ref) {
  return PwaPromptNotifier();
});

// Device capability providers
final isMobileDeviceProvider = Provider<bool>((ref) {
  return PwaPromptService.isMobileDevice;
});

final isIosDeviceProvider = Provider<bool>((ref) {
  return PwaPromptService.isIosDevice;
});

final isAndroidDeviceProvider = Provider<bool>((ref) {
  return PwaPromptService.isAndroidDevice;
});

final supportsPwaProvider = Provider<bool>((ref) {
  return PwaPromptService.supportsPwa;
});
