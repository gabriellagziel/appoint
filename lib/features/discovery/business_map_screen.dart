import 'package:appoint/features/discovery/business_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessMapScreen extends ConsumerStatefulWidget {
  const BusinessMapScreen({super.key});

  @override
  ConsumerState<BusinessMapScreen> createState() => _BusinessMapScreenState();
}

class _BusinessMapScreenState extends ConsumerState<BusinessMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Map'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Map Placeholder (would integrate with Google Maps)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Google Maps integration would show\nbusinesses with markers here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Business Markers (Mock)
          Positioned(
            top: 100,
            left: 50,
            child: BusinessMapMarker(
              businessName: 'Hair Studio Pro',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BusinessProfileScreen(
                      businessId: '1',
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 200,
            right: 80,
            child: BusinessMapMarker(
              businessName: 'Wellness Therapy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BusinessProfileScreen(
                      businessId: '2',
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 150,
            left: 100,
            child: BusinessMapMarker(
              businessName: 'Fitness Studio',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BusinessProfileScreen(
                      businessId: '3',
                    ),
                  ),
                );
              },
            ),
          ),

          // Map Controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: () {
                    // Zoom in
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: () {
                    // Zoom out
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: () {
                    // Center on user location
                  },
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 80,
            child: Card(
              elevation: 4,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search nearby businesses...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BusinessMapMarker extends StatelessWidget {
  final String businessName;
  final VoidCallback onTap;

  const BusinessMapMarker({
    super.key,
    required this.businessName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.business,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              businessName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 