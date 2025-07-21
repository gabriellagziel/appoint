import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Check, X, Star, Zap, Users, BarChart3 } from 'lucide-react'

const plans = [
  {
    name: 'Starter',
    price: '€5',
    period: '/month',
    description: 'Perfect for small businesses starting their appointment journey',
    icon: Star,
    color: 'blue',
    popular: false,
    features: [
      'Up to 100 appointments/month',
      'Basic calendar integration',
      'Email notifications',
      'Mobile-friendly booking page',
      'Standard support',
      'Basic analytics',
      '5 map loads/day',
      'App-Oint branding'
    ],
    limitations: [
      'No custom branding',
      'Limited integrations',
      'No advanced analytics'
    ]
  },
  {
    name: 'Professional',
    price: '€15',
    period: '/month',
    description: 'Advanced features for growing businesses with custom needs',
    icon: Zap,
    color: 'purple',
    popular: true,
    features: [
      'Up to 500 appointments/month',
      'Advanced calendar sync',
      'SMS & email notifications',
      'Custom booking forms',
      'Priority support',
      'Advanced analytics & reports',
      '50 map loads/day',
      'Custom branding options',
      'Multi-staff management',
      'Customer database',
      'Payment integration',
      'Automated reminders'
    ],
    limitations: [
      'Limited white-label options'
    ]
  },
  {
    name: 'Business Plus',
    price: '€25',
    period: '/month',
    description: 'Enterprise-grade solution with unlimited features',
    icon: Users,
    color: 'green',
    popular: false,
    features: [
      'Unlimited appointments',
      'Full calendar ecosystem',
      'Multi-channel notifications',
      'Advanced custom forms',
      'Dedicated support',
      'Real-time analytics dashboard',
      'Unlimited map loads',
      'Full white-label branding',
      'Multi-location support',
      'Advanced CRM features',
      'API access',
      'Custom integrations',
      'Team collaboration tools',
      'Advanced reporting suite'
    ],
    limitations: []
  }
]

const features = [
  { name: 'Monthly Appointments', starter: '100', professional: '500', business: 'Unlimited' },
  { name: 'Map Loads/Day', starter: '5', professional: '50', business: 'Unlimited' },
  { name: 'Staff Users', starter: '1', professional: '5', business: 'Unlimited' },
  { name: 'Custom Branding', starter: false, professional: 'Partial', business: 'Full' },
  { name: 'SMS Notifications', starter: false, professional: true, business: true },
  { name: 'API Access', starter: false, professional: false, business: true },
  { name: 'Multi-location', starter: false, professional: false, business: true },
  { name: 'White-label', starter: false, professional: false, business: true },
  { name: 'Support Level', starter: 'Standard', professional: 'Priority', business: 'Dedicated' }
]

export default function PricingPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      
      {/* Hero Section */}
      <section className="py-16 sm:py-24">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-light text-gray-900 mb-6">
              Simple, Transparent Pricing
            </h1>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
              Choose the perfect plan for your business. All plans include our core scheduling features 
              with no hidden fees or setup costs.
            </p>
            <div className="flex items-center justify-center space-x-4 text-sm text-gray-500">
              <span className="flex items-center">
                <Check className="w-4 h-4 text-green-500 mr-2" />
                30-day free trial
              </span>
              <span className="flex items-center">
                <Check className="w-4 h-4 text-green-500 mr-2" />
                Cancel anytime
              </span>
              <span className="flex items-center">
                <Check className="w-4 h-4 text-green-500 mr-2" />
                No setup fees
              </span>
            </div>
          </div>

          {/* Pricing Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-7xl mx-auto">
            {plans.map((plan) => {
              const IconComponent = plan.icon
              return (
                <Card 
                  key={plan.name} 
                  className={`relative ${plan.popular ? 'border-2 border-purple-500 shadow-lg scale-105' : ''} hover:shadow-xl transition-all duration-300`}
                >
                  {plan.popular && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                      <span className="bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                        Most Popular
                      </span>
                    </div>
                  )}
                  
                  <CardHeader className="text-center pb-4">
                    <div className={`mx-auto mb-4 w-16 h-16 bg-${plan.color}-100 rounded-full flex items-center justify-center`}>
                      <IconComponent className={`w-8 h-8 text-${plan.color}-600`} />
                    </div>
                    <CardTitle className="text-2xl font-bold text-gray-900">
                      {plan.name}
                    </CardTitle>
                    <div className="mt-4">
                      <span className="text-4xl font-bold text-gray-900">{plan.price}</span>
                      <span className="text-gray-500">{plan.period}</span>
                    </div>
                    <CardDescription className="mt-2">
                      {plan.description}
                    </CardDescription>
                  </CardHeader>
                  
                  <CardContent className="space-y-6">
                    <Button 
                      className={`w-full ${plan.popular ? 'bg-purple-600 hover:bg-purple-700' : ''}`}
                      size="lg"
                    >
                      Start {plan.name} Plan
                    </Button>
                    
                    <div>
                      <h4 className="font-semibold text-gray-900 mb-3">What's included:</h4>
                      <ul className="space-y-2">
                        {plan.features.map((feature, index) => (
                          <li key={index} className="flex items-start">
                            <Check className="w-4 h-4 text-green-500 mr-3 mt-0.5 flex-shrink-0" />
                            <span className="text-sm text-gray-600">{feature}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                    
                    {plan.limitations.length > 0 && (
                      <div>
                        <h4 className="font-semibold text-gray-900 mb-3">Limitations:</h4>
                        <ul className="space-y-2">
                          {plan.limitations.map((limitation, index) => (
                            <li key={index} className="flex items-start">
                              <X className="w-4 h-4 text-gray-400 mr-3 mt-0.5 flex-shrink-0" />
                              <span className="text-sm text-gray-500">{limitation}</span>
                            </li>
                          ))}
                        </ul>
                      </div>
                    )}
                  </CardContent>
                </Card>
              )
            })}
          </div>
        </div>
      </section>

      {/* Feature Comparison Table */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Detailed Feature Comparison
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Compare all features across our plans to find the perfect fit for your business needs.
            </p>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full border-collapse border border-gray-200 rounded-lg">
              <thead>
                <tr className="bg-gray-50">
                  <th className="border border-gray-200 px-6 py-4 text-left font-semibold text-gray-900">
                    Feature
                  </th>
                  <th className="border border-gray-200 px-6 py-4 text-center font-semibold text-gray-900">
                    Starter
                  </th>
                  <th className="border border-gray-200 px-6 py-4 text-center font-semibold text-purple-600 bg-purple-50">
                    Professional
                  </th>
                  <th className="border border-gray-200 px-6 py-4 text-center font-semibold text-gray-900">
                    Business Plus
                  </th>
                </tr>
              </thead>
              <tbody>
                {features.map((feature, index) => (
                  <tr key={index} className={index % 2 === 0 ? 'bg-gray-50' : 'bg-white'}>
                    <td className="border border-gray-200 px-6 py-4 font-medium text-gray-900">
                      {feature.name}
                    </td>
                    <td className="border border-gray-200 px-6 py-4 text-center">
                      {typeof feature.starter === 'boolean' ? (
                        feature.starter ? (
                          <Check className="w-5 h-5 text-green-500 mx-auto" />
                        ) : (
                          <X className="w-5 h-5 text-gray-400 mx-auto" />
                        )
                      ) : (
                        <span className="text-gray-600">{feature.starter}</span>
                      )}
                    </td>
                    <td className="border border-gray-200 px-6 py-4 text-center bg-purple-50">
                      {typeof feature.professional === 'boolean' ? (
                        feature.professional ? (
                          <Check className="w-5 h-5 text-green-500 mx-auto" />
                        ) : (
                          <X className="w-5 h-5 text-gray-400 mx-auto" />
                        )
                      ) : (
                        <span className="text-gray-600">{feature.professional}</span>
                      )}
                    </td>
                    <td className="border border-gray-200 px-6 py-4 text-center">
                      {typeof feature.business === 'boolean' ? (
                        feature.business ? (
                          <Check className="w-5 h-5 text-green-500 mx-auto" />
                        ) : (
                          <X className="w-5 h-5 text-gray-400 mx-auto" />
                        )
                      ) : (
                        <span className="text-gray-600">{feature.business}</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {/* FAQ Section */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Frequently Asked Questions
            </h2>
          </div>
          
          <div className="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="space-y-6">
              <div>
                <h3 className="font-semibold text-gray-900 mb-2">Can I change plans anytime?</h3>
                <p className="text-gray-600">Yes, you can upgrade or downgrade your plan at any time. Changes take effect immediately.</p>
              </div>
              <div>
                <h3 className="font-semibold text-gray-900 mb-2">What happens if I exceed my appointment limit?</h3>
                <p className="text-gray-600">We'll notify you as you approach your limit. You can upgrade your plan or additional appointments are charged at €0.10 each.</p>
              </div>
              <div>
                <h3 className="font-semibold text-gray-900 mb-2">Do you offer annual discounts?</h3>
                <p className="text-gray-600">Yes! Save 20% when you pay annually. Contact our sales team for custom enterprise pricing.</p>
              </div>
            </div>
            <div className="space-y-6">
              <div>
                <h3 className="font-semibold text-gray-900 mb-2">Is there a setup fee?</h3>
                <p className="text-gray-600">No setup fees, ever. You only pay the monthly subscription fee for your chosen plan.</p>
              </div>
              <div>
                <h3 className="font-semibold text-gray-900 mb-2">What's included in the free trial?</h3>
                <p className="text-gray-600">Full access to all Professional plan features for 30 days. No credit card required to start.</p>
              </div>
              <div>
                <h3 className="font-semibold text-gray-900 mb-2">How do map loads work?</h3>
                <p className="text-gray-600">Each time a customer views a map on your booking page counts as one load. Exceeded loads are charged at €0.01 each.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-blue-600">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-white mb-4">
            Ready to Get Started?
          </h2>
          <p className="text-blue-100 mb-8 max-w-2xl mx-auto">
            Join thousands of businesses already using App-Oint to streamline their appointment scheduling.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" className="bg-white text-blue-600 hover:bg-gray-100">
              Start Free Trial
            </Button>
            <Button size="lg" variant="outline" className="border-white text-white hover:bg-white hover:text-blue-600">
              Schedule a Demo
            </Button>
          </div>
        </div>
      </section>
    </div>
  )
}