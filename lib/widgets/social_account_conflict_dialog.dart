import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appoint/l10n/app_localizations.dart';

class SocialAccountConflictDialog extends StatelessWidget {
  final FirebaseAuthException error;
  final VoidCallback? onLinkAccounts;
  final VoidCallback? onSignInWithExistingMethod;
  final VoidCallback? onCancel;

  const SocialAccountConflictDialog({
    super.key,
    required this.error,
    this.onLinkAccounts,
    this.onSignInWithExistingMethod,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final conflictingEmail = error.email ?? 'this email';

    return AlertDialog(
      title: Text(l10n.socialAccountConflictTitle),
      content: Text(
        l10n.socialAccountConflictMessage(conflictingEmail),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: onSignInWithExistingMethod ??
              () => Navigator.of(context).pop('existing'),
          child: Text(l10n.signInWithExistingMethod),
        ),
        ElevatedButton(
          onPressed: onLinkAccounts ?? () => Navigator.of(context).pop('link'),
          child: Text(l10n.linkAccounts),
        ),
      ],
    );
  }
}
