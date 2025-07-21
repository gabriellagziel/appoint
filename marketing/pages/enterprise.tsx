import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { 
  Code, 
  Database, 
  Shield, 
  Zap, 
  Globe,
  Users,
  BarChart3,
  Settings,
  CheckCircle,
  ArrowRight,
  Building,
  Headphones,
  Clock,
  Lock
} from 'lucide-react'

const apiFeatures = [
  {
    name: 'RESTful API',
    description: 'Clean, well-documented REST API with JSON responses',
    icon: Code
  },
  {
    name: 'High Availability',
    description: '99.9% uptime SLA with global CDN distribution',
    icon: Zap
  },
  {
    name: 'Enterprise Security',
    description: 'OAuth 2.0, API keys, rate limiting, and encryption',
    icon: Shield
  },
  {
    name: 'Scalable Infrastructure',
    description: 'Auto-scaling to handle millions of API calls',
    icon: Database
  },
  {
    name: 'Global Reach',
    description: 'Multi-region deployment with low latency worldwide',
    icon: Globe
  },
  {
    name: 'Real-time Webhooks',
    description: 'Instant notifications for booking events and updates',
    icon: Settings
  }
]

const useCases = [
  {
    title: 'SaaS Platforms',
    description: 'Integrate appointment scheduling into your SaaS product',
    icon: Building,
    features: ['White-label API', 'Custom branding', 'Multi-tenant support']
  },
  {
    title: 'Mobile Applications',
    description: 'Power mobile apps with robust scheduling capabilities',
    icon: Globe,
    features: ['Native SDKs', 'Offline sync', 'Push notifications']
  },
  {
    title: 'Enterprise Systems',
    description: 'Connect with existing CRM, ERP, and business systems',
    icon: Database,
    features: ['Custom integrations', 'Data migration', 'Legacy system support']
  },
  {
    title: 'Marketplace Platforms',
    description: 'Enable service providers to manage bookings at scale',
    icon: Users,
    features: ['Multi-vendor support', 'Commission tracking', 'Automated payouts']
  }
]

const pricingTiers = [
  {
    name: 'Developer',
    price: 'Free',
    description: 'Perfect for testing and small applications',
    features: [
      '1,000 API calls/month',
      'Basic documentation',
      'Community support',
      'Sandbox environment'
    ],
    limitations: [
      'No SLA guarantee',
      'Rate limited',
      'Basic features only'
    ]
  },
  {
    name: 'Business API',
    price: 'Custom',
    description: 'Scalable solution for growing businesses',
    features: [
      'Unlimited API calls',
      'Priority support',
      '99.9% uptime SLA',
      'Custom rate limits',
      'Advanced analytics',
      'Webhooks & notifications',
      'Multi-region deployment'
    ],
    popular: true
  },
  {
    name: 'Enterprise',
    price: 'Contact Us',
    description: 'Complete solution for large organizations',
    features: [
      'Everything in Business API',
      'Dedicated infrastructure',
      'Custom integrations',
      'On-premise deployment',
      'White-label solutions',
      'Dedicated account manager',
      'Custom SLA terms'
    ]
  }
]

export default function EnterprisePage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      
      {/* Hero Section */}
      <section className="py-16 sm:py-24 bg-gradient-to-br from-gray-900 to-blue-900 text-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-light mb-6">
              Enterprise API Solutions
            </h1>
            <p className="text-xl text-blue-100 mb-8">
              Power your applications with App-Oint's robust scheduling API. 
              <span className="block mt-2 font-medium text-yellow-300">
                Note: Enterprise API is separate from our regular business subscription plans.
              </span>
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button size="lg" className="bg-white text-gray-900 hover:bg-gray-100">
                View API Documentation
              </Button>
              <Button size="lg" variant="outline" className="border-white text-white hover:bg-white hover:text-gray-900">
                Contact Sales Team
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Key Features */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Enterprise-Grade API Platform
            </h2>
            <p className="text-gray-600 max-w-3xl mx-auto">
              Built for scale, security, and reliability. Our API handles millions of requests 
              daily for some of the world's largest companies.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {apiFeatures.map((feature, index) => {
              const IconComponent = feature.icon
              return (
                <Card key={index} className="hover:shadow-lg transition-all duration-300">
                  <CardHeader>
                    <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
                      <IconComponent className="w-6 h-6 text-blue-600" />
                    </div>
                    <CardTitle className="text-xl font-semibold text-gray-900">
                      {feature.name}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <CardDescription className="text-gray-600">
                      {feature.description}
                    </CardDescription>
                  </CardContent>
                </Card>
              )
            })}
          </div>
        </div>
      </section>

      {/* Use Cases */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Built for Every Enterprise Use Case
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              From startups to Fortune 500 companies, our API adapts to your specific needs 
              and scales with your business growth.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {useCases.map((useCase, index) => {
              const IconComponent = useCase.icon
              return (
                <Card key={index} className="hover:shadow-lg transition-all duration-300">
                  <CardHeader>
                    <div className="flex items-center mb-4">
                      <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mr-4">
                        <IconComponent className="w-6 h-6 text-green-600" />
                      </div>
                      <div>
                        <CardTitle className="text-xl font-semibold text-gray-900">
                          {useCase.title}
                        </CardTitle>
                        <CardDescription className="text-gray-600 mt-1">
                          {useCase.description}
                        </CardDescription>
                      </div>
                    </div>
                  </CardHeader>
                  <CardContent>
                    <ul className="space-y-2">
                      {useCase.features.map((feature, featureIndex) => (
                        <li key={featureIndex} className="flex items-center text-sm text-gray-600">
                          <CheckCircle className="w-4 h-4 text-green-500 mr-2 flex-shrink-0" />
                          {feature}
                        </li>
                      ))}
                    </ul>
                  </CardContent>
                </Card>
              )
            })}
          </div>
        </div>
      </section>

      {/* API Pricing */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              API Pricing Plans
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Flexible pricing options designed to grow with your business. 
              Enterprise solutions are completely separate from our standard business subscriptions.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
            {pricingTiers.map((tier, index) => (
              <Card 
                key={index} 
                className={`relative ${tier.popular ? 'border-2 border-blue-500 shadow-lg scale-105' : ''} hover:shadow-xl transition-all duration-300`}
              >
                {tier.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                      Most Popular
                    </span>
                  </div>
                )}
                
                <CardHeader className="text-center">
                  <CardTitle className="text-2xl font-bold text-gray-900">
                    {tier.name}
                  </CardTitle>
                  <div className="mt-4">
                    <span className="text-4xl font-bold text-gray-900">{tier.price}</span>
                  </div>
                  <CardDescription className="mt-2">
                    {tier.description}
                  </CardDescription>
                </CardHeader>
                
                <CardContent className="space-y-6">
                  <Button 
                    className={`w-full ${tier.popular ? 'bg-blue-600 hover:bg-blue-700' : ''}`}
                    size="lg"
                  >
                    {tier.name === 'Developer' ? 'Get Started Free' : 'Contact Sales'}
                  </Button>
                  
                  <div>
                    <h4 className="font-semibold text-gray-900 mb-3">Features included:</h4>
                    <ul className="space-y-2">
                      {tier.features.map((feature, featureIndex) => (
                        <li key={featureIndex} className="flex items-start">
                          <CheckCircle className="w-4 h-4 text-green-500 mr-3 mt-0.5 flex-shrink-0" />
                          <span className="text-sm text-gray-600">{feature}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                  
                  {tier.limitations && (
                    <div>
                      <h4 className="font-semibold text-gray-900 mb-3">Limitations:</h4>
                      <ul className="space-y-2">
                        {tier.limitations.map((limitation, limitationIndex) => (
                          <li key={limitationIndex} className="flex items-start">
                            <div className="w-4 h-4 border border-gray-300 rounded mr-3 mt-0.5 flex-shrink-0"></div>
                            <span className="text-sm text-gray-500">{limitation}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  )}
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Technical Specifications */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Technical Specifications
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Built with modern technologies and best practices to ensure reliability, 
              performance, and developer experience.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {[
              {
                title: 'Response Time',
                value: '< 100ms',
                description: 'Average API response time globally',
                icon: Clock
              },
              {
                title: 'Uptime SLA',
                value: '99.9%',
                description: 'Guaranteed availability with redundancy',
                icon: Zap
              },
              {
                title: 'Security',
                value: 'SOC 2',
                description: 'Enterprise-grade security compliance',
                icon: Lock
              },
              {
                title: 'Support',
                value: '24/7',
                description: 'Around-the-clock technical support',
                icon: Headphones
              }
            ].map((spec, index) => {
              const IconComponent = spec.icon
              return (
                <div key={index} className="text-center bg-white p-6 rounded-lg shadow-sm">
                  <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-4">
                    <IconComponent className="w-6 h-6 text-blue-600" />
                  </div>
                  <div className="text-3xl font-bold text-gray-900 mb-2">{spec.value}</div>
                  <div className="font-semibold text-gray-900 mb-1">{spec.title}</div>
                  <div className="text-sm text-gray-600">{spec.description}</div>
                </div>
              )
            })}
          </div>
        </div>
      </section>

      {/* Integration Examples */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="max-w-4xl mx-auto">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Simple Integration
              </h2>
              <p className="text-gray-600">
                Get started in minutes with our intuitive API. Here's a quick example:
              </p>
            </div>
            
            <div className="bg-gray-900 rounded-lg p-6 text-green-400 font-mono text-sm overflow-x-auto">
              <div className="mb-4 text-gray-400">// Create a new appointment</div>
              <div className="mb-2">POST https://api.app-oint.com/v1/appointments</div>
              <div className="mb-2">Headers: {"{"}</div>
              <div className="ml-4 mb-2">"Authorization": "Bearer YOUR_API_KEY",</div>
              <div className="ml-4 mb-2">"Content-Type": "application/json"</div>
              <div className="mb-4">{"}"}</div>
              
              <div className="mb-2">Body: {"{"}</div>
              <div className="ml-4 mb-2">"customer_name": "John Doe",</div>
              <div className="ml-4 mb-2">"service_id": "haircut_123",</div>
              <div className="ml-4 mb-2">"start_time": "2024-02-15T10:00:00Z",</div>
              <div className="ml-4 mb-2">"duration": 60,</div>
              <div className="ml-4 mb-2">"location_id": "salon_main"</div>
              <div>{"}"}</div>
            </div>
            
            <div className="mt-8 text-center">
              <Button className="bg-blue-600 hover:bg-blue-700">
                View Full API Documentation
                <ArrowRight className="w-4 h-4 ml-2" />
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-gray-900">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-white mb-4">
            Ready to Build with App-Oint API?
          </h2>
          <p className="text-gray-300 mb-8 max-w-2xl mx-auto">
            Join hundreds of companies already building amazing scheduling experiences 
            with our enterprise API platform.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" className="bg-blue-600 hover:bg-blue-700">
              Start Free Developer Account
            </Button>
            <Button size="lg" variant="outline" className="border-white text-white hover:bg-white hover:text-gray-900">
              Schedule API Demo
            </Button>
          </div>
          <div className="mt-8 text-sm text-gray-400">
            Have questions? Contact our enterprise sales team at{' '}
            <a href="mailto:enterprise@app-oint.com" className="text-blue-400 hover:text-blue-300">
              enterprise@app-oint.com
            </a>
          </div>
        </div>
      </section>
    </div>
  )
}