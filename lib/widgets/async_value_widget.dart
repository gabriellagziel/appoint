import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'empty_state.dart';
import 'error_state.dart';
import 'loading_state.dart';

/// A convenience widget that renders an [AsyncValue] from Riverpod and provides
/// default UI for loading, error and empty states. This helps to guarantee
/// consistent UX across the app, so we don’t need to repeat `.when` everywhere.
///
/// Example usage:
/// ```dart
/// AsyncValueWidget<List<Item>>(
///   value: itemsAsync,
///   data: (items) => ListView.builder(...),
///   empty: () => const EmptyState(
///     title: 'No items',
///     description: 'Nothing to show yet',
///   ),
/// );
/// ```
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.empty,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final Widget? Function(Object error, StackTrace? stack)? error;
  final Widget? Function()? empty;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (dataValue) {
        // If an empty builder is supplied, attempt to detect emptiness.
        if (empty != null) {
          final isEmpty = _isEmpty(dataValue);
          if (isEmpty) return empty!.call() ?? const SizedBox.shrink();
        }
        return data(dataValue);
      },
      loading: () => loading ?? const LoadingState(),
      error: (err, stack) => error?.call(err, stack) ?? ErrorState(
        title: 'Something went wrong',
        description: err.toString(),
        onRetry: () {
          // A naive retry by refreshing the provider.
          // This only works if the provider is auto-disposed or supports refresh.
          // Widgets using this should wrap the provider with Consumer and call
          // ref.invalidate in their own scope. Therefore we leave retry optional.
        },
      ),
    );
  }

  bool _isEmpty(Object? obj) {
    if (obj == null) return true;
    if (obj is Iterable || obj is Map) {
      // ignore: avoid_dynamic_calls
      return (obj as dynamic).isEmpty as bool;
    }
    return false;
  }
}