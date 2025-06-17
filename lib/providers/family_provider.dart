import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_link.dart';
import '../models/permission.dart';
import '../models/privacy_request.dart';
import '../services/family_service.dart';
import 'auth_provider.dart';

final familyServiceProvider = Provider((_) => FamilyService());

/// Represents the loading state for family links
class FamilyLinksState {
  final bool isLoading;
  final List<FamilyLink> pendingInvites;
  final List<FamilyLink> connectedChildren;
  final String? error;

  FamilyLinksState({
    this.isLoading = false,
    this.pendingInvites = const [],
    this.connectedChildren = const [],
    this.error,
  });

  FamilyLinksState copyWith({
    bool? isLoading,
    List<FamilyLink>? pendingInvites,
    List<FamilyLink>? connectedChildren,
    String? error,
  }) {
    return FamilyLinksState(
      isLoading: isLoading ?? this.isLoading,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      connectedChildren: connectedChildren ?? this.connectedChildren,
      error: error,
    );
  }
}

/// StateNotifier for managing family links (invites and children)
class FamilyLinksNotifier extends StateNotifier<FamilyLinksState> {
  final FamilyService _familyService;
  final String parentId;

  FamilyLinksNotifier(this._familyService, this.parentId)
      : super(FamilyLinksState()) {
    loadLinks();
  }

  /// Load pending invites and connected children
  Future<void> loadLinks() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final links = await _familyService.fetchFamilyLinks(parentId);
      state = state.copyWith(
        isLoading: false,
        pendingInvites: links.where((l) => l.status == 'pending').toList(),
        connectedChildren: links.where((l) => l.status == 'active').toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Cancel a pending invite
  Future<void> cancelInvite(FamilyLink link) async {
    try {
      await _familyService.cancelInvite(parentId, link.childId);
      await loadLinks();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Resend OTP for a pending invite
  Future<void> resendInvite(FamilyLink link) async {
    try {
      await _familyService.resendOtp(parentId, link.childId);
      // Optionally notify user via analytics or toast
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provider for FamilyLinksNotifier, requires parentId from auth
final familyLinksProvider =
    StateNotifierProvider.family<FamilyLinksNotifier, FamilyLinksState, String>(
  (ref, String parentId) => FamilyLinksNotifier(
    ref.read(familyServiceProvider),
    parentId,
  ),
);

final permissionsProvider =
    FutureProvider.family.autoDispose<List<Permission>, String>((ref, linkId) {
  final svc = ref.watch(familyServiceProvider);
  return svc.fetchPermissions(linkId);
});

final privacyRequestsProvider =
    FutureProvider.autoDispose<List<PrivacyRequest>>((ref) {
  final svc = ref.watch(familyServiceProvider);
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Future.value([]);
      return svc.fetchPrivacyRequests(user.uid);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
});
