import 'package:appoint/providers/family_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyRequestWidget extends ConsumerStatefulWidget {

  const PrivacyRequestWidget({
    required this.childId, super.key,
  });
  final String childId;

  @override
  ConsumerState<PrivacyRequestWidget> createState() =>
      _PrivacyRequestWidgetState();
}

class _PrivacyRequestWidgetState extends ConsumerState<PrivacyRequestWidget> {
  bool _isLoading = false;
  bool _hasActiveRequest = false;

  @override
  void initState() {
    super.initState();
    _checkActiveRequests();
  }

  Future<void> _checkActiveRequests() async {
    try {
      final requests = await ref
          .read(familyServiceProvider)
          .fetchPrivacyRequests(widget.childId);
      setState(() {
        _hasActiveRequest =
            requests.any((req) => req.status == 'pending');
      });
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _sendPrivacyRequest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(familyServiceProvider).sendPrivacyRequest(widget.childId);

      setState(() {
        _hasActiveRequest = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy request sent to your parents!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send privacy request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _hasActiveRequest ? Icons.pending : Icons.privacy_tip,
                  color: _hasActiveRequest ? Colors.orange : Colors.blue,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Privacy Request',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _hasActiveRequest
                  ? 'You have a pending privacy request. Waiting for parent approval.'
                  : 'Request a private session from your parents.',
              style: TextStyle(
                color: _hasActiveRequest ? Colors.orange : Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (!_hasActiveRequest)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _sendPrivacyRequest,
                  icon: const Icon(Icons.privacy_tip),
                  label: const Text('Request Private Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'This will notify your parents that you want to use the app privately.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
}
