import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/providers/search_provider.dart';
import 'package:appoint/widgets/app_scaffold.dart';
import 'package:appoint/widgets/empty_state.dart';
import 'package:appoint/widgets/loading_state.dart';
import 'package:appoint/widgets/error_state.dart';
import 'package:appoint/theme/app_spacing.dart';

/// Search screen with query field and results list.
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);

    return AppScaffold(
      title: 'Search',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, semanticLabel: 'search icon'),
              ),
              onChanged: (final value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: resultsAsync.when(
              data: (final results) {
                if (results.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search,
                    title: 'No Results',
                    description: 'Try a different query',
                  );
                }
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (final context, final index) => ListTile(
                    title: Text(results[index]),
                  ),
                );
              },
              loading: () => const LoadingState(),
              error: (final _, final __) => const ErrorState(
                title: 'Error',
                description: 'Something went wrong',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
