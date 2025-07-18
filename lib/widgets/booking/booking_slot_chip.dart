import 'package:flutter/material.dart';

/// A chip widget for displaying booking time slots with availability status
class BookingSlotChip extends StatelessWidget {
  const BookingSlotChip({
    required this.time, required this.available, required this.onSelected, super.key,
    this.selected = false,
    this.disabled = false,
  });

  /// The time slot to display
  final TimeOfDay time;

  /// Whether this slot is available for booking
  final bool available;

  /// Callback when the chip is tapped
  final ValueChanged<TimeOfDay> onSelected;

  /// Whether this slot is currently selected
  final bool selected;

  /// Whether this slot is disabled (unavailable)
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = available && !disabled;

    return Semantics(
      label: _getSemanticsLabel(),
      button: true,
      enabled: isAvailable,
      selected: selected,
      child: FilterChip(
        label: Text(
          _formatTime(time),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: _getTextColor(theme),
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: selected,
        onSelected: isAvailable ? (_) => onSelected(time) : null,
        backgroundColor: _getBackgroundColor(theme),
        selectedColor: theme.colorScheme.primaryContainer,
        disabledColor: theme.colorScheme.surfaceVariant,
        side: BorderSide(
          color: _getBorderColor(theme),
        ),
        elevation: selected ? 2.0 : 0.0,
        pressElevation: isAvailable ? 1.0 : 0.0,
        avatar: _buildAvailabilityIcon(theme),
        showCheckmark: false,
      ),
    );
  }

  String _getSemanticsLabel() {
    final timeStr = _formatTime(time);
    final status = disabled
        ? 'unavailable'
        : available
            ? 'available'
            : 'booked';
    return '$timeStr $status';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color _getTextColor(ThemeData theme) {
    if (disabled) {
      return theme.colorScheme.onSurfaceVariant.withOpacity(0.6);
    }
    if (selected) {
      return theme.colorScheme.onPrimaryContainer;
    }
    return available
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withOpacity(0.6);
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (disabled) {
      return theme.colorScheme.surfaceVariant;
    }
    if (selected) {
      return theme.colorScheme.primaryContainer;
    }
    return available
        ? theme.colorScheme.surface
        : theme.colorScheme.surfaceVariant;
  }

  Color _getBorderColor(ThemeData theme) {
    if (selected) {
      return theme.colorScheme.primary;
    }
    if (disabled) {
      return theme.colorScheme.outline.withOpacity(0.3);
    }
    return available
        ? theme.colorScheme.outline
        : theme.colorScheme.outline.withOpacity(0.5);
  }

  Widget? _buildAvailabilityIcon(ThemeData theme) {
    if (disabled) {
      return Icon(
        Icons.block,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
      );
    }
    if (!available) {
      return Icon(
        Icons.close,
        size: 16,
        color: theme.colorScheme.error,
      );
    }
    if (selected) {
      return Icon(
        Icons.check,
        size: 16,
        color: theme.colorScheme.onPrimaryContainer,
      );
    }
    return Icon(
      Icons.schedule,
      size: 16,
      color: theme.colorScheme.primary,
    );
  }
}
