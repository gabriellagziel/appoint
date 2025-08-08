import 'package:flutter/material.dart';
import '../services/pwa_prompt_service.dart';
import '../services/analytics_service.dart';

class AddToHomeScreenDialog extends StatelessWidget {
  final VoidCallback? onAddNow;
  final VoidCallback? onNotNow;

  const AddToHomeScreenDialog({
    super.key,
    this.onAddNow,
    this.onNotNow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = PwaPromptService.isIosDevice;
    final isAndroid = PwaPromptService.isAndroidDevice;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header icon and title
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.home,
                size: 32,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Add App-Oint to Home Screen',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              '🔔 Tired of typing our name into Google?',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            Text(
              '➕ Add App-Oint to your Home Screen and use it like a real app!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Instructions based on device
            if (isAndroid) ...[
              _buildAndroidInstructions(theme),
            ] else if (isIos) ...[
              _buildIosInstructions(theme),
            ] else ...[
              _buildGenericInstructions(theme),
            ],

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      // Log analytics
                      await AnalyticsService.logPwaPromptDismissed(
                        device: PwaPromptService.isIosDevice
                            ? 'ios'
                            : (PwaPromptService.isAndroidDevice
                                ? 'android'
                                : 'other'),
                      );

                      // Snooze prompt
                      PwaPromptService.snoozePrompt();

                      Navigator.of(context).pop();
                      onNotNow?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final device = PwaPromptService.isIosDevice
                          ? 'ios'
                          : (PwaPromptService.isAndroidDevice
                              ? 'android'
                              : 'other');

                      // Log analytics
                      await AnalyticsService.logPwaInstallAccepted(
                          device: device);

                      Navigator.of(context).pop();

                      if (isAndroid &&
                          PwaPromptService.isInstallPromptAvailable) {
                        // Try to show native install prompt on Android
                        await PwaPromptService.showInstallPrompt();
                      }

                      onAddNow?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 20),
                        const SizedBox(width: 4),
                        Text(isAndroid ? 'Add Now' : 'Got It'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidInstructions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Android Instructions:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
              '1.', 'Tap the ⋮ menu (three dots) in your browser'),
          const SizedBox(height: 8),
          _buildInstructionStep('2.', 'Select "Add to Home screen"'),
          const SizedBox(height: 8),
          _buildInstructionStep('3.', 'Confirm by tapping "Add"'),
        ],
      ),
    );
  }

  Widget _buildIosInstructions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🍎', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'iPhone/iPad Instructions:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
              '1.', 'Tap the Share button (📤) at the bottom'),
          const SizedBox(height: 8),
          _buildInstructionStep(
              '2.', 'Scroll down and select "Add to Home Screen"'),
          const SizedBox(height: 8),
          _buildInstructionStep('3.', 'Tap "Add" in the top right corner'),
        ],
      ),
    );
  }

  Widget _buildGenericInstructions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📱', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Instructions:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionStep('1.', 'Look for your browser\'s menu button'),
          const SizedBox(height: 8),
          _buildInstructionStep(
              '2.', 'Find "Add to Home Screen" or "Install App"'),
          const SizedBox(height: 8),
          _buildInstructionStep('3.', 'Follow the prompts to install'),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            instruction,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  /// Show the dialog with proper context
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onAddNow,
    VoidCallback? onNotNow,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddToHomeScreenDialog(
        onAddNow: onAddNow,
        onNotNow: onNotNow,
      ),
    );
  }
}
