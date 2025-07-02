import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:appoint/services/stripe_service.dart';

class SubscriptionScreen extends StatefulWidget {
  final String studioId;
  final String priceId;
  final String planName;
  final double price;

  const SubscriptionScreen({
    super.key,
    required this.studioId,
    required this.priceId,
    required this.planName,
    required this.price,
  });

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() async {
    try {
      // Create checkout session
      final sessionData = await StripeService().createCheckoutSession(
        studioId: widget.studioId,
        priceId: widget.priceId,
      );

      final checkoutUrl = sessionData['url'] as String;

      // Initialize WebView controller
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (final String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (final String url) {
              setState(() {
                _isLoading = false;
              });

              // Check for success URL with session_id
              if (url.contains('session_id=')) {
                _handleSuccessfulPayment(url);
              }

              // Check for cancel URL
              if (url.contains('canceled=true') || url.contains('cancel_url')) {
                _handleCancelledPayment();
              }
            },
            onNavigationRequest: (final NavigationRequest request) {
              // Handle navigation requests
              if (request.url.contains('session_id=')) {
                _handleSuccessfulPayment(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onWebResourceError: (final WebResourceError error) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Error loading checkout: ${error.description}';
                _isLoading = false;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(checkoutUrl));
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize checkout: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSuccessfulPayment(final String url) async {
    try {
      // Extract session_id from URL
      final uri = Uri.parse(url);
      final sessionId = uri.queryParameters['session_id'];

      if (sessionId != null) {
        // Update subscription status
        await StripeService().updateSubscriptionStatus(
          studioId: widget.studioId,
          status: 'active',
          subscriptionId: sessionId,
        );

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subscription activated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error confirming payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleCancelledPayment() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment was cancelled'),
          backgroundColor: Colors.orange,
        ),
      );
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe to ${widget.planName}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Plan information header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                Text(
                  widget.planName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.price.toStringAsFixed(2)}/month',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete your subscription below',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // WebView or error content
          Expanded(
            child: _hasError
                ? _buildErrorWidget()
                : WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Checkout',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _isLoading = true;
                });
                _initializeWebView();
              },
              child: const Text('Retry'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
