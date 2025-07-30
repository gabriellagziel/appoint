import 'package:appoint/features/studio_business/providers/business_availability_provider.dart';
import 'package:appoint/features/studio_business/services/business_availability_service.dart';
import 'package:appoint/shared/widgets/responsive_scaffold.dart';
import 'package:appoint/utils/business_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BusinessAvailabilityScreen extends ConsumerStatefulWidget {
  const BusinessAvailabilityScreen({super.key});

  @override
  ConsumerState<BusinessAvailabilityScreen> createState() =>
      _BusinessAvailabilityScreenState();
}

class _BusinessAvailabilityScreenState
    extends ConsumerState<BusinessAvailabilityScreen> {
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(businessAvailabilityServiceProvider);
      await service.loadConfiguration();
      ref.read(businessAvailabilityProvider.notifier).loadConfiguration();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading configuration: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfiguration() async {
    setState(() => _isSaving = true);
    try {
      final availability = ref.read(businessAvailabilityProvider);
      final service = ref.read(businessAvailabilityServiceProvider);
      final config = service.toJson(availability);
      await service.saveConfiguration(config);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuration saved successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving configuration: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Unknown';
    }
  }

  Future<void> _pickTime(
    final BuildContext context,
    final TimeOfDay initial,
    void Function(TimeOfDay) onPicked,
  ) async {
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final availability = ref.watch(businessAvailabilityProvider);
    final notifier = ref.read(businessAvailabilityProvider.notifier);

    if (_isLoading) {
      return Theme(
        data: BusinessTheme.businessTheme,
        child: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Theme(
      data: BusinessTheme.businessTheme,
      child: ResponsiveScaffold(
        appBar: AppBar(
          title: const Text('Business Availability'),
          centerTitle: true,
          backgroundColor: BusinessTheme.businessTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveConfiguration,
                tooltip: 'Save Configuration',
              ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 7,
          separatorBuilder: (_, final __) => const SizedBox(height: 8),
          itemBuilder: (context, final weekday) {
            final avail = availability.firstWhere((a) => a.weekday == weekday);
            final timeRange = TimeRange(start: avail.start, end: avail.end);
            final hasError = avail.isOpen && !timeRange.isValid;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          avail.isOpen ? Icons.check_circle : Icons.cancel,
                          color: avail.isOpen ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getDayName(weekday),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Switch(
                          value: avail.isOpen,
                          onChanged: (value) =>
                              notifier.toggleOpen(weekday, value),
                        ),
                      ],
                    ),
                    if (avail.isOpen) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Start Time',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _pickTime(
                                    context,
                                    avail.start,
                                    (time) => notifier.updateDay(
                                      weekday,
                                      start: time,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(avail.start.format(context)),
                                        const Icon(Icons.access_time, size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'End Time',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _pickTime(
                                    context,
                                    avail.end,
                                    (time) => notifier.updateDay(
                                      weekday,
                                      end: time,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(avail.end.format(context)),
                                        const Icon(Icons.access_time, size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (hasError) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'End time must be after start time',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ] else ...[
                      const SizedBox(height: 8),
                      Text(
                        'Closed',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: BusinessTheme.businessTheme.colorScheme.primary,
              ),
              child: const Text(
                'Studio Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                context.go('/studio/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Availability'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                context.go('/studio/dashboard');
              },
            ),
          ],
        ),
      );
}
