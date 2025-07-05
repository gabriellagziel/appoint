import 'package:flutter/material.dart';

/// Enhanced accessibility utilities and components
class AccessibilityEnhancements {
  /// Check if the app is running with accessibility features enabled
  static bool get isAccessibilityEnabled {
    return WidgetsBinding
            .instance.window.accessibilityFeatures.accessibleNavigation ||
        WidgetsBinding.instance.window.accessibilityFeatures.invertColors ||
        WidgetsBinding.instance.window.accessibilityFeatures.reduceMotion;
  }

  /// Check if screen reader is active
  static bool get isScreenReaderActive {
    return WidgetsBinding
        .instance.window.accessibilityFeatures.accessibleNavigation;
  }

  /// Check if high contrast is enabled
  static bool get isHighContrastEnabled {
    return WidgetsBinding.instance.window.accessibilityFeatures.highContrast;
  }

  /// Check if reduced motion is preferred
  static bool get isReducedMotionPreferred {
    return WidgetsBinding.instance.window.accessibilityFeatures.reduceMotion;
  }
}

/// Enhanced accessible text widget with proper semantics
class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticLabel;
  final bool excludeSemantics;

  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticLabel ?? text,
      excludeSemantics: excludeSemantics,
      child: Text(
        text,
        style: style?.copyWith(
          color: style?.color ?? theme.colorScheme.onSurface,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// Enhanced accessible image widget
class AccessibleImage extends StatelessWidget {
  final String imageUrl;
  final String altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AccessibleImage({
    super.key,
    required this.imageUrl,
    required this.altText,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: altText,
      image: true,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              );
        },
      ),
    );
  }
}

/// Enhanced accessible form field with proper labels and hints
class AccessibleFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;

  const AccessibleFormField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Enhanced accessible button with proper focus management
class AccessibleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String label;
  final String? hint;
  final ButtonStyle? style;
  final bool isEnabled;
  final bool autofocus;
  final FocusNode? focusNode;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.label,
    this.hint,
    this.style,
    this.isEnabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: isEnabled,
      child: Focus(
        autofocus: autofocus,
        focusNode: focusNode,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: style?.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return theme.colorScheme.onSurface.withOpacity(0.12);
              }
              return style?.backgroundColor?.resolve(states) ??
                  theme.colorScheme.primary;
            }),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Enhanced accessible card with proper semantics
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final String? semanticLabel;
  final bool isSelectable;
  final VoidCallback? onTap;

  const AccessibleCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.semanticLabel,
    this.isSelectable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      selected: isSelectable,
      child: Card(
        margin: margin ?? const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Enhanced accessible list tile with proper semantics
class AccessibleListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool isSelected;
  final bool enabled;

  const AccessibleListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.semanticLabel,
    this.isSelected = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      selected: isSelected,
      enabled: enabled,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: enabled ? onTap : null,
        selected: isSelected,
        enabled: enabled,
      ),
    );
  }
}

/// Enhanced accessible dialog with proper focus management
class AccessibleDialog extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final bool barrierDismissible;
  final Color? barrierColor;

  const AccessibleDialog({
    super.key,
    required this.child,
    this.semanticLabel,
    this.barrierDismissible = true,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Dialog(
        child: child,
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? semanticLabel,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => AccessibleDialog(
        semanticLabel: semanticLabel,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        child: child,
      ),
    );
  }
}

/// Enhanced accessible bottom sheet
class AccessibleBottomSheet extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final bool isScrollControlled;
  final bool enableDrag;
  final Color? backgroundColor;

  const AccessibleBottomSheet({
    super.key,
    required this.child,
    this.semanticLabel,
    this.isScrollControlled = false,
    this.enableDrag = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        color: backgroundColor,
        child: child,
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? semanticLabel,
    bool isScrollControlled = false,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      builder: (context) => AccessibleBottomSheet(
        semanticLabel: semanticLabel,
        isScrollControlled: isScrollControlled,
        enableDrag: enableDrag,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}

/// Enhanced accessible navigation drawer
class AccessibleNavigationDrawer extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;

  const AccessibleNavigationDrawer({
    super.key,
    required this.child,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Navigation drawer',
      child: Drawer(
        child: child,
      ),
    );
  }
}

/// Enhanced accessible app bar with proper semantics
class AccessibleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final String? semanticLabel;

  const AccessibleAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'App bar',
      header: true,
      child: AppBar(
        title: title,
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Enhanced accessible bottom navigation bar
class AccessibleBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final String? semanticLabel;

  const AccessibleBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Bottom navigation',
      child: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}

/// Enhanced accessible tab bar
class AccessibleTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final String? semanticLabel;

  const AccessibleTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Tab bar',
      child: TabBar(
        tabs: tabs,
        controller: controller,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Enhanced accessible tab bar view
class AccessibleTabBarView extends StatelessWidget {
  final List<Widget> children;
  final TabController? controller;
  final String? semanticLabel;

  const AccessibleTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Tab content',
      child: TabBarView(
        controller: controller,
        children: children,
      ),
    );
  }
}

/// Enhanced accessible scroll view
class AccessibleScrollView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final String? semanticLabel;
  final bool primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const AccessibleScrollView({
    super.key,
    required this.children,
    this.controller,
    this.semanticLabel,
    this.primary = true,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: SingleChildScrollView(
        controller: controller,
        primary: primary,
        physics: physics,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

/// Enhanced accessible grid view
class AccessibleGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final String? semanticLabel;

  const AccessibleGridView({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        children: children,
      ),
    );
  }
}

/// Enhanced accessible list view
class AccessibleListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final String? semanticLabel;
  final bool primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const AccessibleListView({
    super.key,
    required this.children,
    this.controller,
    this.semanticLabel,
    this.primary = true,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: ListView(
        controller: controller,
        primary: primary,
        physics: physics,
        children: children,
      ),
    );
  }
}

/// Enhanced accessible switch
class AccessibleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final String? hint;
  final bool enabled;

  const AccessibleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value.toString(),
      onTap: enabled ? () => onChanged?.call(!value) : null,
      child: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

/// Enhanced accessible checkbox
class AccessibleCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final String? hint;
  final bool enabled;

  const AccessibleCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value.toString(),
      onTap: enabled && value != null ? () => onChanged?.call(!value!) : null,
      child: Checkbox(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

/// Enhanced accessible radio button
class AccessibleRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;
  final String? hint;
  final bool enabled;

  const AccessibleRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: (value == groupValue).toString(),
      onTap: enabled ? () => onChanged?.call(value) : null,
      child: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

/// Enhanced accessible slider
class AccessibleSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String label;
  final String? hint;
  final bool enabled;

  const AccessibleSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.divisions,
    required this.label,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value.toString(),
      child: Slider(
        value: value,
        onChanged: enabled ? onChanged : null,
        min: min,
        max: max,
        divisions: divisions,
      ),
    );
  }
}

/// Enhanced accessible progress indicator
class AccessibleProgressIndicator extends StatelessWidget {
  final double? value;
  final String label;
  final String? hint;
  final Color? backgroundColor;
  final Color? valueColor;

  const AccessibleProgressIndicator({
    super.key,
    this.value,
    required this.label,
    this.hint,
    this.backgroundColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value?.toString() ?? 'Indeterminate',
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

/// Enhanced accessible circular progress indicator
class AccessibleCircularProgressIndicator extends StatelessWidget {
  final double? value;
  final String label;
  final String? hint;
  final Color? backgroundColor;
  final Color? valueColor;
  final double strokeWidth;

  const AccessibleCircularProgressIndicator({
    super.key,
    this.value,
    required this.label,
    this.hint,
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value?.toString() ?? 'Indeterminate',
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? Theme.of(context).colorScheme.primary),
        strokeWidth: strokeWidth,
      ),
    );
  }
}

/// Enhanced accessible icon
class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String label;
  final String? hint;

  const AccessibleIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    required this.label,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}

/// Enhanced accessible tooltip
class AccessibleTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final String? semanticLabel;

  const AccessibleTooltip({
    super.key,
    required this.message,
    required this.child,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? message,
      child: Tooltip(
        message: message,
        child: child,
      ),
    );
  }
}

/// Enhanced accessible snackbar
class AccessibleSnackBar extends StatelessWidget {
  final String content;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration? duration;
  final String? semanticLabel;

  const AccessibleSnackBar({
    super.key,
    required this.content,
    this.actionLabel,
    this.onAction,
    this.duration,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? content,
      liveRegion: true,
      child: SnackBar(
        content: Text(content),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel!,
                onPressed: onAction ?? () {},
              )
            : null,
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String content,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    String? semanticLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          label: semanticLabel ?? content,
          liveRegion: true,
          child: Text(content),
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel!,
                onPressed: onAction ?? () {},
              )
            : null,
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }
}

/// Enhanced accessible alert dialog
class AccessibleAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget>? actions;
  final String? semanticLabel;

  const AccessibleAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? title,
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    List<Widget>? actions,
    String? semanticLabel,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AccessibleAlertDialog(
        title: title,
        content: content,
        actions: actions,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

/// Enhanced accessible confirmation dialog
class AccessibleConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? semanticLabel;

  const AccessibleConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? title,
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmLabel,
    required String cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? semanticLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AccessibleConfirmationDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
