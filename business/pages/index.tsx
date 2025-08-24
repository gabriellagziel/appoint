import Head from 'next/head'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Calendar, Users, BarChart3, Settings, Clock, Shield } from 'lucide-react'

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
                <Button size="lg" className="bg-blue-600 hover:bg-blue-700">
                  Get Started Free
                </Button>
                <Button variant="outline" size="lg">
                  View Demo
                </Button>
              </div>
            </div>

            {/* Features Grid */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-gray-900 text-center mb-12">
                Everything Your Business Needs
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {features.map((feature, index) => (
                  <Card key={index} className="text-center h-full hover:shadow-lg transition-shadow">
                    <CardHeader>
                      <feature.icon className="h-12 w-12 text-blue-600 mx-auto mb-4" />
                      <CardTitle className="text-xl">{feature.title}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <CardDescription>{feature.description}</CardDescription>
                    </CardContent>
                  </Card>
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
              <Button size="lg" className="bg-blue-600 hover:bg-blue-700">
                Start Your Free Trial
              </Button>
              <p className="text-sm text-gray-500 mt-4">
                No credit card required • 14-day free trial • Cancel anytime
              </p>
            </div>

            {/* Navigation to App */}
            <div className="text-center mt-16">
              <p className="text-gray-600 mb-4">
                Already have an account?
              </p>
              <Button variant="outline" size="lg" asChild>
                <a href="/app">Go to Business App</a>
              </Button>
            </div>
          </div>
        </main>
      </div>
    </>
  )
}
