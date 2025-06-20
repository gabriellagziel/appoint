import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/business_profile.dart';
import '../../../services/business_profile_service.dart';

final businessProfileProvider =
    StateNotifierProvider<BusinessProfileNotifier, BusinessProfile?>(
  (ref) => BusinessProfileNotifier(),
);

class BusinessProfileNotifier extends StateNotifier<BusinessProfile?> {
  BusinessProfileNotifier() : super(null) {
    loadProfile();
  }

  final _service = BusinessProfileService();

  Future<void> loadProfile() async {
    state = await _service.fetchProfile();
  }

  void updateField({String? name, String? description, String? phone}) {
    state = state?.copyWith(
      name: name ?? state!.name,
      description: description ?? state!.description,
      phone: phone ?? state!.phone,
    );
  }

  Future<void> save() async {
    if (state == null) return;
    await _service.saveProfile(state!);
  }
}
