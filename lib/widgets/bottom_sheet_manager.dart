import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';

/// Shows a modal bottom sheet with consistent styling across the app.
Future<T?> showAppBottomSheet<T>(
  BuildContext context,
  Widget child,
) {
  return showModalBottomSheet<T>(
    context: context,
    barrierColor: Colors.black54,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => SafeArea(child: child),
  );
}

/// Basic confirmation bottom sheet with cancel/confirm actions.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    required this.onConfirm,
  });

  final String title;
  final String body;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                child: Text(l10n.confirm),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
