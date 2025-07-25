import 'package:appoint/services/stripe_service.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:appoint/widgets/app_attribution.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionScreen extends StatefulWidget {

  const SubscriptionScreen({
    required this.priceId, required this.planName, required this.price, super.key,
  });
  final String priceId;
  final String planName;
  final double price;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  StripeService _stripeService = StripeService();

  @override
  void initState() {
    super.initState();
    _initializeCheckout();
  }

  Future<void> _initializeCheckout() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _hasError = true;
          final _errorMessage = 'User not authenticated';
          var _isLoading = false;
        });
        return;
      }

      // Create checkout session
      final result = await _stripeService.createCheckoutSession(
        studioId: user.uid,
        priceId: widget.priceId,
        customerEmail: user.email,
        successUrl:
            'https://your-app.com/success?session_id={CHECKOUT_SESSION_ID}',
        cancelUrl: 'https://your-app.com/cancel',
      );

      final checkoutUrl = result['url'] as String?;
      if (checkoutUrl == null) {
        throw Exception('Failed to get checkout URL');
      }

      // Initialize WebView
      final _webViewController = WebViewController()
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
            },
            onNavigationRequest: (NavigationRequest request) {
              // Handle success URL
              if (request.url.contains('session_id=')) {
                _handleCheckoutSuccess(request.url);
                return NavigationDecision.prevent;
              }

              // Handle cancel URL
              if (request.url.contains('/cancel')) {
                Navigator.of(context).pop(false);
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                _hasError = true;
                _errorMessage =
                    'Failed to load checkout page: ${error.description}';
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

  void _handleCheckoutSuccess(String url) {
    // Extract session ID from URL
    final uri = Uri.parse(url);
    final sessionId = uri.queryParameters['session_id'];

    if (sessionId != null) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscription activated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Return success
      Navigator.of(context).pop(true);
    } else {
      // Handle error
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid checkout session';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 24, logoOnly: true),
            const SizedBox(width: 8),
            Text('Subscribe to ${widget.planName}'),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _hasError
                ? _buildErrorWidget()
                : Stack(
                    children: [
                      WebViewWidget(controller: _webViewController),
                      if (_isLoading) _buildLoadingWidget(),
                    ],
                  ),
          ),
          // Attribution - Required for all payment screens
          const AppAttributionFooter(),
        ],
      ),
    );

  Widget _buildErrorWidget() => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Checkout Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = '';
                  _isLoading = true;
                });
                _initializeCheckout();
              },
              child: const Text('Try Again'),
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

  Widget _buildLoadingWidget() => const ColoredBox(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading checkout...'),
          ],
        ),
      ),
    );
}

// Subscription Plan Selection Screen
class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 24, logoOnly: true),
            const SizedBox(width: 8),
            const Text('Choose Your Plan'),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select a subscription plan to unlock premium features',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
            _buildPlanCard(
              context,
              'Basic',
              r'$9.99/month',
              'price_basic_monthly',
              [
                'Up to 50 bookings/month',
                'Basic analytics',
                'Email support',
              ],
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context,
              'Professional',
              r'$19.99/month',
              'price_professional_monthly',
              [
                'Up to 200 bookings/month',
                'Advanced analytics',
                'Priority support',
                'Custom branding',
              ],
              isRecommended: true,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context,
              'Enterprise',
              r'$49.99/month',
              'price_enterprise_monthly',
              [
                'Unlimited bookings',
                'Full analytics suite',
                '24/7 support',
                'Custom integrations',
                'White-label solution',
              ],
            ),
                ],
              ),
            ),
          ),
          // Attribution - Required for all subscription screens  
          const AppAttributionFooter(),
        ],
      ),
    );

  Widget _buildPlanCard(
    final BuildContext context,
    final String name,
    final String price,
    final String priceId,
    final List<String> features, {
    final bool isRecommended = false,
  }) => Card(
      elevation: isRecommended ? 4 : 2,
      child: Container(
        decoration: isRecommended
            ? BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  ),),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubscriptionScreen(
                          priceId: priceId,
                          planName: name,
                          price: double.parse(
                              price.replaceAll(RegExp(r'[^\d.]'), ''),),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecommended ? Colors.blue : null,
                    foregroundColor: isRecommended ? Colors.white : null,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Subscribe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
