import 'package:appoint/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Enhanced form field with inline error hints
class InlineErrorFormField extends StatefulWidget {
  InlineErrorFormField({
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
    this.showErrorIcon = true,
    this.showSuccessIcon = true,
    this.errorAnimationDuration = const Duration(milliseconds: 300),
    this.autoValidate = false,
  });
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final bool showErrorIcon;
  final bool showSuccessIcon;
  final Duration errorAnimationDuration;
  final bool autoValidate;

  @override
  State<InlineErrorFormField> createState() => _InlineErrorFormFieldState();
}

class _InlineErrorFormFieldState extends State<InlineErrorFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  String? _currentError;
  bool _hasBeenTouched = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.errorAnimationDuration,
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _validateField(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null && error != _currentError) {
        _currentError = error;
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      } else if (error == null) {
        _currentError = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = _currentError != null || widget.errorText != null;
    final errorMessage = _currentError ?? widget.errorText;
    final isValid = !hasError && _hasBeenTouched && widget.showSuccessIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              validator: widget.validator,
              onChanged: (value) {
                if (widget.autoValidate || _hasBeenTouched) {
                  _validateField(value);
                }
                widget.onChanged?.call(value);
              },
              onFieldSubmitted: widget.onSubmitted,
              onTap: () {
                if (!_hasBeenTouched) {
                  setState(() => _hasBeenTouched = true);
                }
              },
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon,
                suffixIcon: _buildSuffixIcon(isValid, hasError),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
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
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.outline,
                  ),
                ),
                filled: true,
                fillColor: hasError
                    ? theme.colorScheme.error.withValues(alpha: 0.05)
                    : theme.colorScheme.surface,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildErrorHint(errorMessage!, theme),
        ],
        if (isValid) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildSuccessHint(theme),
        ],
      ],
    );
  }

  Widget _buildSuffixIcon(bool isValid, bool hasError) {
    if (hasError && widget.showErrorIcon) {
      return const Icon(Icons.error, color: Colors.red);
    } else if (isValid && widget.showSuccessIcon) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else {
      return widget.suffixIcon ?? const SizedBox.shrink();
    }
  }

  Widget _buildErrorHint(String errorMessage, ThemeData theme) =>
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 16,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                errorMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildSuccessHint(ThemeData theme) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Valid',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

/// Enhanced password field with inline validation
class InlineErrorPasswordField extends StatefulWidget {
  InlineErrorPasswordField({
    required this.label,
    super.key,
    this.hint,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.showPasswordToggle = true,
    this.autoValidate = false,
  });
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  final bool enabled;
  final bool showPasswordToggle;
  final bool autoValidate;

  @override
  State<InlineErrorPasswordField> createState() =>
      _InlineErrorPasswordFieldState();
}

class _InlineErrorPasswordFieldState extends State<InlineErrorPasswordField> {
  bool _obscureText = true;
  String? _currentError;
  bool _hasBeenTouched = false;

  void _validatePassword(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() => _currentError = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = _currentError != null || widget.errorText != null;
    final errorMessage = _currentError ?? widget.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          enabled: widget.enabled,
          validator: widget.validator,
          onChanged: (value) {
            if (widget.autoValidate || _hasBeenTouched) {
              _validatePassword(value);
            }
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onSubmitted,
          onTap: () {
            if (!_hasBeenTouched) {
              setState(() => _hasBeenTouched = true);
            }
          },
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: widget.showPasswordToggle
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
              ),
            ),
            filled: true,
            fillColor: hasError
                ? theme.colorScheme.error.withValues(alpha: 0.05)
                : theme.colorScheme.surface,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildErrorHint(errorMessage!, theme),
        ],
      ],
    );
  }

  Widget _buildErrorHint(String errorMessage, ThemeData theme) => Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
}

/// Enhanced email field with inline validation
class InlineErrorEmailField extends StatefulWidget {
  InlineErrorEmailField({
    required this.label,
    super.key,
    this.hint,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autoValidate = false,
  });
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  final bool enabled;
  final bool autoValidate;

  @override
  State<InlineErrorEmailField> createState() => _InlineErrorEmailFieldState();
}

class _InlineErrorEmailFieldState extends State<InlineErrorEmailField> {
  String? _currentError;
  bool _hasBeenTouched = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = _currentError != null || widget.errorText != null;
    final errorMessage = _currentError ?? widget.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          enabled: widget.enabled,
          validator: _validateEmail,
          onChanged: (value) {
            if (widget.autoValidate || _hasBeenTouched) {
              setState(() => _currentError = _validateEmail(value));
            }
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onSubmitted,
          onTap: () {
            if (!_hasBeenTouched) {
              setState(() => _hasBeenTouched = true);
            }
          },
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
              ),
            ),
            filled: true,
            fillColor: hasError
                ? theme.colorScheme.error.withValues(alpha: 0.05)
                : theme.colorScheme.surface,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildErrorHint(errorMessage!, theme),
        ],
      ],
    );
  }

  Widget _buildErrorHint(String errorMessage, ThemeData theme) => Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
}

/// Enhanced phone field with inline validation
class InlineErrorPhoneField extends StatefulWidget {
  InlineErrorPhoneField({
    required this.label,
    super.key,
    this.hint,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autoValidate = false,
  });
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  final bool enabled;
  final bool autoValidate;

  @override
  State<InlineErrorPhoneField> createState() => _InlineErrorPhoneFieldState();
}

class _InlineErrorPhoneFieldState extends State<InlineErrorPhoneField> {
  String? _currentError;
  bool _hasBeenTouched = false;

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = _currentError != null || widget.errorText != null;
    final errorMessage = _currentError ?? widget.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          enabled: widget.enabled,
          validator: _validatePhone,
          onChanged: (value) {
            if (widget.autoValidate || _hasBeenTouched) {
              setState(() => _currentError = _validatePhone(value));
            }
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onSubmitted,
          onTap: () {
            if (!_hasBeenTouched) {
              setState(() => _hasBeenTouched = true);
            }
          },
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
              ),
            ),
            filled: true,
            fillColor: hasError
                ? theme.colorScheme.error.withValues(alpha: 0.05)
                : theme.colorScheme.surface,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildErrorHint(errorMessage!, theme),
        ],
      ],
    );
  }

  Widget _buildErrorHint(String errorMessage, ThemeData theme) => Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
}

/// Form validation helper
class FormValidationHelper {
  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be no more than $maxLength characters';
    }
    return null;
  }

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp('[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp('[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp('[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    try {
      Uri.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  /// Validate numeric value
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return '$fieldName must be a number';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) {
      return numericError;
    }

    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }

    return null;
  }
}
