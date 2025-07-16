import 'package:appoint/features/studio_business/models/business_profile.dart';
import 'package:appoint/features/studio_business/services/business_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessProfileProvider =
    FutureProvider<BusinessProfile>((ref) async {
  final service = BusinessProfileService();
  return service.fetchProfile();
});

final businessProfileNotifierProvider =
    StateNotifierProvider<BusinessProfileNotifier, AsyncValue<BusinessProfile?>>(
  (ref) => BusinessProfileNotifier(),
);

class BusinessProfileNotifier extends StateNotifier<AsyncValue<BusinessProfile?>> {
  BusinessProfileNotifier() : super(const AsyncValue.loading()) {
    loadProfile();
  }

  final _service = BusinessProfileService();

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _service.fetchProfile();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateField({
    String? name,
    final String? description,
    final String? phone,
  }) {
    state.whenData((profile) {
      if (profile != null) {
        state = AsyncValue.data(profile.copyWith(
          name: name ?? profile.name,
          description: description ?? profile.description,
          phone: phone ?? profile.phone,
        ));
      }
    });
  }

  Future<void> save() async {
    final profile = state.value;
    if (profile == null) return;
    await _service.updateProfile(profile);
  }
}
