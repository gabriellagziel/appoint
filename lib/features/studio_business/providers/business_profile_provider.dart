import 'package:appoint/features/studio_business/models/business_profile.dart';
import 'package:appoint/features/studio_business/services/business_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    try {
      final profile = await _service.fetchProfile();
      state = profile;
    } catch (e) {
      // Profile not found, create default
      state = null;
    }
  }

  void updateField({
    String? name,
    String? description,
    String? phone,
    String? email,
    String? address,
    String? website,
    List<String>? services,
    Map<String, dynamic>? businessHours,
    String? logoUrl,
    String? coverImageUrl,
  }) {
    if (state == null) return;
    
    state = state!.copyWith(
      name: name ?? state!.name,
      description: description ?? state!.description,
      phone: phone ?? state!.phone,
      email: email ?? state!.email,
      address: address ?? state!.address,
      website: website ?? state!.website,
      services: services ?? state!.services,
      businessHours: businessHours ?? state!.businessHours,
      logoUrl: logoUrl ?? state!.logoUrl,
      coverImageUrl: coverImageUrl ?? state!.coverImageUrl,
      updatedAt: DateTime.now(),
    );
  }

  void updateProfile(BusinessProfile profile) {
    state = profile;
  }

  Future<void> save() async {
    if (state == null) return;
    await _service.updateProfile(state!);
  }
}
