import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/group_invite_link.dart';
import '../../../services/group_invite_service.dart';
import '../../../services/analytics/analytics_service.dart';

// Invite state sealed class
sealed class InviteState {
  const InviteState();
  
  T when<T>({
    required T Function() loading,
    required T Function(GroupInviteLink invite, String? src) valid,
    required T Function(String reason) invalid,
  }) {
    return switch (this) {
      InviteLoading() => loading(),
      InviteValid(invite: final invite, src: final src) => valid(invite, src),
      InviteInvalid(reason: final reason) => invalid(reason),
    };
  }
}

class InviteLoading extends InviteState {
  const InviteLoading();
}

class InviteValid extends InviteState {
  final GroupInviteLink invite;
  final String? src;
  
  const InviteValid(this.invite, this.src);
}

class InviteInvalid extends InviteState {
  final String reason;
  
  const InviteInvalid(this.reason);
}

class InviteController extends StateNotifier<InviteState> {
  final GroupInviteService _inviteService = GroupInviteService();
  
  InviteController() : super(const InviteLoading());

  /// Load invite by token
  Future<void> load(String token, {String? src}) async {
    state = const InviteLoading();
    
    try {
      final invite = await _inviteService.getInviteLink(token);
      
      if (invite == null) {
        state = const InviteInvalid('Invite not found');
        return;
      }
      
      if (invite.isExpired) {
        state = const InviteInvalid('This invite has expired');
        return;
      }
      
      if (invite.isConsumed) {
        state = const InviteInvalid('This invite has already been used');
        return;
      }
      
      state = InviteValid(invite, src);
      
    } catch (e) {
      state = InviteInvalid('Failed to load invite: ${e.toString()}');
    }
  }

  /// Accept the invite
  Future<void> acceptInvite(BuildContext context) async {
    final currentState = state;
    if (currentState is! InviteValid) return;
    
    try {
      // Check if user is logged in (mock for now)
      const isLoggedIn = false; // TODO: Check actual auth state
      
      if (!isLoggedIn) {
        // Trigger Google Sign-In (mock for now)
        await _triggerGoogleSignIn(context);
      }
      
      // Add participant to meeting
      await _inviteService.attachParticipant(
        meetingId: currentState.invite.meetingId,
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}', // Mock user ID
      );
      
      // Consume single-use invite
      if (currentState.invite.singleUse) {
        await _inviteService.consume(currentState.invite.token);
      }
      
      // Track analytics
      AnalyticsService.track("invite_accepted", {
        "token": currentState.invite.token,
        "src": currentState.src ?? "unknown",
        "meetingId": currentState.invite.meetingId,
      });
      
      // Navigate to meeting details
      context.go('/meeting/${currentState.invite.meetingId}');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join meeting: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Decline the invite
  Future<void> declineInvite(BuildContext context) async {
    final currentState = state;
    if (currentState is! InviteValid) return;
    
    try {
      // Track analytics
      AnalyticsService.track("invite_declined", {
        "token": currentState.invite.token,
        "src": currentState.src ?? "unknown",
        "meetingId": currentState.invite.meetingId,
      });
      
      // Show toast and navigate home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maybe later'),
          backgroundColor: Colors.blue,
        ),
      );
      
      Navigator.of(context).pushReplacementNamed('/');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Mock Google Sign-In
  Future<void> _triggerGoogleSignIn(BuildContext context) async {
    // TODO: Implement real Google Sign-In
    await Future.delayed(const Duration(seconds: 1));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed in successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// Riverpod provider
final inviteControllerProvider = StateNotifierProvider<InviteController, InviteState>((ref) {
  return InviteController();
});
