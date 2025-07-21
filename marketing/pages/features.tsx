import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { 
  Calendar, 
  Users, 
  BarChart3, 
  Palette, 
  MessageSquare, 
  CreditCard,
  MapPin, 
  Clock, 
  Shield, 
  Smartphone, 
  Zap, 
  Settings,
  Bell,
  FileText,
  Globe,
  Database,
  Headphones,
  Check
} from 'lucide-react'

const features = [
  {
    category: 'Booking & Scheduling',
    icon: Calendar,
    color: 'blue',
    items: [
      {
        name: 'Smart Calendar Integration',
        description: 'Seamlessly sync with Google Calendar, Outlook, and other popular calendar platforms.',
        icon: Calendar
      },
      {
        name: 'Real-time Availability',
        description: 'Automatic availability updates across all platforms in real-time.',
        icon: Clock
      },
      {
        name: 'Multi-timezone Support',
        description: 'Handle appointments across different timezones automatically.',
        icon: Globe
      },
      {
        name: 'Recurring Appointments',
        description: 'Set up weekly, monthly, or custom recurring appointment patterns.',
        icon: Calendar
      }
    ]
  },
  {
    category: 'Customer Management',
    icon: Users,
    color: 'green',
    items: [
      {
        name: 'Customer Database',
        description: 'Complete customer profiles with history, preferences, and notes.',
        icon: Database
      },
      {
        name: 'Smart Notifications',
        description: 'Automated SMS and email reminders with customizable timing.',
        icon: Bell
      },
      {
        name: 'Communication Hub',
        description: 'Built-in messaging system for customer communication.',
        icon: MessageSquare
      },
      {
        name: 'Customer Portal',
        description: 'Self-service portal for customers to manage their appointments.',
        icon: Users
      }
    ]
  },
  {
    category: 'Business Intelligence',
    icon: BarChart3,
    color: 'purple',
    items: [
      {
        name: 'Advanced Analytics',
        description: 'Detailed insights into booking patterns, revenue, and customer behavior.',
        icon: BarChart3
      },
      {
        name: 'Revenue Tracking',
        description: 'Monitor income, track payments, and generate financial reports.',
        icon: CreditCard
      },
      {
        name: 'Performance Metrics',
        description: 'Track key business metrics and identify growth opportunities.',
        icon: Zap
      },
      {
        name: 'Custom Reports',
        description: 'Generate custom reports for specific time periods and metrics.',
        icon: FileText
      }
    ]
  },
  {
    category: 'Branding & Customization',
    icon: Palette,
    color: 'pink',
    items: [
      {
        name: 'Custom Branding',
        description: 'Add your logo, colors, and branding to all customer-facing pages.',
        icon: Palette
      },
      {
        name: 'White-label Solution',
        description: 'Complete white-label options for agencies and resellers.',
        icon: Settings
      },
      {
        name: 'Custom Booking Forms',
        description: 'Create tailored intake forms for different services.',
        icon: FileText
      },
      {
        name: 'Mobile Responsive',
        description: 'Perfect experience on all devices - desktop, tablet, and mobile.',
        icon: Smartphone
      }
    ]
  },
  {
    category: 'Location & Mapping',
    icon: MapPin,
    color: 'orange',
    items: [
      {
        name: 'Interactive Maps',
        description: 'Embedded maps with directions and location information.',
        icon: MapPin
      },
      {
        name: 'Multi-location Support',
        description: 'Manage appointments across multiple business locations.',
        icon: MapPin
      },
      {
        name: 'Geolocation Services',
        description: 'Automatic location detection and distance calculations.',
        icon: Globe
      },
      {
        name: 'Location-based Routing',
        description: 'Optimize staff schedules based on location proximity.',
        icon: MapPin
      }
    ]
  },
  {
    category: 'Security & Support',
    icon: Shield,
    color: 'red',
    items: [
      {
        name: 'Enterprise Security',
        description: 'Bank-level encryption and GDPR-compliant data handling.',
        icon: Shield
      },
      {
        name: '24/7 Support',
        description: 'Round-the-clock customer support via chat, email, and phone.',
        icon: Headphones
      },
      {
        name: 'API Access',
        description: 'Full REST API for custom integrations and third-party apps.',
        icon: Settings
      },
      {
        name: 'Data Backup',
        description: 'Automatic daily backups with instant recovery options.',
        icon: Database
      }
    ]
  }
]

const benefits = [
  {
    title: 'Save Time',
    description: 'Reduce administrative work by up to 80% with automated scheduling',
    icon: Clock
  },
  {
    title: 'Increase Revenue',
    description: 'Book 40% more appointments with optimized availability',
    icon: CreditCard
  },
  {
    title: 'Improve Customer Experience',
    description: '24/7 online booking with instant confirmations',
    icon: Users
  },
  {
    title: 'Scale Your Business',
    description: 'Handle unlimited appointments across multiple locations',
    icon: Zap
  }
]

export default function FeaturesPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      
      {/* Hero Section */}
      <section className="py-16 sm:py-24 bg-gradient-to-br from-blue-50 to-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-light text-gray-900 mb-6">
              Everything You Need to
              <span className="block text-blue-600">Manage Appointments</span>
            </h1>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
              App-Oint provides a complete suite of tools to streamline your booking process, 
              manage customers, and grow your business. Discover how our features work together 
              to create the perfect scheduling solution.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button size="lg" className="bg-blue-600 hover:bg-blue-700">
                Start Free Trial
              </Button>
              <Button size="lg" variant="outline">
                View Live Demo
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Benefits Overview */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Why Businesses Choose App-Oint
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Our platform delivers measurable results that transform how you run your business.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {benefits.map((benefit, index) => {
              const IconComponent = benefit.icon
              return (
                <div key={index} className="text-center">
                  <div className="mx-auto mb-4 w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center">
                    <IconComponent className="w-8 h-8 text-blue-600" />
                  </div>
                  <h3 className="text-xl font-semibold text-gray-900 mb-2">
                    {benefit.title}
                  </h3>
                  <p className="text-gray-600">
                    {benefit.description}
                  </p>
                </div>
              )
            })}
          </div>
        </div>
      </section>

      {/* Features by Category */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Complete Feature Set
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Explore our comprehensive feature categories designed to cover every aspect 
              of appointment management and business growth.
            </p>
          </div>

          <div className="space-y-16">
            {features.map((category, categoryIndex) => {
              const CategoryIcon = category.icon
              return (
                <div key={categoryIndex}>
                  <div className="text-center mb-12">
                    <div className={`mx-auto mb-4 w-16 h-16 bg-${category.color}-100 rounded-full flex items-center justify-center`}>
                      <CategoryIcon className={`w-8 h-8 text-${category.color}-600`} />
                    </div>
                    <h3 className="text-2xl font-bold text-gray-900">
                      {category.category}
                    </h3>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    {category.items.map((feature, featureIndex) => {
                      const FeatureIcon = feature.icon
                      return (
                        <Card key={featureIndex} className="hover:shadow-lg transition-all duration-300 border-gray-200 bg-white">
                          <CardHeader className="pb-4">
                            <div className={`mb-3 w-12 h-12 bg-${category.color}-100 rounded-lg flex items-center justify-center`}>
                              <FeatureIcon className={`w-6 h-6 text-${category.color}-600`} />
                            </div>
                            <CardTitle className="text-lg font-semibold text-gray-900">
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
              )
            })}
          </div>
        </div>
      </section>

      {/* Integration Section */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Seamless Integrations
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto mb-8">
              Connect App-Oint with your existing tools and workflows. Our platform integrates 
              with popular services to ensure a smooth transition.
            </p>
          </div>
          
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-8 items-center justify-items-center">
            {[
              'Google Calendar',
              'Outlook',
              'Stripe',
              'PayPal',
              'Zoom',
              'Slack',
              'WhatsApp',
              'SMS Gateway',
              'Zapier',
              'WordPress',
              'Shopify',
              'QuickBooks'
            ].map((integration, index) => (
              <div key={index} className="p-4 bg-gray-50 rounded-lg border border-gray-200 w-full text-center hover:shadow-md transition-all duration-300">
                <p className="text-sm font-medium text-gray-700">{integration}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonial Section */}
      <section className="py-16 bg-blue-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Trusted by Growing Businesses
            </h2>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                quote: "App-Oint transformed our booking process. We've seen a 60% increase in appointments since switching.",
                author: "Sarah Johnson",
                role: "Spa Owner",
                company: "Serenity Wellness"
              },
              {
                quote: "The analytics features help us understand our customers better and optimize our schedules.",
                author: "Mark Chen",
                role: "Clinic Manager",
                company: "Downtown Medical"
              },
              {
                quote: "Customer support is amazing. Any question we have is answered within minutes.",
                author: "Lisa Rodriguez",
                role: "Salon Owner",
                company: "Beauty Plus"
              }
            ].map((testimonial, index) => (
              <Card key={index} className="bg-white">
                <CardContent className="p-6">
                  <p className="text-gray-600 mb-4 italic">
                    "{testimonial.quote}"
                  </p>
                  <div>
                    <p className="font-semibold text-gray-900">{testimonial.author}</p>
                    <p className="text-sm text-gray-500">{testimonial.role}, {testimonial.company}</p>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-gray-900">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-white mb-4">
            Ready to Experience All These Features?
          </h2>
          <p className="text-gray-300 mb-8 max-w-2xl mx-auto">
            Start your free trial today and discover how App-Oint can transform your business 
            with our complete feature set.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" className="bg-blue-600 hover:bg-blue-700">
              Start Free Trial
            </Button>
            <Button size="lg" variant="outline" className="border-white text-white hover:bg-white hover:text-gray-900">
              Schedule a Demo
            </Button>
          </div>
          <div className="mt-8 flex items-center justify-center space-x-6 text-sm text-gray-400">
            <span className="flex items-center">
              <Check className="w-4 h-4 text-green-400 mr-2" />
              30-day free trial
            </span>
            <span className="flex items-center">
              <Check className="w-4 h-4 text-green-400 mr-2" />
              No credit card required
            </span>
            <span className="flex items-center">
              <Check className="w-4 h-4 text-green-400 mr-2" />
              Setup support included
            </span>
          </div>
        </div>
      </section>
    </div>
  )
}