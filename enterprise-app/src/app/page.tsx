import Button from '@/components/Button';
import {
  ArrowRight,
  BarChart3,
  Calendar,
  CheckCircle,
  Globe, Shield,
  Users,
  Zap
} from 'lucide-react';
import Link from 'next/link';

export default function HomePage() {
  const features = [
    {
      icon: Zap,
      title: 'Instant Integration',
      description: 'Plug into our platform and start scheduling in minutes. Generate keys, manage usage, and monitor performance instantly.',
    },
    {
      icon: Globe,
      title: 'End-User Mobile Experience',
      description: 'Meetings created via our platform are delivered directly to our users&apos; mobile app with calendar sync, reminders, and location.',
    },
    {
      icon: BarChart3,
      title: 'Transparent Billing',
      description: 'No subscriptions. No surprises. Pay per meeting with real-time usage dashboards and monthly invoicing.',
    },
    {
      icon: Shield,
      title: 'Global Localization',
      description: 'Multi-language support, GDPR-compliant, and ready for global deployment from day one.',
    },
  ];

  const pricing = [
    {
      name: 'Basic Meeting',
      price: '€0.49',
      description: 'per meeting',
      features: [
        'Meeting creation via platform',
        'Calendar integration',
        'Mobile app delivery',
        'Reminder notifications',
        'No location/map',
      ],
    },
    {
      name: 'Meeting with Map',
      price: '€0.99',
      description: 'per meeting',
      features: [
        'Everything in Basic',
        'Google Maps integration',
        'Location selection',
        'Directions & navigation',
        'Business search',
      ],
      popular: true,
    },
  ];

  const howItWorks = [
    {
      step: '1',
      title: 'Register',
      description: 'Get access to the platform by registering your business and receiving your key instantly.',
      icon: Users,
    },
    {
      step: '2',
      title: 'Integrate',
      description: 'Use our lightweight REST endpoints to create meetings programmatically.',
      icon: Calendar,
    },
    {
      step: '3',
      title: 'Track & Optimize',
      description: 'Use the live dashboard to monitor usage, manage keys, and export logs.',
      icon: BarChart3,
    },
    {
      step: '4',
      title: 'Get Paid Value',
      description: 'Only pay for what your users actually use — no risk, no waste.',
      icon: CheckCircle,
    },
  ];

  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <header className="bg-white border-b border-neutral-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-6">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-sm">A</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-neutral-900">App-Oint</h1>
                <p className="text-xs text-neutral-500">Enterprise Portal</p>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <Link href="/login" className="text-neutral-600 hover:text-neutral-900">
                Sign In
              </Link>
              <Button variant="primary" size="sm">
                Get Started
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="bg-gradient-to-br from-primary-50 to-secondary-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-neutral-900 mb-6">
            The Smartest Scheduling Platform
            <span className="block text-primary-600">for Serious Businesses</span>
          </h1>
          <p className="text-xl text-neutral-600 mb-8 max-w-3xl mx-auto">
            Integrate App-Oint&apos;s powerful meeting scheduling platform into your application.
            Deliver seamless scheduling experiences to your users with our mobile app,
            calendar sync, and location services.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button variant="primary" size="lg" icon={ArrowRight}>
              Start Building
            </Button>
            <Button variant="outline" size="lg">
              View Documentation
            </Button>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-neutral-900 mb-4">
              Why Choose App-Oint Enterprise?
            </h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {features.map((feature) => {
              const Icon = feature.icon;
              return (
                <div key={feature.title} className="bg-white p-8 rounded-xl border border-neutral-200 hover:shadow-lg transition-shadow">
                  <div className="w-12 h-12 bg-primary-100 rounded-lg flex items-center justify-center mb-6">
                    <Icon className="h-6 w-6 text-primary-600" />
                  </div>
                  <h3 className="text-xl font-semibold text-neutral-900 mb-4">{feature.title}</h3>
                  <p className="text-neutral-600">{feature.description}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section className="py-20 bg-neutral-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-neutral-900 mb-4">
              Simple Pay-Per-Meeting Pricing
            </h2>
            <p className="text-xl text-neutral-600">
              No subscriptions, no hidden fees. Pay only for what you use.
            </p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            {pricing.map((plan) => (
              <div key={plan.name} className={`bg-white p-8 rounded-xl border-2 ${plan.popular ? 'border-primary-500 relative' : 'border-neutral-200'
                }`}>
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-primary-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                      Most Popular
                    </span>
                  </div>
                )}
                <h3 className="text-2xl font-bold text-neutral-900 mb-2">{plan.name}</h3>
                <div className="mb-6">
                  <span className="text-4xl font-bold text-primary-600">{plan.price}</span>
                  <span className="text-neutral-600 ml-2">{plan.description}</span>
                </div>
                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature) => (
                    <li key={feature} className="flex items-center">
                      <CheckCircle className="h-5 w-5 text-success-500 mr-3" />
                      <span className="text-neutral-700">{feature}</span>
                    </li>
                  ))}
                </ul>
                <Button variant={plan.popular ? 'primary' : 'outline'} className="w-full">
                  Get Started
                </Button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-neutral-900 mb-4">How It Works</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {howItWorks.map((step) => {
              const Icon = step.icon;
              return (
                <div key={step.step} className="text-center">
                  <div className="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6">
                    <Icon className="h-8 w-8 text-primary-600" />
                  </div>
                  <div className="text-2xl font-bold text-primary-600 mb-2">{step.step}</div>
                  <h3 className="text-xl font-semibold text-neutral-900 mb-4">{step.title}</h3>
                  <p className="text-neutral-600">{step.description}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* FAQ Section */}
      <section className="py-20 bg-neutral-50">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-neutral-900 mb-4">Frequently Asked Questions</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="bg-white p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-neutral-900 mb-3">Is there a subscription?</h3>
              <p className="text-neutral-600">No. We charge only based on meeting usage — transparent and fair.</p>
            </div>
            <div className="bg-white p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-neutral-900 mb-3">Do meetings appear in the user&apos;s app?</h3>
              <p className="text-neutral-600">Yes! This is what makes us different. Meetings appear in the user&apos;s App-Oint app with full calendar + location + reminder experience.</p>
            </div>
            <div className="bg-white p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-neutral-900 mb-3">How do we pay?</h3>
              <p className="text-neutral-600">You receive a monthly invoice. Pay securely via bank transfer within 7–10 business days.</p>
            </div>
            <div className="bg-white p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-neutral-900 mb-3">What happens if we don&apos;t pay?</h3>
              <p className="text-neutral-600">Access will be temporarily paused. You&apos;ll receive warnings beforehand.</p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-primary-600">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-white mb-6">
            Let&apos;s Build Smarter Scheduling Together
          </h2>
          <p className="text-xl text-primary-100 mb-8">
            Join thousands of businesses using App-Oint to deliver exceptional scheduling experiences.
          </p>
          <Button variant="secondary" size="lg" icon={ArrowRight}>
            Get Started Now
          </Button>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-neutral-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <div className="flex items-center space-x-3 mb-4 md:mb-0">
              <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-sm">A</span>
              </div>
              <span className="text-lg font-bold">App-Oint</span>
            </div>
            <div className="flex space-x-6 text-sm">
              <Link href="/terms" className="text-neutral-300 hover:text-white">
                Terms
              </Link>
              <Link href="/privacy" className="text-neutral-300 hover:text-white">
                Privacy
              </Link>
              <Link href="/support" className="text-neutral-300 hover:text-white">
                Support
              </Link>
            </div>
          </div>
          <div className="mt-8 pt-8 border-t border-neutral-800 text-center text-sm text-neutral-400">
            © 2025 App-Oint. All rights reserved.
          </div>
        </div>
      </footer>
    </div>
  );
}
