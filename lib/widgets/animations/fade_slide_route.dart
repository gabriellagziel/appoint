import 'package:flutter/material.dart';

/// Page route that fades and slides the new screen into view.
class FadeSlideRoute<T> extends PageRouteBuilder<T> {
  FadeSlideRoute({
    required final WidgetBuilder builder,
    this.duration = const Duration(milliseconds: 300),
    this.direction = AxisDirection.right,
  }) : super(
          pageBuilder: (context, final animation, final secondaryAnimation) =>
              builder(context),
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
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        );

  /// Duration of the transition.
  final Duration duration;

  /// Direction from which the screen slides in.
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

/// Example usage:
/// ```dart
/// Navigator.of(context).push(FadeSlideRoute(
///   builder: (_) => const NextScreen(),
/// ));
/// ```
