import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_link.dart';

// Family Provider
final familyProvider =
    StateNotifierProvider<FamilyNotifier, AsyncValue<List<FamilyLink>>>((ref) {
  return FamilyNotifier();
});

class FamilyNotifier extends StateNotifier<AsyncValue<List<FamilyLink>>> {
  FamilyNotifier() : super(const AsyncValue.loading());

  Future<void> loadFamilyLinks() async {
    state = const AsyncValue.loading();
    try {
      // TODO: Replace with actual Firestore call
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data([
        FamilyLink(
          id: 'demo-link-1',
          parentId: 'demo-parent-1733123456789',
          childId: 'demo-child-1733123456789',
          status: 'active',
          invitedAt: DateTime(2024, 1, 1, 12, 0), // Fixed: Use const DateTime
          consentedAt: [
            DateTime(2024, 1, 1, 12, 0)
          ], // Fixed: Use const DateTime
        ),
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Family Overview Provider
class FamilyOverview {
  final String parentId;
  final List<FamilyLink> connectedChildren;
  final List<FamilyLink> pendingInvites;
  final int totalSessions;
  final int completedReminders;

  FamilyOverview({
    required this.parentId,
    required this.connectedChildren,
    required this.pendingInvites,
    required this.totalSessions,
    required this.completedReminders,
  });
}

// Demo family overview for testing
final demoFamilyOverviewProvider = FutureProvider<FamilyOverview>((ref) async {
  return FamilyOverview(
    parentId: 'demo-parent-1733123456789',
    connectedChildren: [
      FamilyLink(
        id: 'demo-link-1',
        parentId: 'demo-parent-1733123456789',
        childId: 'demo-child-1733123456789',
        status: 'active',
        invitedAt: DateTime(2024, 1, 1, 12, 0), // Fixed: Use const DateTime
        consentedAt: [DateTime(2024, 1, 1, 12, 0)], // Fixed: Use const DateTime
      ),
    ],
    pendingInvites: [],
    totalSessions: 5,
    completedReminders: 3,
  );
});
