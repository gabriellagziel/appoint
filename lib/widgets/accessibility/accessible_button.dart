import 'package:flutter/material.dart';

/// A wrapper widget that provides proper accessibility semantics for buttons
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String label;
  final String? hint;
  final bool isEnabled;
  final bool isSemanticButton;

  const AccessibleButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.label,
    this.hint,
    this.isEnabled = true,
    this.isSemanticButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: isSemanticButton,
      enabled: isEnabled,
      child: ExcludeSemantics(
        child: child,
      ),
    );
  }
}

/// An accessible ElevatedButton with proper semantics
class AccessibleElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String label;
  final String? hint;
  final ButtonStyle? style;
  final bool isEnabled;

  const AccessibleElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.label,
    this.hint,
    this.style,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibleButton(
      onPressed: isEnabled ? onPressed : null,
      label: label,
      hint: hint,
      isEnabled: isEnabled,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: style,
        child: child,
      ),
    );
  }
}

/// An accessible TextButton with proper semantics
class AccessibleTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String label;
  final String? hint;
  final ButtonStyle? style;
  final bool isEnabled;

  const AccessibleTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.label,
    this.hint,
    this.style,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibleButton(
      onPressed: isEnabled ? onPressed : null,
      label: label,
      hint: hint,
      isEnabled: isEnabled,
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: style,
        child: child,
      ),
    );
  }
}

/// An accessible IconButton with proper semantics
class AccessibleIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final String? hint;
  final double? iconSize;
  final Color? color;
  final bool isEnabled;

  const AccessibleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.hint,
    this.iconSize,
    this.color,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibleButton(
      onPressed: isEnabled ? onPressed : null,
      label: label,
      hint: hint,
      isEnabled: isEnabled,
      child: IconButton(
        onPressed: isEnabled ? onPressed : null,
        icon: icon,
        iconSize: iconSize,
        color: color,
      ),
    );
  }
}

/// An accessible InkWell with proper semantics
class AccessibleInkWell extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final String label;
  final String? hint;
  final bool isEnabled;

  const AccessibleInkWell({
    super.key,
    required this.onTap,
    required this.child,
    required this.label,
    this.hint,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibleButton(
      onPressed: isEnabled ? onTap : null,
      label: label,
      hint: hint,
      isEnabled: isEnabled,
      isSemanticButton: false,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: child,
      ),
    );
  }
}

/// An accessible GestureDetector with proper semantics
class AccessibleGestureDetector extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final String label;
  final String? hint;
  final bool isEnabled;

  const AccessibleGestureDetector({
    super.key,
    required this.onTap,
    required this.child,
    required this.label,
    this.hint,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibleButton(
      onPressed: isEnabled ? onTap : null,
      label: label,
      hint: hint,
      isEnabled: isEnabled,
      isSemanticButton: false,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: child,
      ),
    );
  }
}
