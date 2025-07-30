import 'package:appoint/models/family_link.dart';
import 'package:appoint/models/permission.dart';
import 'package:appoint/models/privacy_request.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/family_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Provider<FamilyService> familyServiceProvider =
    Provider((final _) => FamilyService());

/// Represents the loading state for family links
class FamilyLinksState {
  FamilyLinksState({
    this.isLoading = false,
    this.pendingInvites = const [],
    this.connectedChildren = const [],
    this.error,
  });
  final bool isLoading;
  final List<FamilyLink> pendingInvites;
  final List<FamilyLink> connectedChildren;
  final String? error;

  FamilyLinksState copyWith({
    final bool? isLoading,
    final List<FamilyLink>? pendingInvites,
    final List<FamilyLink>? connectedChildren,
    final String? error,
  }) =>
      FamilyLinksState(
        isLoading: isLoading ?? this.isLoading,
        pendingInvites: pendingInvites ?? this.pendingInvites,
        connectedChildren: connectedChildren ?? this.connectedChildren,
        error: error,
      );
}

/// StateNotifier for managing family links (invites and children)
class FamilyLinksNotifier extends StateNotifier<FamilyLinksState> {
  FamilyLinksNotifier(this._familyService, this.parentId)
      : super(FamilyLinksState()) {
    loadLinks();
  }
  final FamilyService _familyService;
  final String parentId;

  /// Load pending invites and connected children
  Future<void> loadLinks() async {
    state = state.copyWith(isLoading: true);
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
final StateNotifierProviderFamily<FamilyLinksNotifier, FamilyLinksState, String>
    familyLinksProvider =
    StateNotifierProvider.family<FamilyLinksNotifier, FamilyLinksState, String>(
  (ref, final String parentId) => FamilyLinksNotifier(
    ref.read(familyServiceProvider),
    parentId,
  ),
);

final AutoDisposeFutureProviderFamily<List<Permission>, String>
    permissionsProvider = FutureProvider.family
        .autoDispose<List<Permission>, String>((ref, final linkId) {
  final svc = ref.watch(familyServiceProvider);
  return svc.fetchPermissions(linkId);
});

final AutoDisposeFutureProvider<List<PrivacyRequest>> privacyRequestsProvider =
    FutureProvider.autoDispose<List<PrivacyRequest>>((ref) {
  final svc = ref.watch(familyServiceProvider);
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Future.value([]);
      return svc.fetchPrivacyRequests(user.uid);
    },
    loading: () => Future.value([]),
    error: (_, final __) => Future.value([]),
  );
});
