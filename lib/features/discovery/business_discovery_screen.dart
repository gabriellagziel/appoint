import 'package:appoint/features/discovery/widgets/business_profile_card.dart';
import 'package:appoint/features/discovery/business_map_screen.dart';
import 'package:appoint/features/discovery/business_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final selectedLocationProvider = StateProvider<String?>((ref) => null);

final businessSearchProvider = FutureProvider.family<List<BusinessProfile>, Map<String, dynamic>>((ref, filters) async {
  // This would integrate with a real business search service
  // For now, we'll return mock data
  await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
  
  return [
    BusinessProfile(
      id: '1',
      name: 'Hair Studio Pro',
      category: 'Hair Salon',
      address: '123 Main St, Downtown',
      phone: '+1-555-0123',
      email: 'info@hairstudiopro.com',
      website: 'https://hairstudiopro.com',
      description: 'Professional hair styling and treatments',
      rating: 4.8,
      reviewCount: 127,
      logo: '',
      latitude: 37.7749,
      longitude: -122.4194,
      isOpen: true,
    ),
    BusinessProfile(
      id: '2',
      name: 'Wellness Therapy Center',
      category: 'Therapy',
      address: '456 Oak Ave, Midtown',
      phone: '+1-555-0456',
      email: 'hello@wellnesscenter.com',
      website: 'https://wellnesscenter.com',
      description: 'Comprehensive therapy and wellness services',
      rating: 4.9,
      reviewCount: 89,
      logo: '',
      latitude: 37.7849,
      longitude: -122.4094,
      isOpen: true,
    ),
    BusinessProfile(
      id: '3',
      name: 'Fitness Studio Plus',
      category: 'Fitness',
      address: '789 Pine St, Uptown',
      phone: '+1-555-0789',
      email: 'contact@fitnessstudio.com',
      website: 'https://fitnessstudio.com',
      description: 'Personal training and group fitness classes',
      rating: 4.7,
      reviewCount: 203,
      logo: '',
      latitude: 37.7649,
      longitude: -122.4294,
      isOpen: false,
    ),
  ];
});

class BusinessDiscoveryScreen extends ConsumerStatefulWidget {
  const BusinessDiscoveryScreen({super.key});

  @override
  ConsumerState<BusinessDiscoveryScreen> createState() => _BusinessDiscoveryScreenState();
}

class _BusinessDiscoveryScreenState extends ConsumerState<BusinessDiscoveryScreen> {
  final _searchController = TextEditingController();
  final _categories = [
    'All',
    'Hair Salon',
    'Therapy',
    'Fitness',
    'Dental',
    'Spa',
    'Massage',
    'Consulting',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);

    final filters = {
      'query': searchQuery,
      'category': selectedCategory,
      'location': selectedLocation,
    };

    final businessesAsync = ref.watch(businessSearchProvider(filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Businesses'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BusinessMapScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search businesses...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 16),

                // Categories
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = selectedCategory == category || 
                          (selectedCategory == null && category == 'All');

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            ref.read(selectedCategoryProvider.notifier).state = 
                                selected ? (category == 'All' ? null : category) : null;
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Business List
          Expanded(
            child: businessesAsync.when(
              data: (businesses) {
                if (businesses.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No businesses found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: businesses.length,
                  itemBuilder: (context, index) {
                    final business = businesses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BusinessProfileCard(
                        business: business,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessProfileScreen(
                                businessId: business.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading businesses',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(businessSearchProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Mock Business Profile Model
class BusinessProfile {
  final String id;
  final String name;
  final String category;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String description;
  final double rating;
  final int reviewCount;
  final String logo;
  final double latitude;
  final double longitude;
  final bool isOpen;

  BusinessProfile({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.logo,
    required this.latitude,
    required this.longitude,
    required this.isOpen,
  });
} 