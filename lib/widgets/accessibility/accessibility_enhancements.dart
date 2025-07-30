import 'package:flutter/material.dart';

/// Enhanced accessibility utilities and components
class AccessibilityEnhancements {
  /// Check if the app is running with accessibility features enabled
  static bool get isAccessibilityEnabled =>
      WidgetsBinding
          .instance.window.accessibilityFeatures.accessibleNavigation ||
      WidgetsBinding.instance.window.accessibilityFeatures.invertColors ||
      WidgetsBinding.instance.window.accessibilityFeatures.reduceMotion;

  /// Check if screen reader is active
  static bool get isScreenReaderActive =>
      WidgetsBinding.instance.window.accessibilityFeatures.accessibleNavigation;

  /// Check if high contrast is enabled
  static bool get isHighContrastEnabled =>
      WidgetsBinding.instance.window.accessibilityFeatures.highContrast;

  /// Check if reduced motion is preferred
  static bool get isReducedMotionPreferred =>
      WidgetsBinding.instance.window.accessibilityFeatures.reduceMotion;
}

/// Enhanced accessible text widget with proper semantics
class AccessibleText extends StatelessWidget {
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
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticLabel;
  final bool excludeSemantics;

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
  const AccessibleImage({
    required this.imageUrl,
    required this.altText,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });
  final String imageUrl;
  final String altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) => Semantics(
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
          errorBuilder: (context, error, stackTrace) =>
              errorWidget ??
              Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
        ),
      );
}

/// Enhanced accessible form field with proper labels and hints
class AccessibleFormField extends StatelessWidget {
  const AccessibleFormField({
    required this.label,
    super.key,
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
  const AccessibleButton({
    required this.onPressed,
    required this.child,
    required this.label,
    super.key,
    this.hint,
    this.style,
    this.isEnabled = true,
    this.autofocus = false,
    this.focusNode,
  });
  final VoidCallback? onPressed;
  final Widget child;
  final String label;
  final String? hint;
  final ButtonStyle? style;
  final bool isEnabled;
  final bool autofocus;
  final FocusNode? focusNode;

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
                return theme.colorScheme.onSurface.withValues(alpha: 0.12);
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
  const AccessibleCard({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.borderRadius,
    this.semanticLabel,
    this.isSelectable = false,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final String? semanticLabel;
  final bool isSelectable;
  final VoidCallback? onTap;

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
  const AccessibleListTile({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.semanticLabel,
    this.isSelected = false,
    this.enabled = true,
  });
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool isSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Semantics(
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

/// Enhanced accessible dialog with proper focus management
class AccessibleDialog extends StatelessWidget {
  const AccessibleDialog({
    required this.child,
    super.key,
    this.semanticLabel,
    this.barrierDismissible = true,
    this.barrierColor,
  });
  final Widget child;
  final String? semanticLabel;
  final bool barrierDismissible;
  final Color? barrierColor;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel,
        child: Dialog(
          child: child,
        ),
      );

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? semanticLabel,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) =>
      showDialog<T>(
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

/// Enhanced accessible bottom sheet
class AccessibleBottomSheet extends StatelessWidget {
  const AccessibleBottomSheet({
    required this.child,
    super.key,
    this.semanticLabel,
    this.isScrollControlled = false,
    this.enableDrag = true,
    this.backgroundColor,
  });
  final Widget child;
  final String? semanticLabel;
  final bool isScrollControlled;
  final bool enableDrag;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel,
        child: Container(
          color: backgroundColor,
          child: child,
        ),
      );

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? semanticLabel,
    bool isScrollControlled = false,
    bool enableDrag = true,
    Color? backgroundColor,
  }) =>
      showModalBottomSheet<T>(
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

/// Enhanced accessible navigation drawer
class AccessibleNavigationDrawer extends StatelessWidget {
  const AccessibleNavigationDrawer({
    required this.child,
    super.key,
    this.semanticLabel,
  });
  final Widget child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel ?? 'Navigation drawer',
        child: Drawer(
          child: child,
        ),
      );
}

/// Enhanced accessible app bar with proper semantics
class AccessibleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AccessibleAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.semanticLabel,
  });
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel ?? 'App bar',
        header: true,
        child: AppBar(
          title: title,
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Enhanced accessible bottom navigation bar
class AccessibleBottomNavigationBar extends StatelessWidget {
  const AccessibleBottomNavigationBar({
    required this.items,
    required this.currentIndex,
    super.key,
    this.onTap,
    this.semanticLabel,
  });
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel ?? 'Bottom navigation',
        child: BottomNavigationBar(
          items: items,
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      );
}

/// Enhanced accessible tab bar
class AccessibleTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AccessibleTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.semanticLabel,
  });
  final List<Widget> tabs;
  final TabController? controller;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel ?? 'Tab bar',
        child: TabBar(
          tabs: tabs,
          controller: controller,
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Enhanced accessible tab bar view
class AccessibleTabBarView extends StatelessWidget {
  const AccessibleTabBarView({
    required this.children,
    super.key,
    this.controller,
    this.semanticLabel,
  });
  final List<Widget> children;
  final TabController? controller;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel ?? 'Tab content',
        child: TabBarView(
          controller: controller,
          children: children,
        ),
      );
}

/// Enhanced accessible scroll view
class AccessibleScrollView extends StatelessWidget {
  const AccessibleScrollView({
    required this.children,
    super.key,
    this.controller,
    this.semanticLabel,
    this.primary = true,
    this.physics,
    this.shrinkWrap = false,
  });
  final List<Widget> children;
  final ScrollController? controller;
  final String? semanticLabel;
  final bool primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) => Semantics(
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

/// Enhanced accessible grid view
class AccessibleGridView extends StatelessWidget {
  const AccessibleGridView({
    required this.children,
    required this.crossAxisCount,
    super.key,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.semanticLabel,
  });
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel,
        child: GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          children: children,
        ),
      );
}

/// Enhanced accessible list view
class AccessibleListView extends StatelessWidget {
  const AccessibleListView({
    required this.children,
    super.key,
    this.controller,
    this.semanticLabel,
    this.primary = true,
    this.physics,
    this.shrinkWrap = false,
  });
  final List<Widget> children;
  final ScrollController? controller;
  final String? semanticLabel;
  final bool primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel,
        child: ListView(
          controller: controller,
          primary: primary,
          physics: physics,
          children: children,
        ),
      );
}

/// Enhanced accessible switch
class AccessibleSwitch extends StatelessWidget {
  const AccessibleSwitch({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
    this.hint,
    this.enabled = true,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Semantics(
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

/// Enhanced accessible checkbox
class AccessibleCheckbox extends StatelessWidget {
  const AccessibleCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
    this.hint,
    this.enabled = true,
  });
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Semantics(
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

/// Enhanced accessible radio button
class AccessibleRadio<T> extends StatelessWidget {
  const AccessibleRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    super.key,
    this.hint,
    this.enabled = true,
  });
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Semantics(
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

/// Enhanced accessible slider
class AccessibleSlider extends StatelessWidget {
  const AccessibleSlider({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.label,
    super.key,
    this.divisions,
    this.hint,
    this.enabled = true,
  });
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String label;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Semantics(
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

/// Enhanced accessible progress indicator
class AccessibleProgressIndicator extends StatelessWidget {
  const AccessibleProgressIndicator({
    required this.label,
    super.key,
    this.value,
    this.hint,
    this.backgroundColor,
    this.valueColor,
  });
  final double? value;
  final String label;
  final String? hint;
  final Color? backgroundColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        hint: hint,
        value: value?.toString() ?? 'Indeterminate',
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}

/// Enhanced accessible circular progress indicator
class AccessibleCircularProgressIndicator extends StatelessWidget {
  const AccessibleCircularProgressIndicator({
    required this.label,
    super.key,
    this.value,
    this.hint,
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth = 4.0,
  });
  final double? value;
  final String label;
  final String? hint;
  final Color? backgroundColor;
  final Color? valueColor;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        hint: hint,
        value: value?.toString() ?? 'Indeterminate',
        child: CircularProgressIndicator(
          value: value,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? Theme.of(context).colorScheme.primary,
          ),
          strokeWidth: strokeWidth,
        ),
      );
}

/// Enhanced accessible icon
class AccessibleIcon extends StatelessWidget {
  const AccessibleIcon({
    required this.icon,
    required this.label,
    super.key,
    this.size,
    this.color,
    this.hint,
  });
  final IconData icon;
  final double? size;
  final Color? color;
  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        hint: hint,
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      );
}

/// Enhanced accessible tooltip
class AccessibleTooltip extends StatelessWidget {
  const AccessibleTooltip({
    required this.message,
    required this.child,
    super.key,
    this.semanticLabel,
  });
  final String message;
  final Widget child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel ?? message,
        child: Tooltip(
          message: message,
          child: child,
        ),
      );
}

/// Enhanced accessible snackbar
class AccessibleSnackBar extends StatelessWidget {
  const AccessibleSnackBar({
    required this.content,
    super.key,
    this.actionLabel,
    this.onAction,
    this.duration,
    this.semanticLabel,
  });
  final String content;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration? duration;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
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
                label: actionLabel,
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
  const AccessibleAlertDialog({
    required this.title,
    required this.content,
    super.key,
    this.actions,
    this.semanticLabel,
  });
  final String title;
  final String content;
  final List<Widget>? actions;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel ?? title,
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        ),
      );

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    List<Widget>? actions,
    String? semanticLabel,
  }) =>
      showDialog<T>(
        context: context,
        builder: (context) => AccessibleAlertDialog(
          title: title,
          content: content,
          actions: actions,
          semanticLabel: semanticLabel,
        ),
      );
}

/// Enhanced accessible confirmation dialog
class AccessibleConfirmationDialog extends StatelessWidget {
  const AccessibleConfirmationDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.cancelLabel,
    super.key,
    this.onConfirm,
    this.onCancel,
    this.semanticLabel,
  });
  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
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

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmLabel,
    required String cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? semanticLabel,
  }) =>
      showDialog<bool>(
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
