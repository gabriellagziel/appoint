import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/models/family_link.dart';
import 'package:appoint/models/privacy_request.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/family_provider.dart';
import 'package:appoint/providers/user_profile_provider.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:appoint/constants/app_branding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyDashboardScreen extends ConsumerWidget {
  const FamilyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return authState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(child: Text(l10n.pleaseLoginForFamilyFeatures)),
          );
        }

        final familyLinksState = ref.watch(familyLinksProvider(user.uid));
        final privacyRequestsAsync = ref.watch(privacyRequestsProvider);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const AppLogo(size: 24, logoOnly: true),
                const SizedBox(width: 8),
                Text(l10n.familyDashboard),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/family/invite'),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.read(familyLinksProvider(user.uid).notifier).loadLinks();
              ref.invalidate(privacyRequestsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildFamilyLinksSection(
                    context, ref, familyLinksState, user.uid,),
                const SizedBox(height: 24),
                _buildPrivacyRequestsSection(
                    context, ref, privacyRequestsAsync,),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, final stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildFamilyLinksSection(
    final BuildContext context,
    final WidgetRef ref,
    final FamilyLinksState familyLinksState,
    final String parentId,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.familyMembers,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/family/invite'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.invite),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (familyLinksState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (familyLinksState.error != null)
              Center(
                child: Text(
                  l10n.errorLoadingFamilyLinks(familyLinksState.error!),
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else ...[
              if (familyLinksState.pendingInvites.isNotEmpty) ...[
                // ignore: argument_type_not_assignable
                _buildSectionHeader(l10n.pendingInvites),
                const SizedBox(height: 8),
                ...familyLinksState.pendingInvites.map((link) =>
                    _buildPendingInviteCard(context, ref, link),),
                const SizedBox(height: 16),
              ],
              if (familyLinksState.connectedChildren.isNotEmpty) ...[
                // ignore: argument_type_not_assignable
                _buildSectionHeader(l10n.connectedChildren),
                const SizedBox(height: 8),
                ...familyLinksState.connectedChildren.map((link) =>
                    _buildConnectedChildCard(context, ref, link),),
              ],
              if (familyLinksState.pendingInvites.isEmpty &&
                  familyLinksState.connectedChildren.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      // ignore: argument_type_not_assignable
                      l10n.noFamilyMembersYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    );

  Widget _buildPendingInviteCard(
    final BuildContext context,
    final WidgetRef ref,
    final FamilyLink link,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.orange.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade200,
          child: const Icon(Icons.pending, color: Colors.orange),
        ),
        title: _buildChildNameWidget(context, ref, link),
        subtitle: Text(l10n.invited(link.invitedAt)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: () => _handleResendOtp(context, ref, link),
              tooltip: 'Resend OTP',
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _showCancelConfirmation(context, ref, link),
              tooltip: 'Cancel Invite',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedChildCard(
    final BuildContext context,
    final WidgetRef ref,
    final FamilyLink link,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.green.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade200,
          child: const Icon(Icons.check, color: Colors.green),
        ),
        title: _buildChildNameWidget(context, ref, link),
        subtitle: Text(
            'Connected: ${_formatDate(link.consentedAt.isNotEmpty ? link.consentedAt.last : link.invitedAt)}',),
        trailing: PopupMenuButton<String>(
          onSelected: (value) =>
              _handleConnectedChildAction(context, ref, link, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'permissions',
              // ignore: argument_type_not_assignable
              child: Text(l10n.managePermissions),
            ),
            PopupMenuItem(
              value: 'revoke',
              // ignore: argument_type_not_assignable
              child: Text(l10n.removeChild),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildNameWidget(
      BuildContext context, final WidgetRef ref, final FamilyLink link,) {
    final childProfileAsync = ref.watch(userProfileProvider(link.childId));

    return childProfileAsync.when(
      data: (profile) {
        if (profile != null && profile.name.isNotEmpty) {
          return Text(profile.name);
        }
        // Fallback to email or ID if no display name
        if (link.childId.contains('@')) {
          return Text(link.childId.split('@')[0]);
        } else if (link.childId.length > 8) {
          return Text('${link.childId.substring(0, 8)}...');
        }
        return Text(link.childId);
      },
      loading: () => Text(AppLocalizations.of(context)!.loading),
      error: (_, final __) {
        // Fallback to email or ID if profile loading fails
        if (link.childId.contains('@')) {
          return Text(link.childId.split('@')[0]);
        } else if (link.childId.length > 8) {
          return Text('${link.childId.substring(0, 8)}...');
        }
        return Text(link.childId);
      },
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  Future<void> _handleResendOtp(
    final BuildContext context,
    final WidgetRef ref,
    final FamilyLink link,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await ref
          .read(familyLinksProvider(link.parentId).notifier)
          .resendInvite(link);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.otpResentSuccessfully)),
        );
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToResendOtp(e))),
        );
    }
  }

  void _showCancelConfirmation(
    final BuildContext context,
    final WidgetRef ref,
    final FamilyLink link,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelInvite),
        content: Text(l10n.cancelInviteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(familyLinksProvider(link.parentId).notifier)
                    .cancelInvite(link);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.inviteCancelledSuccessfully)),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.failedToCancelInvite(e))),
                );
              }
            },
            child: Text(l10n.yesCancel),
          ),
        ],
      ),
    );
  }

  void _handleConnectedChildAction(
    final BuildContext context,
    final WidgetRef ref,
    final FamilyLink link,
    final String action,
  ) {
    switch (action) {
      case 'permissions':
        Navigator.of(context).pushNamed(
          '/family/permissions',
          arguments: link,
        );
        break;
      case 'revoke':
        _showRevokeConfirmation(context, ref, link);
        break;
    }
  }

  Widget _buildPrivacyRequestsSection(
    final BuildContext context,
    final WidgetRef ref,
    final AsyncValue<List<PrivacyRequest>> privacyRequestsAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            privacyRequestsAsync.when(
              data: (requests) => requests.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No pending privacy requests',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: requests
                          .map((request) =>
                              _buildPrivacyRequestCard(context, ref, request),)
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, final stack) => Center(
                child: Text(l10n.errorLoadingPrivacyRequests(error)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyRequestCard(final BuildContext context,
      WidgetRef ref, final PrivacyRequest request,) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.privacy_tip),
        title: Text(l10n.requestType(request.type)),
        subtitle: Text(l10n.statusColon(request.status)),
        trailing: request.status == 'pending'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _handlePrivacyRequestAction(
                        context, ref, request, 'approve',),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _handlePrivacyRequestAction(
                        context, ref, request, 'deny',),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Future<void> _handlePrivacyRequestAction(
      final BuildContext context,
      final WidgetRef ref,
      final PrivacyRequest request,
      String action,) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      // Get the family service and handle the privacy request
      final familyService = ref.read(familyServiceProvider);
      await familyService.handlePrivacyRequest(request.id, action);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Privacy request ${action == 'approve' ? 'approved' : 'denied'} successfully!'),
            backgroundColor: action == 'approve' ? Colors.green : Colors.red,
          ),
        );
      }

      // Refresh the privacy requests list
      ref.invalidate(privacyRequestsProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToActionPrivacyRequest(action, e)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRevokeConfirmation(
      BuildContext context, final WidgetRef ref, final FamilyLink link) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.revokeAccess),
        content: Text(l10n.revokeAccessConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                // Call family service to revoke access
                final familyService = ref.read(familyServiceProvider);
                await familyService.revokeAccess(link.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.accessRevokedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  // Refresh the family links
                  ref
                      .read(familyLinksProvider(link.parentId).notifier)
                      .loadLinks();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.failedToRevokeAccess(e)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(l10n.revoke),
          ),
        ],
      ),
    );
  }
