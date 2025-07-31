import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityWrapper extends StatelessWidget {
  final Widget child;
  
  const AccessibilityWrapper({Key? key, required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: child,
    );
  }
}

// Accessibility helper functions
class A11yHelper {
  static Widget wrapWithSemantics({
    required Widget child,
    String? label,
    String? hint,
    bool? button,
    bool? focusable,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: button ?? false,
      focusable: focusable ?? true,
      child: child,
    );
  }
  
  static Widget accessibleButton({
    required String label,
    required VoidCallback onPressed,
    Widget? child,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child ?? Text(label),
      ),
    );
  }
}
