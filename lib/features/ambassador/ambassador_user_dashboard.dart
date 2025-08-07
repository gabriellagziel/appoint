import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:appoint/services/ambassador_service.dart';
import 'package:appoint/models/ambassador_profile.dart';
import 'package:appoint/l10n/app_localizations.dart';

class AmbassadorUserDashboard extends StatefulWidget {
  const AmbassadorUserDashboard({super.key});

  @override
  State<AmbassadorUserDashboard> createState() =>
      _AmbassadorUserDashboardState();
}

class _AmbassadorUserDashboardState extends State<AmbassadorUserDashboard> {
  late AmbassadorService _ambassadorService;
  AmbassadorProfile? _profile;
  List<dynamic> _recentReferrals = [];
  List<dynamic> _activeRewards = [];
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _ambassadorService = AmbassadorService();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final dashboardData = await _ambassadorService.getAmbassadorDashboard();

      setState(() {
        _dashboardData = dashboardData;
        _profile = dashboardData['profile'] as AmbassadorProfile?;
        _recentReferrals =
            dashboardData['recentReferrals'] as List<dynamic>? ?? [];
        _activeRewards = dashboardData['activeRewards'] as List<dynamic>? ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ambassadorDashboard),
        backgroundColor: const Color(0xFF0A84FF),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorWidget()
              : _buildDashboardContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading dashboard',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(_errorMessage!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDashboardData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (_profile == null) {
      return _buildNotAmbassadorWidget();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildProgressSection(),
          const SizedBox(height: 16),
          _buildShareSection(),
          const SizedBox(height: 16),
          _buildRecentReferrals(),
          const SizedBox(height: 16),
          _buildActiveRewards(),
        ],
      ),
    );
  }

  Widget _buildNotAmbassadorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Not an Ambassador',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'You need to be approved as an ambassador to access this dashboard.',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to ambassador application
            },
            child: const Text('Apply to be an Ambassador'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final status = _profile!.status;
    final tier = _profile!.tier;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'pending_ambassador':
        statusColor = Colors.orange;
        statusText = 'Pending Approval';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Active Ambassador';
        statusIcon = Icons.check_circle;
        break;
      case 'inactive':
        statusColor = Colors.red;
        statusText = 'Inactive';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        statusIcon = Icons.help;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getTierColor(tier),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tier.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (status == 'pending_ambassador') ...[
              const SizedBox(height: 8),
              Text(
                'Your application is under review. We\'ll notify you within 48 hours.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.orange[700]),
              ),
            ],
            if (_profile!.rejectionReason != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Rejection Reason: ${_profile!.rejectionReason}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red[700]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final totalReferrals = _profile!.totalReferrals;
    final monthlyReferrals = _dashboardData?['thisMonthReferrals'] ?? 0;
    final referralsToNextTier = _dashboardData?['referralsToNextTier'] ?? 0;
    final currentTier = _dashboardData?['currentTier'] ?? 'basic';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildProgressBar(
              'This Month',
              monthlyReferrals,
              10, // Minimum monthly requirement
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildProgressBar(
              'Lifetime',
              totalReferrals,
              _getNextTierRequirement(currentTier),
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildStatusMessage(currentTier, referralsToNextTier),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, int current, int target, Color color) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text('$current/$target')],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildStatusMessage(String currentTier, int referralsToNextTier) {
    String message;
    Color messageColor;

    if (currentTier == 'lifetime') {
      message = '🎉 You\'ve reached the highest tier!';
      messageColor = Colors.purple;
    } else if (referralsToNextTier <= 0) {
      message = '🎉 You\'re ready for the next tier!';
      messageColor = Colors.green;
    } else {
      message =
          'You\'re $referralsToNextTier away from ${_getNextTierName(currentTier)}!';
      messageColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: messageColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: messageColor.withOpacity(0.3)),
      ),
      child: Text(
        message,
        style: TextStyle(color: messageColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildShareSection() {
    final shareLink = _profile!.shareLink;
    final shareCode = _profile!.shareCode;

    if (shareLink == null || shareCode == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share Your Link',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      shareCode,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _copyToClipboard(shareCode),
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy code',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      shareLink,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _shareLink(shareLink),
                  icon: const Icon(Icons.share),
                  tooltip: 'Share link',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: QrImageView(
                  data: shareLink,
                  version: QrVersions.auto,
                  size: 120,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReferrals() {
    if (_recentReferrals.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Referrals',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'No referrals yet. Start sharing your link!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Referrals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...(_recentReferrals
                .take(5)
                .map((referral) => _buildReferralItem(referral))),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralItem(Map<String, dynamic> referral) {
    final referredAt = referral['referredAt'] as Timestamp?;
    final referredUserId = referral['referredUserId'] as String?;

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(referredUserId ?? 'Unknown User'),
      subtitle: Text(
        referredAt != null
            ? 'Referred on ${_formatDate(referredAt.toDate())}'
            : 'Unknown date',
      ),
      trailing: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  Widget _buildActiveRewards() {
    if (_activeRewards.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Rewards',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'No active rewards yet. Keep referring users to earn rewards!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Rewards',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...(_activeRewards.map((reward) => _buildRewardItem(reward))),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(Map<String, dynamic> reward) {
    final type = reward['type'] as String?;
    final description = reward['description'] as String?;
    final expiresAt = reward['expiresAt'] as Timestamp?;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getRewardColor(type),
        child: Icon(_getRewardIcon(type), color: Colors.white),
      ),
      title: Text(description ?? 'Unknown Reward'),
      subtitle:
          expiresAt != null
              ? Text('Expires: ${_formatDate(expiresAt.toDate())}')
              : const Text('No expiration'),
      trailing: const Icon(Icons.star, color: Colors.amber),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied to clipboard: $text')));
  }

  void _shareLink(String link) {
    Share.share(
      'Join me on App-Oint! Use my referral link: $link',
      subject: 'Join me on App-Oint',
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'basic':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      case 'lifetime':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getRewardColor(String? type) {
    switch (type) {
      case 'premium_features':
        return Colors.blue;
      case 'one_year_access':
        return Colors.green;
      case 'lifetime_access':
        return Colors.orange;
      case 'monthly_premium':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getRewardIcon(String? type) {
    switch (type) {
      case 'premium_features':
        return Icons.star;
      case 'one_year_access':
        return Icons.access_time;
      case 'lifetime_access':
        return Icons.all_inclusive;
      case 'monthly_premium':
        return Icons.monthly;
      default:
        return Icons.card_giftcard;
    }
  }

  int _getNextTierRequirement(String currentTier) {
    switch (currentTier.toLowerCase()) {
      case 'basic':
        return 50; // Premium tier
      case 'premium':
        return 1000; // Lifetime tier
      default:
        return 0;
    }
  }

  String _getNextTierName(String currentTier) {
    switch (currentTier.toLowerCase()) {
      case 'basic':
        return 'Premium';
      case 'premium':
        return 'Lifetime';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
