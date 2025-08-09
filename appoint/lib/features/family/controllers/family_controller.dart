import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_member_model.dart';

class FamilyController extends StateNotifier<List<FamilyMember>> {
  FamilyController() : super([]);

  Future<void> loadFamilyMembers() async {
    await Future.delayed(const Duration(seconds: 1));

    final mockMembers = [
      FamilyMember(
        id: '1',
        name: 'Sarah Johnson',
        email: 'sarah@example.com',
        role: FamilyRole.parent,
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
        approvalStatus: ApprovalStatus.approved,
      ),
      FamilyMember(
        id: '2',
        name: 'Mike Johnson',
        email: 'mike@example.com',
        role: FamilyRole.parent,
        joinedAt: DateTime.now().subtract(const Duration(days: 25)),
        approvalStatus: ApprovalStatus.approved,
      ),
      FamilyMember(
        id: '3',
        name: 'Emma Johnson',
        email: 'emma@example.com',
        role: FamilyRole.child,
        joinedAt: DateTime.now().subtract(const Duration(days: 20)),
        approvalStatus: ApprovalStatus.approved,
      ),
      FamilyMember(
        id: '4',
        name: 'Alex Johnson',
        email: 'alex@example.com',
        role: FamilyRole.child,
        joinedAt: DateTime.now().subtract(const Duration(days: 15)),
        approvalStatus: ApprovalStatus.pending,
        invitedBy: '1',
      ),
    ];

    state = mockMembers;
  }

  Future<bool> inviteFamilyMember({
    required String name,
    required String email,
    required FamilyRole role,
    required String invitedBy,
  }) async {
    try {
      final newMember = FamilyMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        joinedAt: DateTime.now(),
        approvalStatus: role == FamilyRole.child
            ? ApprovalStatus.pending
            : ApprovalStatus.approved,
        invitedBy: invitedBy,
      );

      await Future.delayed(const Duration(seconds: 1));
      state = [...state, newMember];
      return true;
    } catch (e) {
      print('Error inviting family member: $e');
      return false;
    }
  }

  Future<bool> approveChild(String memberId) async {
    try {
      final updatedMembers = state.map((member) {
        if (member.id == memberId) {
          return member.copyWith(approvalStatus: ApprovalStatus.approved);
        }
        return member;
      }).toList();

      await Future.delayed(const Duration(seconds: 1));
      state = updatedMembers;
      return true;
    } catch (e) {
      print('Error approving child: $e');
      return false;
    }
  }

  Future<bool> denyChild(String memberId) async {
    try {
      final updatedMembers = state.map((member) {
        if (member.id == memberId) {
          return member.copyWith(approvalStatus: ApprovalStatus.denied);
        }
        return member;
      }).toList();

      await Future.delayed(const Duration(seconds: 1));
      state = updatedMembers;
      return true;
    } catch (e) {
      print('Error denying child: $e');
      return false;
    }
  }

  List<FamilyMember> getPendingApprovals() {
    return state.where((member) => member.isPendingApproval).toList();
  }

  List<FamilyMember> getChildren() {
    return state.where((member) => member.isChild).toList();
  }

  List<FamilyMember> getParents() {
    return state.where((member) => member.isParent).toList();
  }

  String generateInviteCode() {
    return 'FAM${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6)}';
  }
}

final familyControllerProvider =
    StateNotifierProvider<FamilyController, List<FamilyMember>>((ref) {
  return FamilyController();
});

final pendingApprovalsProvider = Provider<List<FamilyMember>>((ref) {
  final controller = ref.watch(familyControllerProvider.notifier);
  return controller.getPendingApprovals();
});

final childrenProvider = Provider<List<FamilyMember>>((ref) {
  final controller = ref.watch(familyControllerProvider.notifier);
  return controller.getChildren();
});
