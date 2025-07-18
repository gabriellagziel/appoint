import 'package:flutter/material.dart';

/// Button with proper semantics and minimum tap target.
class SemanticButton extends StatelessWidget {
  const SemanticButton({
    required this.onPressed, required this.label, required this.child, super.key,
  });

  final VoidCallback onPressed;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        hoverColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: Center(child: child),
        ),
      ),
    );
}
