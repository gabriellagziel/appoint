import 'package:flutter/material.dart';

class BusinessProfileCard extends StatelessWidget {
  final String businessName;
  final String businessLogo;
  final Map<String, dynamic>? businessProfile;

  const BusinessProfileCard({
    super.key,
    required this.businessName,
    required this.businessLogo,
    this.businessProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Header
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: businessLogo.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            businessLogo,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.business,
                                color: theme.primaryColor,
                                size: 32,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.business,
                          color: theme.primaryColor,
                          size: 32,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        businessName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (businessProfile?['category'] != null)
                        Text(
                          businessProfile!['category'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Business Details
            if (businessProfile != null) ...[
              _buildDetailRow(
                icon: Icons.location_on,
                label: 'Address',
                value: businessProfile!['address'] ?? 'Address not available',
              ),
              const SizedBox(height: 8),
              
              if (businessProfile!['phone'] != null) ...[
                _buildDetailRow(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: businessProfile!['phone'],
                ),
                const SizedBox(height: 8),
              ],
              
              if (businessProfile!['email'] != null) ...[
                _buildDetailRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: businessProfile!['email'],
                ),
                const SizedBox(height: 8),
              ],
              
              if (businessProfile!['website'] != null) ...[
                _buildDetailRow(
                  icon: Icons.language,
                  label: 'Website',
                  value: businessProfile!['website'],
                ),
                const SizedBox(height: 8),
              ],
              
              if (businessProfile!['description'] != null) ...[
                _buildDetailRow(
                  icon: Icons.info,
                  label: 'About',
                  value: businessProfile!['description'],
                ),
                const SizedBox(height: 8),
              ],
            ],

            // Business Hours (if available)
            if (businessProfile?['businessHours'] != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Business Hours',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildBusinessHours(context),
            ],

            // Rating (if available)
            if (businessProfile?['rating'] != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${businessProfile!['rating']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (businessProfile!['reviewCount'] != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${businessProfile!['reviewCount']} reviews)',
                      style: theme.textTheme.bodySmall,
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessHours(BuildContext context) {
    final hours = businessProfile!['businessHours'] as Map<String, dynamic>?;
    if (hours == null) return const SizedBox.shrink();

    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return Column(
      children: days.map((day) {
        final dayHours = hours[day.toLowerCase()];
        if (dayHours == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  day,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  dayHours['isOpen'] == true
                      ? '${dayHours['open']} - ${dayHours['close']}'
                      : 'Closed',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
} 