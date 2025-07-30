import 'package:appoint/features/studio_business/models/business_profile.dart';
import 'package:appoint/features/studio_business/providers/business_profile_provider.dart';
import 'package:appoint/features/studio_business/services/business_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessHeaderWidget extends ConsumerWidget {
  const BusinessHeaderWidget({
    super.key,
    this.businessId,
    this.showDescription = true,
    this.showServices = true,
    this.showHours = false,
    this.compact = false,
  });

  final String? businessId;
  final bool showDescription;
  final bool showServices;
  final bool showHours;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we'll use the current business profile
    // In the future, this could be enhanced to fetch specific business by ID
    final businessProfile = ref.watch(businessProfileProvider);

    if (businessProfile == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business header with logo and name
            Row(
              children: [
                // Business logo
                Container(
                  width: compact ? 50 : 64,
                  height: compact ? 50 : 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                  ),
                  child: businessProfile.logoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            businessProfile.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                              Icons.business,
                              size: compact ? 24 : 32,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.business,
                          size: compact ? 24 : 32,
                          color: Colors.grey.shade400,
                        ),
                ),
                const SizedBox(width: 12),
                
                // Business info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        businessProfile.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: compact ? 16 : 20,
                        ),
                      ),
                      if (businessProfile.phone.isNotEmpty)
                        Text(
                          businessProfile.phone,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: compact ? 12 : 14,
                          ),
                        ),
                      if (businessProfile.address.isNotEmpty)
                        Text(
                          businessProfile.address,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: compact ? 11 : 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                
                // Verified badge (for future use)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Business description
            if (showDescription && businessProfile.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                businessProfile.description,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: compact ? 13 : 14,
                  height: 1.4,
                ),
                maxLines: compact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // Services
            if (showServices && businessProfile.services.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: businessProfile.services.take(compact ? 3 : 5).map((service) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    service,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
            
            // Business hours
            if (showHours && businessProfile.businessHours.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildBusinessHours(context, businessProfile.businessHours, compact),
            ],
            
            // Contact information
            if (!compact && (businessProfile.email.isNotEmpty || businessProfile.website.isNotEmpty)) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (businessProfile.email.isNotEmpty) ...[
                    Icon(Icons.email, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      businessProfile.email,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  if (businessProfile.email.isNotEmpty && businessProfile.website.isNotEmpty)
                    Text(
                      ' • ',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  if (businessProfile.website.isNotEmpty) ...[
                    Icon(Icons.language, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      businessProfile.website.replaceAll('https://', '').replaceAll('http://', ''),
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHours(BuildContext context, Map<String, dynamic> businessHours, bool compact) {
    final today = DateTime.now().weekday;
    final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final todayKey = dayNames[today - 1];
    final todayHours = businessHours[todayKey] as Map<String, dynamic>?;
    
    if (todayHours == null) return const SizedBox.shrink();
    
    final isOpenToday = todayHours['closed'] != true;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isOpenToday ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOpenToday ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOpenToday ? Icons.schedule : Icons.schedule_outlined,
            size: 16,
            color: isOpenToday ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            isOpenToday 
                ? 'Open today: ${todayHours['open']} - ${todayHours['close']}'
                : 'Closed today',
            style: TextStyle(
              color: isOpenToday ? Colors.green.shade700 : Colors.red.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Provider for fetching specific business profile by ID (for future use)
final businessProfileByIdProvider = FutureProvider.family<BusinessProfile?, String>((ref, businessId) async {
  try {
    final service = BusinessProfileService();
    return await service.fetchProfile();
  } catch (e) {
    return null;
  }
});