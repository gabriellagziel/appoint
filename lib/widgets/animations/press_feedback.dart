import 'package:flutter/material.dart';

/// Provides a subtle scale animation when the child is pressed.
class PressFeedback extends StatefulWidget {
  const PressFeedback({
    required this.child,
    super.key,
    this.onTap,
    this.duration = const Duration(milliseconds: 100),
    this.scale = 0.95,
  });

  /// Widget below this widget in the tree.
  final Widget child;

  /// Callback when the child is tapped.
  final VoidCallback? onTap;

  /// Animation duration for press/release.
  final Duration duration;

  /// Scale factor when pressed.
  final double scale;

  @override
  State<PressFeedback> createState() => _PressFeedbackState();
}

class _PressFeedbackState extends State<PressFeedback> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? widget.scale : 1.0,
          duration: widget.duration,
          child: widget.child,
        ),
      );
}

/// Example usage:
/// ```dart
/// PressFeedback(
///   onTap: () {},
///   child: const Icon(Icons.favorite),
/// );
/// ```
