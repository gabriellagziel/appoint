import 'package:appoint/features/search/models/search_result.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SearchFiltersSheet extends StatefulWidget {
  const SearchFiltersSheet({
    required this.initialFilters,
    required this.onFiltersChanged,
    super.key,
  });

  final SearchFilters initialFilters;
  final ValueChanged<SearchFilters> onFiltersChanged;

  @override
  State<SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<SearchFiltersSheet> {
  late SearchFilters _filters;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _locationController = TextEditingController();
  final _categoryController = TextEditingController();
  final _minRatingController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _distanceController = TextEditingController();

  // Values
  String? _selectedCategory;
  String? _selectedSortBy;
  bool _availabilityOnly = false;

  final List<String> _categories = [
    'All',
    'Health & Wellness',
    'Beauty & Spa',
    'Fitness & Sports',
    'Education & Training',
    'Professional Services',
    'Entertainment',
    'Food & Dining',
    'Shopping',
    'Other',
  ];

  final List<String> _sortOptions = [
    'Relevance',
    'Rating',
    'Price (Low to High)',
    'Price (High to Low)',
    'Distance',
  ];

  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters;
    _initializeControllers();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _categoryController.dispose();
    _minRatingController.dispose();
    _maxPriceController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _locationController.text = _filters.location ?? '';
    _categoryController.text = _filters.category ?? '';
    _minRatingController.text = _filters.minRating?.toString() ?? '';
    _maxPriceController.text = _filters.maxPrice?.toString() ?? '';
    _distanceController.text = _filters.distance?.toString() ?? '';

    final selectedCategory = _filters.category;
    final selectedSortBy = _filters.sortBy ?? 'Relevance';
    final availabilityOnly = _filters.availability ?? false;
  }

  void _applyFilters() {
    if (_formKey.currentState!.validate()) {
      final newFilters = SearchFilters(
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        minRating: _minRatingController.text.isEmpty
            ? null
            : double.tryParse(_minRatingController.text),
        maxPrice: _maxPriceController.text.isEmpty
            ? null
            : double.tryParse(_maxPriceController.text),
        availability: _availabilityOnly,
        distance: _distanceController.text.isEmpty
            ? null
            : double.tryParse(_distanceController.text),
        sortBy: _selectedSortBy == 'Relevance' ? null : _selectedSortBy,
      );

      widget.onFiltersChanged(newFilters);
      Navigator.pop(context);
    }
  }

  void _resetFilters() {
    setState(() {
      _filters = const SearchFilters();
      _locationController.clear();
      _categoryController.clear();
      _minRatingController.clear();
      _maxPriceController.clear();
      _distanceController.clear();
      const selectedCategory = null;
      const selectedSortBy = 'Relevance';
      const availabilityOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(l10n),

          // Content
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildLocationFilter(l10n),
                  const SizedBox(height: 16),
                  _buildCategoryFilter(l10n),
                  const SizedBox(height: 16),
                  _buildRatingFilter(l10n),
                  const SizedBox(height: 16),
                  _buildPriceFilter(l10n),
                  const SizedBox(height: 16),
                  _buildDistanceFilter(l10n),
                  const SizedBox(height: 16),
                  _buildAvailabilityFilter(l10n),
                  const SizedBox(height: 16),
                  _buildSortFilter(l10n),
                ],
              ),
            ),
          ),

          // Actions
          _buildActions(l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.tune),
            const SizedBox(width: 8),
            Text(
              'Search Filters',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton(
              onPressed: _resetFilters,
              child: const Text('Reset'),
            ),
          ],
        ),
      );

  Widget _buildLocationFilter(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'Enter city or address',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );

  Widget _buildCategoryFilter(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select category'),
            items: _categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category == 'All' ? null : category,
                    child: Text(category),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ],
      );

  Widget _buildRatingFilter(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minimum Rating',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _minRatingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g., 4.0',
              prefixIcon: Icon(Icons.star),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final rating = double.tryParse(value);
                if (rating == null || rating < 0 || rating > 5) {
                  return 'Please enter a valid rating (0-5)';
                }
              }
              return null;
            },
          ),
        ],
      );

  Widget _buildPriceFilter(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Maximum Price',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g., 100',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final price = double.tryParse(value);
                if (price == null || price < 0) {
                  return 'Please enter a valid price';
                }
              }
              return null;
            },
          ),
        ],
      );

  Widget _buildDistanceFilter(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Maximum Distance (km)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _distanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g., 10',
              prefixIcon: Icon(Icons.place),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final distance = double.tryParse(value);
                if (distance == null || distance < 0) {
                  return 'Please enter a valid distance';
                }
              }
              return null;
            },
          ),
        ],
      );

  Widget _buildAvailabilityFilter(AppLocalizations l10n) => SwitchListTile(
        title: const Text('Available Now Only'),
        subtitle: const Text('Show only currently available services'),
        value: _availabilityOnly,
        onChanged: (value) {
          setState(() {
            _availabilityOnly = value;
          });
        },
      );

  Widget _buildSortFilter(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedSortBy,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: _sortOptions
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedSortBy = value;
              });
            },
          ),
        ],
      );

  Widget _buildActions(AppLocalizations l10n) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      );
}
