import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appoint/services/coppa_service.dart';

enum COPPAStatus {
  unknown,
  pending,
  parentContactSent,
  parentVerified,
  approved,
  denied,
  expired,
}

class COPPAFlowState {
  final COPPAStatus status;
  final String? parentEmail;
  final String? parentPhone;
  final DateTime? verificationSentAt;
  final DateTime? verificationExpiresAt;
  final String? verificationCode;
  final List<String> requiredParents;
  final List<String> approvedParents;
  final Map<String, dynamic>? childProfile;

  const COPPAFlowState({
    this.status = COPPAStatus.unknown,
    this.parentEmail,
    this.parentPhone,
    this.verificationSentAt,
    this.verificationExpiresAt,
    this.verificationCode,
    this.requiredParents = const [],
    this.approvedParents = const [],
    this.childProfile,
  });

  COPPAFlowState copyWith({
    COPPAStatus? status,
    String? parentEmail,
    String? parentPhone,
    DateTime? verificationSentAt,
    DateTime? verificationExpiresAt,
    String? verificationCode,
    List<String>? requiredParents,
    List<String>? approvedParents,
    Map<String, dynamic>? childProfile,
  }) {
    return COPPAFlowState(
      status: status ?? this.status,
      parentEmail: parentEmail ?? this.parentEmail,
      parentPhone: parentPhone ?? this.parentPhone,
      verificationSentAt: verificationSentAt ?? this.verificationSentAt,
      verificationExpiresAt: verificationExpiresAt ?? this.verificationExpiresAt,
      verificationCode: verificationCode ?? this.verificationCode,
      requiredParents: requiredParents ?? this.requiredParents,
      approvedParents: approvedParents ?? this.approvedParents,
      childProfile: childProfile ?? this.childProfile,
    );
  }
}

class COPPAFlowNotifier extends StateNotifier<COPPAFlowState> {
  COPPAFlowNotifier(this._coppaService) : super(const COPPAFlowState());

  final COPPAService _coppaService;

  /// Send email verification to parent
  Future<void> sendParentEmailVerification(String email, DateTime birthDate, int age) async {
    try {
      state = state.copyWith(status: COPPAStatus.pending);

      final result = await _coppaService.sendParentEmailVerification(email, birthDate, age);

      state = state.copyWith(
        status: COPPAStatus.parentContactSent,
        parentEmail: email,
        verificationSentAt: result['sentAt'],
        verificationExpiresAt: result['expiresAt'],
        verificationCode: result['verificationCode'],
      );

      // Create pending child account with restricted access
      await _coppaService.createPendingChildAccount(email, birthDate, age);
    } catch (e) {
      state = state.copyWith(status: COPPAStatus.unknown);
      rethrow;
    }
  }

  /// Send phone verification to parent
  Future<void> sendParentPhoneVerification(String phone, DateTime birthDate, int age) async {
    try {
      state = state.copyWith(status: COPPAStatus.pending);

      final result = await _coppaService.sendParentPhoneVerification(phone, birthDate, age);

      state = state.copyWith(
        status: COPPAStatus.parentContactSent,
        parentPhone: phone,
        verificationSentAt: result['sentAt'],
        verificationExpiresAt: result['expiresAt'],
        verificationCode: result['verificationCode'],
      );

      // Create pending child account with restricted access
      await _coppaService.createPendingChildAccount(phone, birthDate, age);
    } catch (e) {
      state = state.copyWith(status: COPPAStatus.unknown);
      rethrow;
    }
  }

  /// Check current COPPA status for a user
  Future<void> checkCOPPAStatus(String userId) async {
    try {
      final status = await _coppaService.getCOPPAStatus(userId);
      
      state = state.copyWith(
        status: _mapStatusFromService(status['status']),
        parentEmail: status['parentEmail'],
        parentPhone: status['parentPhone'],
        verificationSentAt: status['verificationSentAt']?.toDate(),
        verificationExpiresAt: status['verificationExpiresAt']?.toDate(),
        requiredParents: List<String>.from(status['requiredParents'] ?? []),
        approvedParents: List<String>.from(status['approvedParents'] ?? []),
        childProfile: status['childProfile'],
      );
    } catch (e) {
      state = state.copyWith(status: COPPAStatus.unknown);
    }
  }

  /// Handle parent approval/denial
  Future<void> handleParentResponse(String verificationCode, bool approved) async {
    try {
      if (approved) {
        await _coppaService.approveChildAccount(verificationCode);
        state = state.copyWith(status: COPPAStatus.approved);
      } else {
        await _coppaService.denyChildAccount(verificationCode);
        state = state.copyWith(status: COPPAStatus.denied);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Add additional parent to family (dual-parent support)
  Future<void> addAdditionalParent(String parentContact, String contactMethod) async {
    try {
      await _coppaService.addAdditionalParent(parentContact, contactMethod);
      
      // Refresh status
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await checkCOPPAStatus(currentUser.uid);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Remove parent from family
  Future<void> removeParent(String parentId) async {
    try {
      await _coppaService.removeParent(parentId);
      
      // Refresh status
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await checkCOPPAStatus(currentUser.uid);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Request account deletion (GDPR-K compliance)
  Future<void> requestChildAccountDeletion(String reason) async {
    try {
      await _coppaService.requestChildAccountDeletion(reason);
      state = state.copyWith(status: COPPAStatus.pending);
    } catch (e) {
      rethrow;
    }
  }

  /// Resend verification if expired
  Future<void> resendVerification() async {
    try {
      if (state.parentEmail != null) {
        await _coppaService.resendEmailVerification(state.parentEmail!);
      } else if (state.parentPhone != null) {
        await _coppaService.resendPhoneVerification(state.parentPhone!);
      }

      state = state.copyWith(
        status: COPPAStatus.parentContactSent,
        verificationSentAt: DateTime.now(),
        verificationExpiresAt: DateTime.now().add(const Duration(hours: 48)),
      );
    } catch (e) {
      rethrow;
    }
  }

  COPPAStatus _mapStatusFromService(String? status) {
    switch (status) {
      case 'pending':
        return COPPAStatus.pending;
      case 'parent_contact_sent':
        return COPPAStatus.parentContactSent;
      case 'parent_verified':
        return COPPAStatus.parentVerified;
      case 'approved':
        return COPPAStatus.approved;
      case 'denied':
        return COPPAStatus.denied;
      case 'expired':
        return COPPAStatus.expired;
      default:
        return COPPAStatus.unknown;
    }
  }

  void clearState() {
    state = const COPPAFlowState();
  }
}

final coppaServiceProvider = Provider<COPPAService>((ref) {
  return COPPAService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final coppaFlowProvider = StateNotifierProvider<COPPAFlowNotifier, COPPAFlowState>((ref) {
  final service = ref.watch(coppaServiceProvider);
  return COPPAFlowNotifier(service);
});

// Provider to check if current user needs COPPA compliance
final needsCOPPAProvider = FutureProvider<bool>((ref) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  
  if (user == null) return false;
  
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    if (!doc.exists) return false;
    
    final data = doc.data()!;
    final birthDate = (data['birthDate'] as Timestamp?)?.toDate();
    
    if (birthDate == null) return true; // No birth date = needs verification
    
    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    return age < 13; // Under 13 requires COPPA compliance
  } catch (e) {
    return false;
  }
});

// Provider to get COPPA compliance status for current user
final userCOPPAStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  
  if (user == null) return {'requiresCOPPA': false};
  
  try {
    final coppaService = ref.watch(coppaServiceProvider);
    return await coppaService.getCOPPAStatus(user.uid);
  } catch (e) {
    return {'requiresCOPPA': false, 'error': e.toString()};
  }
});