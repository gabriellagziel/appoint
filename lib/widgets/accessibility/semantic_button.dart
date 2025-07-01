import 'package:flutter/material.dart';

/// Button with proper semantics and minimum tap target.
class SemanticButton extends StatelessWidget {
  const SemanticButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.child,
  });

  final VoidCallback onPressed;
  final String label;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        hoverColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: Center(child: child),
        ),
      ),
    );
  }
}
