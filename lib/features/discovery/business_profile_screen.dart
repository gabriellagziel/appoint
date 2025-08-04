import 'package:appoint/features/booking/screens/booking_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessProfileProvider = FutureProvider.family<BusinessProfile?, String>((ref, businessId) async {
  // This would fetch from a real business service
  await Future.delayed(const Duration(milliseconds: 300));
  
  // Mock business data
  switch (businessId) {
    case '1':
      return BusinessProfile(
        id: '1',
        name: 'Hair Studio Pro',
        category: 'Hair Salon',
        address: '123 Main St, Downtown',
        phone: '+1-555-0123',
        email: 'info@hairstudiopro.com',
        website: 'https://hairstudiopro.com',
        description: 'Professional hair styling and treatments with over 10 years of experience. We specialize in modern cuts, color treatments, and styling for all hair types.',
        rating: 4.8,
        reviewCount: 127,
        logo: '',
        latitude: 37.7749,
        longitude: -122.4194,
        isOpen: true,
      );
    case '2':
      return BusinessProfile(
        id: '2',
        name: 'Wellness Therapy Center',
        category: 'Therapy',
        address: '456 Oak Ave, Midtown',
        phone: '+1-555-0456',
        email: 'hello@wellnesscenter.com',
        website: 'https://wellnesscenter.com',
        description: 'Comprehensive therapy and wellness services including individual therapy, group sessions, and wellness coaching.',
        rating: 4.9,
        reviewCount: 89,
        logo: '',
        latitude: 37.7849,
        longitude: -122.4094,
        isOpen: true,
      );
    case '3':
      return BusinessProfile(
        id: '3',
        name: 'Fitness Studio Plus',
        category: 'Fitness',
        address: '789 Pine St, Uptown',
        phone: '+1-555-0789',
        email: 'contact@fitnessstudio.com',
        website: 'https://fitnessstudio.com',
        description: 'Personal training and group fitness classes for all fitness levels. Specializing in strength training, cardio, and flexibility.',
        rating: 4.7,
        reviewCount: 203,
        logo: '',
        latitude: 37.7649,
        longitude: -122.4294,
        isOpen: false,
      );
    default:
      return null;
  }
});

class BusinessProfileScreen extends ConsumerWidget {
  final String businessId;

  const BusinessProfileScreen({
    super.key,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(businessProfileProvider(businessId));

    return Scaffold(
      body: businessAsync.when(
        data: (business) {
          if (business == null) {
            return const Scaffold(
              body: Center(
                child: Text('Business not found'),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Business Image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(business.name),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.business,
                        size: 80,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Share business
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Add to favorites
                    },
                  ),
                ],
              ),

              // Business Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business Info
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  business.name,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  business.category,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: business.isOpen ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              business.isOpen ? 'Open' : 'Closed',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            business.rating.toString(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${business.reviewCount} reviews)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Contact Info
                      _buildContactSection(context, business),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        business.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),

                      // Services Section
                      _buildServicesSection(context),
                      const SizedBox(height: 24),

                      // Staff Section
                      _buildStaffSection(context),
                      const SizedBox(height: 24),

                      // Reviews Section
                      _buildReviewsSection(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
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
                  'Error loading business',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: businessAsync.when(
        data: (business) {
          if (business == null) return null;
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Call business
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: business.isOpen
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BookingRequestScreen(),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(business.isOpen ? 'Book Now' : 'Closed'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => null,
        error: (error, stack) => null,
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, BusinessProfile business) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContactRow(
              context,
              Icons.location_on,
              'Address',
              business.address,
            ),
            const SizedBox(height: 12),
            _buildContactRow(
              context,
              Icons.phone,
              'Phone',
              business.phone,
            ),
            const SizedBox(height: 12),
            _buildContactRow(
              context,
              Icons.email,
              'Email',
              business.email,
            ),
            const SizedBox(height: 12),
            _buildContactRow(
              context,
              Icons.language,
              'Website',
              business.website,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final services = [
                {'name': 'Haircut & Styling', 'duration': '45 min', 'price': '\$45'},
                {'name': 'Hair Coloring', 'duration': '2 hours', 'price': '\$120'},
                {'name': 'Hair Treatment', 'duration': '1 hour', 'price': '\$80'},
              ];
              final service = services[index];
              
              return ListTile(
                title: Text(service['name']!),
                subtitle: Text('${service['duration']} • ${service['price']}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to service details
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStaffSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Staff',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final staff = [
                {'name': 'Sarah Johnson', 'role': 'Senior Stylist', 'rating': '4.9'},
                {'name': 'Mike Chen', 'role': 'Color Specialist', 'rating': '4.8'},
              ];
              final member = staff[index];
              
              return ListTile(
                leading: CircleAvatar(
                  child: Text(member['name']!.split(' ').map((n) => n[0]).join()),
                ),
                title: Text(member['name']!),
                subtitle: Text(member['role']!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(member['rating']!),
                  ],
                ),
                onTap: () {
                  // Navigate to staff profile
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // View all reviews
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      child: Text('JD'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < 4 ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '2 days ago',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Great service! The staff was professional and the results exceeded my expectations. Highly recommend!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 