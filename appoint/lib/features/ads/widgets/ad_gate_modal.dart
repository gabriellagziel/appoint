import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/ad_gate_controller.dart';
import '../models/ad_impression.dart';

class AdGateModal extends ConsumerStatefulWidget {
  final AdImpressionType type;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const AdGateModal({
    super.key,
    required this.type,
    this.onComplete,
    this.onSkip,
  });

  @override
  ConsumerState<AdGateModal> createState() => _AdGateModalState();
}

class _AdGateModalState extends ConsumerState<AdGateModal>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _pulseController;
  int _remainingSeconds = 10;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _startTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.forward();
    _timerController.addListener(() {
      final remaining = (10 * (1 - _timerController.value)).round();
      if (remaining != _remainingSeconds) {
        setState(() {
          _remainingSeconds = remaining;
        });
      }
    });

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _completeAd();
      }
    });
  }

  void _completeAd() {
    setState(() {
      _isCompleted = true;
    });

    // Show completion animation
    _pulseController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 1), () {
      _pulseController.stop();
      widget.onComplete?.call();
    });
  }

  void _skipAd() {
    final controller = ref.read(adGateControllerProvider.notifier);
    controller.skipAdGate(widget.type);
    widget.onSkip?.call();
  }

  void _closeAd() {
    final controller = ref.read(adGateControllerProvider.notifier);
    controller.closeAdGate(widget.type);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _closeAd();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.play_circle,
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Watch Ad to Continue',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _closeAd,
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Mock Ad Content
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Stack(
                  children: [
                    // Mock ad content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Mock Advertisement',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This is a placeholder for real ads',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Timer overlay
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_remainingSeconds',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    // Skip button (only after 5 seconds)
                    if (_remainingSeconds <= 5)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: TextButton(
                          onPressed: _skipAd,
                          child: const Text(
                            'Skip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Progress bar
              LinearProgressIndicator(
                value: _timerController.value,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isCompleted ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              // Status text
              Text(
                _isCompleted
                    ? 'Ad completed! You can now continue.'
                    : 'Please watch the ad to continue',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _isCompleted ? Colors.green : Colors.grey[600],
                      fontWeight:
                          _isCompleted ? FontWeight.w600 : FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),

              if (_isCompleted) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: widget.onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
