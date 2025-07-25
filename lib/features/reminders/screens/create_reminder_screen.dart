import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/reminder.dart';
import 'package:appoint/features/reminders/providers/reminder_providers.dart';
import 'package:appoint/features/reminders/widgets/upgrade_prompt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CreateReminderScreen extends ConsumerStatefulWidget {
  const CreateReminderScreen({
    super.key,
    this.initialType,
    this.meetingId,
    this.eventId,
  });

  final ReminderType? initialType;
  final String? meetingId;
  final String? eventId;

  @override
  ConsumerState<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final PageController _pageController = PageController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  int _currentStep = 0;
  ReminderType _selectedType = ReminderType.timeBased;
  ReminderPriority _selectedPriority = ReminderPriority.medium;
  DateTime? _selectedDateTime;
  ReminderLocation? _selectedLocation;
  bool _notificationsEnabled = true;
  List<ReminderNotificationMethod> _notificationMethods = [ReminderNotificationMethod.local];
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accessStatus = ref.watch(locationReminderAccessStatusProvider);
    final creationState = ref.watch(reminderCreationNotifierProvider);

    // Handle creation state changes
    ref.listen(reminderCreationNotifierProvider, (previous, next) {
      if (next.isSuccess) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reminderCreated),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next.isAccessDenied) {
        _showAccessDeniedDialog(context, next.accessDeniedMessage!);
      } else if (next.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createReminder),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _goToPreviousStep,
              child: Text(l10n.back),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 5,
            backgroundColor: Colors.grey[300],
          ),
          
          // Step content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTypeSelectionStep(),
                _buildTitleAndDescriptionStep(),
                _buildTimeOrLocationStep(),
                _buildOptionsStep(),
                _buildReviewStep(),
              ],
            ),
          ),
          
          // Bottom action bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goToPreviousStep,
                      child: Text(l10n.back),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _canProceed() ? _handleNextStep : null,
                    child: Text(
                      _currentStep == 4 
                          ? (creationState.isLoading ? l10n.creating : l10n.createReminder)
                          : l10n.next,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelectionStep() {
    final l10n = AppLocalizations.of(context)!;
    final accessStatus = ref.watch(locationReminderAccessStatusProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.whatKindOfReminder,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.chooseReminderType,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: accessStatus.when(
              data: (status) => ListView(
                children: [
                  _buildTypeOption(
                    type: ReminderType.timeBased,
                    title: l10n.timeBasedReminder,
                    description: l10n.timeBasedReminderDescription,
                    icon: Icons.schedule,
                    color: Colors.blue,
                    enabled: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTypeOption(
                    type: ReminderType.locationBased,
                    title: l10n.locationBasedReminder,
                    description: l10n.locationBasedReminderDescription,
                    icon: Icons.location_on,
                    color: Colors.green,
                    enabled: status.canCreateLocationReminders,
                    upgradePrompt: !status.canCreateLocationReminders,
                  ),
                  const SizedBox(height: 16),
                  _buildTypeOption(
                    type: ReminderType.meetingRelated,
                    title: l10n.meetingReminder,
                    description: l10n.meetingReminderDescription,
                    icon: Icons.event,
                    color: Colors.purple,
                    enabled: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTypeOption(
                    type: ReminderType.personal,
                    title: l10n.personalReminder,
                    description: l10n.personalReminderDescription,
                    icon: Icons.person,
                    color: Colors.orange,
                    enabled: true,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text(l10n.errorLoadingAccessInfo)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption({
    required ReminderType type,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool enabled,
    bool upgradePrompt = false,
  }) {
    final isSelected = _selectedType == type;
    
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: enabled
            ? () => setState(() => _selectedType = type)
            : upgradePrompt
                ? () => _showUpgradeDialog(context)
                : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(enabled ? 0.1 : 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: enabled ? color : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: enabled ? null : Colors.grey,
                            ),
                          ),
                        ),
                        if (upgradePrompt)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1576D4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.pro,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: enabled 
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: color,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescriptionStep() {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tellUsAboutReminder,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.giveReminderDetails,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Title field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.reminderTitle,
              hintText: l10n.reminderTitleHint,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.title),
            ),
            textInputAction: TextInputAction.next,
            maxLength: 100,
          ),
          
          const SizedBox(height: 16),
          
          // Description field
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: l10n.description,
              hintText: l10n.reminderDescriptionHint,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.description),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            maxLength: 500,
          ),
          
          const SizedBox(height: 24),
          
          // Priority selection
          Text(
            l10n.priority,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 8,
            children: ReminderPriority.values.map((priority) {
              final isSelected = _selectedPriority == priority;
              return FilterChip(
                label: Text(priority.displayName),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedPriority = priority);
                  }
                },
                avatar: Icon(
                  _getPriorityIcon(priority),
                  size: 16,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOrLocationStep() {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedType == ReminderType.locationBased
                ? l10n.whereToRemind
                : l10n.whenToRemind,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedType == ReminderType.locationBased
                ? l10n.selectLocationForReminder
                : l10n.selectTimeForReminder,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: _selectedType == ReminderType.locationBased
                ? _buildLocationPicker()
                : _buildDateTimePicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPicker() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Map placeholder (would integrate with Google Maps)
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedLocation != null
                ? _buildMapView()
                : _buildLocationSearchPlaceholder(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Location search button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _searchLocation,
            icon: const Icon(Icons.search),
            label: Text(_selectedLocation != null 
                ? l10n.changeLocation 
                : l10n.searchLocation),
          ),
        ),
        
        if (_selectedLocation != null) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedLocation!.name ?? l10n.selectedLocation,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedLocation!.address,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMapView() {
    // This would integrate with Google Maps
    // For now, showing a placeholder
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[100]!,
            Colors.green[50]!,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 64,
              color: Colors.green[600],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.mapView,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSearchPlaceholder() {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_searching,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noLocationSelected,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToSearchLocation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Quick time options
        Text(
          l10n.quickOptions,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _getQuickTimeOptions(l10n).map((option) => FilterChip(
            label: Text(option.$2),
            selected: false,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedDateTime = option.$1);
              }
            },
          )).toList(),
        ),
        
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),
        
        // Custom date/time picker
        Text(
          l10n.customDateTime,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDateTime != null
                    ? _formatDate(_selectedDateTime!)
                    : l10n.selectDate),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectTime,
                icon: const Icon(Icons.access_time),
                label: Text(_selectedDateTime != null
                    ? _formatTime(_selectedDateTime!)
                    : l10n.selectTime),
              ),
            ),
          ],
        ),
        
        if (_selectedDateTime != null) ...[
          const SizedBox(height: 24),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.reminderScheduledFor,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          _formatDateTime(_selectedDateTime!),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOptionsStep() {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.additionalOptions,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.customizeReminderBehavior,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Notifications toggle
          SwitchListTile(
            title: Text(l10n.enableNotifications),
            subtitle: Text(l10n.receiveNotificationWhenTriggered),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            secondary: const Icon(Icons.notifications),
          ),
          
          if (_notificationsEnabled) ...[
            const SizedBox(height: 16),
            
            // Notification methods
            Text(
              l10n.notificationMethods,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            CheckboxListTile(
              title: Text(l10n.pushNotification),
              subtitle: Text(l10n.pushNotificationDescription),
              value: _notificationMethods.contains(ReminderNotificationMethod.push),
              onChanged: (checked) => _toggleNotificationMethod(
                ReminderNotificationMethod.push, 
                checked ?? false,
              ),
              secondary: const Icon(Icons.phone_android),
            ),
            
            CheckboxListTile(
              title: Text(l10n.localNotification),
              subtitle: Text(l10n.localNotificationDescription),
              value: _notificationMethods.contains(ReminderNotificationMethod.local),
              onChanged: (checked) => _toggleNotificationMethod(
                ReminderNotificationMethod.local, 
                checked ?? false,
              ),
              secondary: const Icon(Icons.notifications_active),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Tags
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              labelText: l10n.tags,
              hintText: l10n.tagsHint,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.tag),
              helperText: l10n.separateTagsWithCommas,
            ),
            onChanged: _updateTags,
          ),
          
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _tags.map((tag) => Chip(
                label: Text(tag),
                onDeleted: () => _removeTag(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reviewReminder,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reviewReminderDetails,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type and priority
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getTypeColor(_selectedType).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getTypeIcon(_selectedType),
                            color: _getTypeColor(_selectedType),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedType.displayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(_selectedPriority).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _selectedPriority.displayName,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _getPriorityColor(_selectedPriority),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Title and description
                    Text(
                      _titleController.text,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    if (_descriptionController.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _descriptionController.text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    // Trigger details
                    if (_selectedType == ReminderType.locationBased && _selectedLocation != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.triggerLocation,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  _selectedLocation!.name ?? _selectedLocation!.address,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else if (_selectedDateTime != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.schedule, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.triggerTime,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  _formatDateTime(_selectedDateTime!),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Notifications
                    if (_notificationsEnabled) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.notifications, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.notifications,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  _notificationMethods.map((m) => _getNotificationMethodName(m, l10n)).join(', '),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Tags
                    if (_tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.tag, color: Colors.purple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.tags,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  children: _tags.map((tag) => Chip(
                                    label: Text(tag),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: // Type selection
        return true; // Always can proceed from type selection
      case 1: // Title and description
        return _titleController.text.trim().isNotEmpty;
      case 2: // Time or location
        if (_selectedType == ReminderType.locationBased) {
          return _selectedLocation != null;
        } else {
          return _selectedDateTime != null;
        }
      case 3: // Options
        return true; // Always can proceed from options
      case 4: // Review
        return true; // Always can proceed from review
      default:
        return false;
    }
  }

  void _handleNextStep() {
    if (_currentStep < 4) {
      _goToNextStep();
    } else {
      _createReminder();
    }
  }

  void _goToNextStep() {
    setState(() => _currentStep++);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousStep() {
    setState(() => _currentStep--);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _createReminder() {
    ref.read(reminderCreationNotifierProvider.notifier).createReminder(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedType,
      triggerTime: _selectedDateTime,
      location: _selectedLocation,
      meetingId: widget.meetingId,
      eventId: widget.eventId,
      priority: _selectedPriority,
      tags: _tags.isNotEmpty ? _tags : null,
      notificationsEnabled: _notificationsEnabled,
      notificationMethods: _notificationMethods.isNotEmpty ? _notificationMethods : null,
    );
  }

  void _searchLocation() async {
    // This would open a location search/picker dialog
    // For now, we'll simulate selecting a location
    setState(() {
      _selectedLocation = const ReminderLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        address: '123 Main Street, San Francisco, CA',
        name: 'Coffee Shop',
        radius: 100,
        triggerType: LocationTriggerType.onArrival,
      );
    });
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDateTime?.hour ?? 9,
          _selectedDateTime?.minute ?? 0,
        );
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _selectedDateTime ?? DateTime.now().add(const Duration(hours: 1)),
      ),
    );
    
    if (time != null) {
      setState(() {
        final now = DateTime.now();
        _selectedDateTime = DateTime(
          _selectedDateTime?.year ?? now.year,
          _selectedDateTime?.month ?? now.month,
          _selectedDateTime?.day ?? now.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _toggleNotificationMethod(ReminderNotificationMethod method, bool enabled) {
    setState(() {
      if (enabled) {
        if (!_notificationMethods.contains(method)) {
          _notificationMethods.add(method);
        }
      } else {
        _notificationMethods.remove(method);
      }
    });
  }

  void _updateTags(String value) {
    final tags = value
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    setState(() => _tags = tags);
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      _tagsController.text = _tags.join(', ');
    });
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF1576D4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(AppLocalizations.of(context)!.unlockLocationReminders),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.locationRemindersDescription),
            const SizedBox(height: 16),
            const Text(
              'Powered by App-Oint', // Always English, never translated
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.notNow),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1576D4),
            ),
            child: Text(AppLocalizations.of(context)!.upgrade),
          ),
        ],
      ),
    );
  }

  void _showAccessDeniedDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.accessDenied),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/subscription');
            },
            child: Text(AppLocalizations.of(context)!.upgrade),
          ),
        ],
      ),
    );
  }

  List<(DateTime, String)> _getQuickTimeOptions(AppLocalizations l10n) {
    final now = DateTime.now();
    return [
      (now.add(const Duration(minutes: 15)), l10n.in15Minutes),
      (now.add(const Duration(minutes: 30)), l10n.in30Minutes),
      (now.add(const Duration(hours: 1)), l10n.in1Hour),
      (now.add(const Duration(hours: 2)), l10n.in2Hours),
      (DateTime(now.year, now.month, now.day + 1, 9, 0), l10n.tomorrowMorning),
    ];
  }

  IconData _getPriorityIcon(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.low:
        return Icons.keyboard_arrow_down;
      case ReminderPriority.medium:
        return Icons.remove;
      case ReminderPriority.high:
        return Icons.keyboard_arrow_up;
      case ReminderPriority.urgent:
        return Icons.priority_high;
    }
  }

  Color _getTypeColor(ReminderType type) {
    switch (type) {
      case ReminderType.timeBased:
        return Colors.blue;
      case ReminderType.locationBased:
        return Colors.green;
      case ReminderType.meetingRelated:
        return Colors.purple;
      case ReminderType.personal:
        return Colors.orange;
    }
  }

  IconData _getTypeIcon(ReminderType type) {
    switch (type) {
      case ReminderType.timeBased:
        return Icons.schedule;
      case ReminderType.locationBased:
        return Icons.location_on;
      case ReminderType.meetingRelated:
        return Icons.event;
      case ReminderType.personal:
        return Icons.person;
    }
  }

  Color _getPriorityColor(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.low:
        return Colors.blue;
      case ReminderPriority.medium:
        return Colors.orange;
      case ReminderPriority.high:
        return Colors.red;
      case ReminderPriority.urgent:
        return Colors.red;
    }
  }

  String _getNotificationMethodName(ReminderNotificationMethod method, AppLocalizations l10n) {
    switch (method) {
      case ReminderNotificationMethod.push:
        return l10n.pushNotification;
      case ReminderNotificationMethod.local:
        return l10n.localNotification;
      case ReminderNotificationMethod.email:
        return l10n.email;
      case ReminderNotificationMethod.sms:
        return l10n.sms;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }
}