import 'package:appoint/theme/app_spacing.dart';
import 'package:appoint/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Standard error state with optional retry action.
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.title,
    required this.description,
    super.key,
    this.onRetry,
  });

  final String title;
  final String description;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
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
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Try Again', style: AppTextStyles.button),
                ),
              ],
            ],
          ),
        ),
      );
}
