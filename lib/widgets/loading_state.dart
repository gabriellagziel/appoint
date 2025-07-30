import 'package:appoint/theme/app_spacing.dart';
import 'package:appoint/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Standard loading state with fade in animation.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(message!, style: AppTextStyles.body),
              ],
            ],
          ),
        ),
      );
}
