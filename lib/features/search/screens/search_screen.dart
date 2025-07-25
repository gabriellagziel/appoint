import 'package:appoint/features/search/models/search_result.dart';
import 'package:appoint/features/search/services/search_service.dart';
import 'package:appoint/features/search/widgets/search_filters_sheet.dart';
import 'package:appoint/features/search/widgets/search_result_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

final searchResultsProvider = FutureProvider.family<List<SearchResult>, SearchQuery>(
  (ref, query) async {
    final service = ref.read(searchServiceProvider);
    return service.search(query.query, query.filters);
  },
);

final searchSuggestionsProvider = FutureProvider.family<List<String>, String>(
  (ref, query) async {
    final service = ref.read(searchServiceProvider);
    return service.getSearchSuggestions(query);
  },
);

final searchHistoryProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.read(searchServiceProvider);
  return service.getSearchHistory();
});

class SearchQuery {
  const SearchQuery({
    required this.query,
    required this.filters,
  });

  final String query;
  final SearchFilters filters;
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  SearchFilters _filters = const SearchFilters();
  String _currentQuery = '';
  bool _isSearching = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _currentQuery = query;
      final _showSuggestions = query.isNotEmpty;
    });
  }

  void _onSearchSubmitted() {
    if (_currentQuery.isNotEmpty) {
      setState(() {
        _showSuggestions = false;
        var _isSearching = true;
      });
      
      // Save to search history
      ref.read(searchServiceProvider).saveSearchHistory(_currentQuery);
      
      // Trigger search
      ref.invalidate(searchResultsProvider);
    }
  }

  void _onSuggestionTapped(String suggestion) {
    _searchController.text = suggestion;
    _onSearchSubmitted();
  }

  void _onFiltersChanged(SearchFilters filters) {
    setState(() {
      _filters = filters;
    });
    ref.invalidate(searchResultsProvider);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
      var _showSuggestions = false;
      var _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(l10n),
        actions: [
          if (_currentQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFiltersSheet(context),
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: l10n.search,
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _currentQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              )
            : null,
      ),
      onSubmitted: (_) => _onSearchSubmitted(),
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_showSuggestions && _currentQuery.isEmpty) {
      return _buildSearchHistory(l10n);
    }

    if (_showSuggestions && _currentQuery.isNotEmpty) {
      return _buildSuggestions(l10n);
    }

    if (_isSearching && _currentQuery.isNotEmpty) {
      return _buildSearchResults(l10n);
    }

    return _buildEmptyState(l10n);
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.search,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for businesses, services, or people',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory(AppLocalizations l10n) {
    return Consumer(
      builder: (context, ref, child) {
        final historyAsync = ref.watch(searchHistoryProvider);
        
        return historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (history) {
            if (history.isEmpty) {
              return _buildEmptyState(l10n);
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ...history.map((query) => ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(query),
                  onTap: () => _onSuggestionTapped(query),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(searchServiceProvider).clearSearchHistory();
                      ref.invalidate(searchHistoryProvider);
                    },
                  ),
                )),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSuggestions(AppLocalizations l10n) {
    return Consumer(
      builder: (context, ref, child) {
        final suggestionsAsync = ref.watch(searchSuggestionsProvider(_currentQuery));
        
        return suggestionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (suggestions) {
            if (suggestions.isEmpty) {
              return Center(
                child: Text(
                  'No suggestions found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500]),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Suggestions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ...suggestions.map((suggestion) => ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(suggestion),
                  onTap: () => _onSuggestionTapped(suggestion),
                )),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResults(AppLocalizations l10n) {
    return Consumer(
      builder: (context, ref, child) {
        final searchQuery = SearchQuery(query: _currentQuery, filters: _filters);
        final resultsAsync = ref.watch(searchResultsProvider(searchQuery));
        
        return resultsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Search failed',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(searchResultsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (results) {
            if (results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No results found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your search terms or filters',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SearchResultCard(
                    result: result,
                    onTap: () => _onResultTapped(result),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchFiltersSheet(
        initialFilters: _filters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _onResultTapped(SearchResult result) {
    // Navigate based on result type
    switch (result.type) {
      case 'business':
        context.push('/business/${result.id}');
        break;
      case 'service':
        context.push('/service/${result.id}');
        break;
      case 'user':
        context.push('/profile/${result.id}');
        break;
      default:
        // Handle other types
        break;
    }
  }
} 