import 'package:flutter/material.dart';

/// Provides a simple tap feedback by scaling the child.
/// Can wrap any widget that needs a pressed state animation.
class TapScaleFeedback extends StatefulWidget {
  const TapScaleFeedback({
    required this.child,
    super.key,
    this.onTap,
    this.scale = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  @override
  State<TapScaleFeedback> createState() => _TapScaleFeedbackState();
}

class _TapScaleFeedbackState extends State<TapScaleFeedback> {
  bool _pressed = false;

  void _handleDown(PointerDownEvent event) {
    setState(() => _pressed = true);
  }

  void _handleUp(PointerUpEvent event) {
    setState(() => _pressed = false);
  }

  void _handleCancel(PointerCancelEvent event) {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: _handleDown,
        onPointerUp: _handleUp,
        onPointerCancel: _handleCancel,
        child: AnimatedScale(
          scale: _pressed ? widget.scale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onTap,
            child: widget.child,
          ),
        ),
      );
}
