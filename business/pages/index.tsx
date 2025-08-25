import { BarChart3, Calendar, Clock, Settings, Shield, Users } from 'lucide-react'
import Head from 'next/head'

export default function BusinessHome() {
  const features = [
    {
      icon: Calendar,
      title: "Smart Scheduling",
      description: "Intelligent appointment booking with conflict detection and optimization"
    },
    {
      icon: Users,
      title: "Staff Management",
      description: "Manage team schedules, roles, and availability in one place"
    },
    {
      icon: BarChart3,
      title: "Business Analytics",
      description: "Detailed insights into your business performance and customer behavior"
    },
    {
      icon: Settings,
      title: "Customization",
      description: "Customize the look and feel to match your business brand"
    },
    {
      icon: Clock,
      title: "24/7 Availability",
      description: "Let customers book appointments anytime, anywhere"
    },
    {
      icon: Shield,
      title: "Secure & Reliable",
      description: "Bank-level security with 99.9% uptime guarantee"
    }
  ]

  return (
    <>
      <Head>
        <title>Business Portal - App-Oint</title>
        <meta name="description" content="Business scheduling and management portal for App-Oint" />
      </Head>

      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-white">
        <main className="py-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            {/* Hero Section */}
            <div className="text-center mb-16">
              <h1 className="text-5xl font-bold text-gray-900 mb-6">
                Business Management Portal
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
                Streamline your business operations with our comprehensive scheduling and management suite.
                From appointments to analytics, we've got you covered.
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <button className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-semibold">
                  Get Started Free
                </button>
                <button className="border border-gray-300 text-gray-700 px-6 py-3 rounded-lg font-semibold hover:bg-gray-50">
                  View Demo
                </button>
              </div>
            </div>

            {/* Features Grid */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-gray-900 text-center mb-12">
                Everything Your Business Needs
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {features.map((feature, index) => (
                  <div key={index} className="text-center h-full hover:shadow-lg transition-shadow bg-white rounded-lg p-6 border">
                    <feature.icon className="h-12 w-12 text-blue-600 mx-auto mb-4" />
                    <h3 className="text-xl font-semibold mb-2">{feature.title}</h3>
                    <p className="text-gray-600">{feature.description}</p>
                  </div>
                ))}
              </div>
            </div>

            {/* CTA Section */}
            <div className="text-center bg-blue-50 rounded-2xl p-12">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Ready to Transform Your Business?
              </h2>
              <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
                App-Oint provides a complete suite of tools to streamline your booking process and grow your business.
              </p>
              <button className="bg-blue-600 hover:bg-blue-700 text-white px-8 py-4 rounded-lg font-semibold text-lg">
                Start Your Free Trial
              </button>
              <p className="text-sm text-gray-500 mt-4">
                No credit card required • 14-day free trial • Cancel anytime
              </p>
            </div>
          </div>
        </main>
      </div>
    </>
  )
}
