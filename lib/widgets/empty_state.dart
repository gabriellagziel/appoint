import 'package:appoint/theme/app_spacing.dart';
import 'package:appoint/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Themed empty state with optional call to action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.description,
    super.key,
    this.icon = Icons.inbox,
    this.onPressed,
    this.buttonLabel,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              if (onPressed != null && buttonLabel != null) ...[
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonLabel!, style: AppTextStyles.button),
                ),
              ],
            ],
          ),
        ),
      );
}
