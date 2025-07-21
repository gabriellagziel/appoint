import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { 
  Target, 
  Eye, 
  Heart, 
  Users, 
  Globe, 
  Zap,
  Calendar,
  BarChart3,
  Shield,
  CheckCircle,
  ArrowRight,
  Building,
  Award,
  TrendingUp
} from 'lucide-react'

const values = [
  {
    name: 'Innovation',
    description: 'Continuously pushing the boundaries of scheduling technology',
    icon: Zap
  },
  {
    name: 'Simplicity',
    description: 'Making complex scheduling problems simple and intuitive',
    icon: Target
  },
  {
    name: 'Reliability',
    description: 'Building robust systems that businesses can depend on',
    icon: Shield
  },
  {
    name: 'Customer Focus',
    description: 'Putting our customers\' success at the center of everything we do',
    icon: Heart
  }
]

const milestones = [
  {
    year: '2023',
    title: 'Company Founded',
    description: 'App-Oint was founded with a vision to revolutionize appointment scheduling'
  },
  {
    year: '2024',
    title: 'Multi-language Platform',
    description: 'Launched comprehensive 56-language localization system'
  },
  {
    year: '2024',
    title: 'Enterprise API',
    description: 'Released enterprise-grade API for large-scale integrations'
  },
  {
    year: '2025',
    title: 'Global Expansion',
    description: 'Expanding to serve businesses in over 50 countries worldwide'
  }
]

const roadmapItems = [
  {
    quarter: 'Q1 2025',
    features: [
      'AI-powered scheduling optimization',
      'Advanced analytics dashboard',
      'Mobile app for iOS and Android'
    ],
    status: 'In Development'
  },
  {
    quarter: 'Q2 2025',
    features: [
      'Video conferencing integration',
      'Advanced CRM features',
      'White-label marketplace'
    ],
    status: 'Planned'
  },
  {
    quarter: 'Q3 2025',
    features: [
      'Voice booking assistant',
      'IoT device integrations',
      'Blockchain payment options'
    ],
    status: 'Research'
  },
  {
    quarter: 'Q4 2025',
    features: [
      'AR/VR booking experiences',
      'Global compliance framework',
      'Industry-specific solutions'
    ],
    status: 'Vision'
  }
]

const stats = [
  {
    number: '10K+',
    label: 'Active Businesses',
    icon: Building
  },
  {
    number: '1M+',
    label: 'Appointments Scheduled',
    icon: Calendar
  },
  {
    number: '56',
    label: 'Supported Languages',
    icon: Globe
  },
  {
    number: '99.9%',
    label: 'Platform Uptime',
    icon: Award
  }
]

export default function AboutPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      
      {/* Hero Section */}
      <section className="py-16 sm:py-24 bg-gradient-to-br from-blue-50 to-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-light text-gray-900 mb-6">
              Revolutionizing
              <span className="block text-blue-600">Appointment Scheduling</span>
            </h1>
            <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
              At App-Oint, we believe that scheduling shouldn't be complicated. 
              We're building the future of appointment management with innovative technology, 
              elegant design, and a commitment to making businesses more efficient.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button size="lg" className="bg-blue-600 hover:bg-blue-700">
                Join Our Mission
              </Button>
              <Button size="lg" variant="outline">
                View Our Story
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            {stats.map((stat, index) => {
              const IconComponent = stat.icon
              return (
                <div key={index} className="text-center">
                  <div className="mx-auto mb-4 w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center">
                    <IconComponent className="w-8 h-8 text-blue-600" />
                  </div>
                  <div className="text-3xl font-bold text-gray-900 mb-2">{stat.number}</div>
                  <div className="text-gray-600">{stat.label}</div>
                </div>
              )
            })}
          </div>
        </div>
      </section>

      {/* Mission & Vision */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <div className="mb-8">
                <div className="flex items-center mb-4">
                  <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
                    <Target className="w-6 h-6 text-blue-600" />
                  </div>
                  <h2 className="text-3xl font-bold text-gray-900">Our Mission</h2>
                </div>
                <p className="text-gray-600 text-lg leading-relaxed">
                  To empower businesses of all sizes with intelligent scheduling solutions that save time, 
                  increase efficiency, and improve customer experiences. We're democratizing access to 
                  enterprise-grade scheduling technology.
                </p>
              </div>
              
              <div>
                <div className="flex items-center mb-4">
                  <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mr-4">
                    <Eye className="w-6 h-6 text-green-600" />
                  </div>
                  <h2 className="text-3xl font-bold text-gray-900">Our Vision</h2>
                </div>
                <p className="text-gray-600 text-lg leading-relaxed">
                  A world where every business can focus on what they do best, while intelligent systems 
                  handle the complexity of scheduling, coordination, and customer management seamlessly 
                  in the background.
                </p>
              </div>
            </div>
            
            <div className="bg-white p-8 rounded-2xl shadow-lg">
              <img 
                src="/api/placeholder/500/400" 
                alt="Team collaboration" 
                className="w-full h-64 object-cover rounded-lg mb-6"
              />
              <h3 className="text-xl font-semibold text-gray-900 mb-4">
                Building the Future Together
              </h3>
              <p className="text-gray-600">
                Our diverse team of engineers, designers, and business experts work together 
                to create solutions that truly make a difference for businesses worldwide.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Company Values */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Our Core Values
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              These principles guide every decision we make and every feature we build.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {values.map((value, index) => {
              const IconComponent = value.icon
              return (
                <Card key={index} className="text-center hover:shadow-lg transition-all duration-300">
                  <CardHeader>
                    <div className="mx-auto mb-4 w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center">
                      <IconComponent className="w-8 h-8 text-blue-600" />
                    </div>
                    <CardTitle className="text-xl font-semibold text-gray-900">
                      {value.name}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <CardDescription className="text-gray-600">
                      {value.description}
                    </CardDescription>
                  </CardContent>
                </Card>
              )
            })}
          </div>
        </div>
      </section>

      {/* Company Timeline */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Our Journey
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              From a simple idea to a global platform serving thousands of businesses.
            </p>
          </div>
          
          <div className="max-w-4xl mx-auto">
            <div className="relative">
              <div className="absolute left-1/2 transform -translate-x-1/2 w-0.5 h-full bg-blue-200"></div>
              
              <div className="space-y-12">
                {milestones.map((milestone, index) => (
                  <div key={index} className={`flex items-center ${index % 2 === 0 ? 'flex-row' : 'flex-row-reverse'}`}>
                    <div className={`w-1/2 ${index % 2 === 0 ? 'pr-8 text-right' : 'pl-8 text-left'}`}>
                      <div className="bg-white p-6 rounded-lg shadow-md">
                        <div className="text-2xl font-bold text-blue-600 mb-2">{milestone.year}</div>
                        <h3 className="text-xl font-semibold text-gray-900 mb-2">{milestone.title}</h3>
                        <p className="text-gray-600">{milestone.description}</p>
                      </div>
                    </div>
                    
                    <div className="relative flex items-center justify-center w-12 h-12 bg-blue-600 rounded-full z-10">
                      <div className="w-4 h-4 bg-white rounded-full"></div>
                    </div>
                    
                    <div className="w-1/2"></div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Product Roadmap */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Product Roadmap
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Exciting features and innovations coming to App-Oint. 
              Your feedback helps shape our development priorities.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {roadmapItems.map((item, index) => (
              <Card key={index} className="hover:shadow-lg transition-all duration-300">
                <CardHeader>
                  <div className="flex items-center justify-between mb-4">
                    <CardTitle className="text-lg font-semibold text-gray-900">
                      {item.quarter}
                    </CardTitle>
                    <span className={`px-3 py-1 text-xs font-medium rounded-full ${
                      item.status === 'In Development' ? 'bg-green-100 text-green-700' :
                      item.status === 'Planned' ? 'bg-blue-100 text-blue-700' :
                      item.status === 'Research' ? 'bg-yellow-100 text-yellow-700' :
                      'bg-gray-100 text-gray-700'
                    }`}>
                      {item.status}
                    </span>
                  </div>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-2">
                    {item.features.map((feature, featureIndex) => (
                      <li key={featureIndex} className="flex items-start">
                        <CheckCircle className="w-4 h-4 text-blue-500 mr-2 mt-0.5 flex-shrink-0" />
                        <span className="text-sm text-gray-600">{feature}</span>
                      </li>
                    ))}
                  </ul>
                </CardContent>
              </Card>
            ))}
          </div>
          
          <div className="text-center mt-12">
            <p className="text-gray-600 mb-6">
              Have ideas for features you'd like to see? We'd love to hear from you!
            </p>
            <Button variant="outline">
              Submit Feature Request
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
          </div>
        </div>
      </section>

      {/* Brand Assets */}
      <section className="py-16 bg-gray-50">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Brand Assets
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Download our brand assets for partnerships, press coverage, or integration showcases.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            <Card className="text-center">
              <CardHeader>
                <div className="mx-auto mb-4 w-24 h-24 bg-blue-100 rounded-lg flex items-center justify-center">
                  <svg className="w-12 h-12 text-blue-600" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
                  </svg>
                </div>
                <CardTitle>Logo Package</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600 mb-4">
                  High-resolution logos in various formats (PNG, SVG, PDF)
                </p>
                <Button size="sm" variant="outline">Download</Button>
              </CardContent>
            </Card>
            
            <Card className="text-center">
              <CardHeader>
                <div className="mx-auto mb-4 w-24 h-24 bg-green-100 rounded-lg flex items-center justify-center">
                  <Zap className="w-12 h-12 text-green-600" />
                </div>
                <CardTitle>Brand Guidelines</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600 mb-4">
                  Complete brand guidelines including colors, typography, and usage rules
                </p>
                <Button size="sm" variant="outline">Download</Button>
              </CardContent>
            </Card>
            
            <Card className="text-center">
              <CardHeader>
                <div className="mx-auto mb-4 w-24 h-24 bg-purple-100 rounded-lg flex items-center justify-center">
                  <BarChart3 className="w-12 h-12 text-purple-600" />
                </div>
                <CardTitle>Marketing Kit</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600 mb-4">
                  Screenshots, product images, and marketing materials for partners
                </p>
                <Button size="sm" variant="outline">Download</Button>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Team Placeholder */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Meet Our Team
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Passionate professionals dedicated to transforming how businesses manage appointments.
            </p>
          </div>
          
          <div className="max-w-4xl mx-auto bg-gray-100 rounded-2xl p-12 text-center">
            <Users className="w-16 h-16 text-gray-400 mx-auto mb-6" />
            <h3 className="text-2xl font-semibold text-gray-700 mb-4">
              Team Photos Coming Soon
            </h3>
            <p className="text-gray-500 mb-6">
              We're putting together an amazing team page to introduce you to the people behind App-Oint. 
              Stay tuned for updates!
            </p>
            <Button variant="outline">
              Join Our Team
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-blue-600">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-white mb-4">
            Ready to Join Our Mission?
          </h2>
          <p className="text-blue-100 mb-8 max-w-2xl mx-auto">
            Whether you're a business looking for better scheduling solutions or a developer 
            interested in our API, we'd love to have you on this journey.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" className="bg-white text-blue-600 hover:bg-gray-100">
              Start Your Free Trial
            </Button>
            <Button size="lg" variant="outline" className="border-white text-white hover:bg-white hover:text-blue-600">
              Partner with Us
            </Button>
          </div>
        </div>
      </section>
    </div>
  )
}