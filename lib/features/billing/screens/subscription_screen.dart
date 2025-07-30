import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionScreen extends StatefulWidget {

  const SubscriptionScreen({
    required this.studioId, required this.priceId, required this.planName, required this.price, super.key,
  });
  final String studioId;
  final String priceId;
  final String planName;
  final double price;

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

  Future<void> _initializeWebView() async {
    try {
      // Create checkout session
      sessionData = await StripeService().createCheckoutSession(
        studioId: widget.studioId,
        priceId: widget.priceId,
      );

      final checkoutUrl = sessionData['url'] as String;

      // Initialize WebView controller
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
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
            onNavigationRequest: (NavigationRequest request) {
              // Handle navigation requests
              if (request.url.contains('session_id=')) {
                _handleSuccessfulPayment(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onWebResourceError: (WebResourceError error) {
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

  Future<void> _handleSuccessfulPayment(String url) async {
    try {
      // Extract session_id from URL
      uri = Uri.parse(url);
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
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.REDACTED_TOKEN),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorConfirmingPayment(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleCancelledPayment() {
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.paymentWasCancelled),
          backgroundColor: Colors.orange,
        ),
      );
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.subscribeTo(widget.planName)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
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
                  AppLocalizations.of(context)!.completeYourSubscription,
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

  Widget _buildErrorWidget() => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              AppLocalizations.of(context)!.errorLoadingCheckout,
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
              child: Text(AppLocalizations.of(context)!.retry),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
      ),
    );
}
