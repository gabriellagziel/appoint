import 'package:flutter/material.dart';

/// Wraps child with fade and slide transition when it changes.
class AnimatedWrapper extends StatelessWidget {
  const AnimatedWrapper({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.direction = AxisDirection.down,
  });

  final Widget child;
  final Duration duration;
  final AxisDirection direction;

  Offset _offsetForDirection(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 0.1);
      case AxisDirection.down:
        return const Offset(0, -0.1);
      case AxisDirection.left:
        return const Offset(0.1, 0);
      case AxisDirection.right:
        return const Offset(-0.1, 0);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (child, final animation) {
          final offsetAnimation = Tween<Offset>(
            begin: _offsetForDirection(direction),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: child,
      );
}
