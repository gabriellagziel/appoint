import 'package:flutter/material.dart';

/// A [PageRoute] that fades and slides the new page in from a direction.
class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  FadeSlidePageRoute({
    required final Widget page,
    this.direction = AxisDirection.right,
    super.settings,
    Duration duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (_, final __, final ___) => page,
          transitionDuration: duration,
          transitionsBuilder: (
            final context,
            final animation,
            secondaryAnimation,
            final child,
          ) {
            final offsetAnimation = Tween<Offset>(
              begin: _offsetForDirection(direction),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            );

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  final AxisDirection direction;

  static Offset _offsetForDirection(AxisDirection direction) {
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
}
