import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_meeting_flow_controller.dart';

class SelectLocationStep extends ConsumerWidget {
  final VoidCallback onNext;

  const SelectLocationStep({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingState = ref.watch(REDACTED_TOKEN);
    final selectedLocation = meetingState.location;
    final controller = ref.read(REDACTED_TOKEN.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where will this meeting take place?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Search for a location or enter an address',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for a location...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () => _getCurrentLocation(context, ref),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // TODO: Implement Google Maps search
              _searchLocation(value, ref);
            },
          ),
          const SizedBox(height: 16),

          // Location Options
          if (selectedLocation != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedLocation,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editLocation(context, ref),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '📍 Selected location',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Map Preview (Placeholder)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Map Preview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'OpenStreetMap integration\nwill be displayed here',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Location Options
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickLocationChip(
                context,
                'Home',
                Icons.home,
                () => _selectQuickLocation('Home', ref),
              ),
              _buildQuickLocationChip(
                context,
                'Work',
                Icons.work,
                () => _selectQuickLocation('Work', ref),
              ),
              _buildQuickLocationChip(
                context,
                'Virtual',
                Icons.video_call,
                () => _selectQuickLocation('Virtual Meeting', ref),
              ),
              _buildQuickLocationChip(
                context,
                'Custom',
                Icons.edit_location,
                () => _editLocation(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Back button - handled by parent
                  },
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      controller.canContinueFromCurrentStep() ? onNext : null,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLocationChip(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onTap,
    );
  }

  void _searchLocation(String query, WidgetRef ref) {
    // TODO: Implement Google Maps search
    print('Searching for: $query');
  }

  void _getCurrentLocation(BuildContext context, WidgetRef ref) {
    // TODO: Implement current location detection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Getting current location...'),
      ),
    );
  }

  void _selectQuickLocation(String location, WidgetRef ref) {
    ref
        .read(REDACTED_TOKEN.notifier)
        .setLocation(location);
  }

  void _editLocation(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final meetingState = ref.read(REDACTED_TOKEN);
    controller.text = meetingState.location ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final location = controller.text.trim();
              if (location.isNotEmpty) {
                ref
                    .read(REDACTED_TOKEN.notifier)
                    .setLocation(location);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
