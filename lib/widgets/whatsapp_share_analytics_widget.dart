import 'package:appoint/providers/whatsapp_group_share_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhatsAppShareAnalyticsWidget extends ConsumerWidget {
  const WhatsAppShareAnalyticsWidget({
    super.key,
    required this.appointmentId,
    this.compact = false,
  });

  final String appointmentId;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(appointmentShareAnalyticsProvider(appointmentId));

    return analyticsAsync.when(
      data: (analytics) => compact 
          ? _buildCompactView(context, analytics)
          : _buildDetailedView(context, analytics),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Error loading analytics: $error'),
    );
  }

  Widget _buildCompactView(BuildContext context, Map<String, dynamic> analytics) {
    final whatsappGroupJoins = analytics['whatsappGroupJoins'] ?? 0;
    final whatsappGroupShares = analytics['whatsappGroupShares'] ?? 0;
    
    if (whatsappGroupShares == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF25D366).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF25D366).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.groups,
            size: 16,
            color: Color(0xFF25D366),
          ),
          const SizedBox(width: 4),
          Text(
            '$whatsappGroupJoins joins via WhatsApp',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF25D366),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedView(BuildContext context, Map<String, dynamic> analytics) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Color(0xFF25D366)),
                const SizedBox(width: 8),
                Text(
                  'WhatsApp Group Share Analytics',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Overall metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Total Shares',
                    analytics['totalShares']?.toString() ?? '0',
                    Icons.share,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Total Clicks',
                    analytics['totalClicks']?.toString() ?? '0',
                    Icons.mouse,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Total Joins',
                    analytics['totalJoins']?.toString() ?? '0',
                    Icons.person_add,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // WhatsApp specific metrics
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF25D366).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.groups,
                        size: 20,
                        color: Color(0xFF25D366),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'WhatsApp Group Performance',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF25D366),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWhatsAppMetric(
                          context,
                          'Shares',
                          analytics['whatsappGroupShares']?.toString() ?? '0',
                        ),
                      ),
                      Expanded(
                        child: _buildWhatsAppMetric(
                          context,
                          'Clicks',
                          analytics['whatsappGroupClicks']?.toString() ?? '0',
                        ),
                      ),
                      Expanded(
                        child: _buildWhatsAppMetric(
                          context,
                          'Joins',
                          analytics['whatsappGroupJoins']?.toString() ?? '0',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Conversion rates
            Row(
              children: [
                Expanded(
                  child: _buildConversionCard(
                    context,
                    'Overall Conversion',
                    '${((analytics['conversionRate'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildConversionCard(
                    context,
                    'WhatsApp Conversion',
                    '${((analytics['whatsappGroupConversionRate'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                    const Color(0xFF25D366),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppMetric(
    BuildContext context,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF25D366),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildConversionCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}