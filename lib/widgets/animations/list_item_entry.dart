import 'package:flutter/material.dart';

/// Animates a list item when it first appears.
class ListItemEntry extends StatefulWidget {
  const ListItemEntry({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.1),
  });

  /// The widget to animate in.
  final Widget child;

  /// Animation duration.
  final Duration duration;

  /// Delay before the animation starts.
  final Duration delay;

  /// Offset from which the item slides into place.
  final Offset offset;

  @override
  State<ListItemEntry> createState() => _ListItemEntryState();
}

class _ListItemEntryState extends State<ListItemEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _offsetAnimation = Tween<Offset>(begin: widget.offset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(widget.delay, _controller.forward);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: _offsetAnimation,
          child: widget.child,
        ),
      );
}

/// Example usage inside ListView.builder:
/// ```dart
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (_, index) => ListItemEntry(
///     delay: Duration(milliseconds: index * 50),
///     child: ListTile(title: Text(items[index])),
///   ),
/// );
/// ```
