import 'package:flutter/material.dart';

/// Animates its child fading in while sliding from a given [direction].
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    super.key,
    this.direction = AxisDirection.down,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
  });

  final Widget child;
  final AxisDirection direction;
  final Duration duration;
  final Duration delay;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _offset = Tween<Offset>(
      begin: _offsetForDirection(widget.direction),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, final child) => Opacity(
          opacity: _opacity.value,
          child: SlideTransition(position: _offset, child: child),
        ),
        child: widget.child,
      );

  static Offset _offsetForDirection(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 0.2);
      case AxisDirection.down:
        return const Offset(0, -0.2);
      case AxisDirection.left:
        return const Offset(0.2, 0);
      case AxisDirection.right:
        return const Offset(-0.2, 0);
    }
  }
}
