import 'package:flutter/material.dart';

/// Provides a simple tap feedback by scaling the child.
/// Can wrap any widget that needs a pressed state animation.
class TapScaleFeedback extends StatefulWidget {
  const TapScaleFeedback({
    super.key,
    required this.child,
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

  void _handleDown(final PointerDownEvent event) {
    setState(() => _pressed = true);
  }

  void _handleUp(final PointerUpEvent event) {
    setState(() => _pressed = false);
  }

  void _handleCancel(final PointerCancelEvent event) {
    setState(() => _pressed = false);
  }

  @override
  Widget build(final BuildContext context) {
    return Listener(
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
}
