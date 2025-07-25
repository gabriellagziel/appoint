import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialAccountConflictDialog extends StatelessWidget {

  const SocialAccountConflictDialog({
    required this.error, super.key,
    this.onLinkAccounts,
    this.onSignInWithExistingMethod,
    this.onCancel,
  });
  final FirebaseAuthException error;
  final VoidCallback? onLinkAccounts;
  final VoidCallback? onSignInWithExistingMethod;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final conflictingEmail = error.email ?? 'this email';

    return AlertDialog(
      title: Text(l10n?.socialAccountConflictTitle ?? 'Account Conflict'),
      content: Text(
        l10n?.socialAccountConflictMessage(conflictingEmail) ?? 'An account with this email already exists.',
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: onSignInWithExistingMethod ??
              () => Navigator.of(context).pop('existing'),
          child: Text(l10n?.signInWithExistingMethod ?? 'Sign in with existing method'),
        ),
        ElevatedButton(
          onPressed: onLinkAccounts ?? () => Navigator.of(context).pop('link'),
          child: Text(l10n?.linkAccounts ?? 'Link Accounts'),
        ),
      ],
    );
  }
}
