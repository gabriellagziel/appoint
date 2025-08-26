import { Code, Database, Globe, Lock, Shield, Zap } from 'lucide-react'
import Head from 'next/head'
import { Button } from '../src/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../src/components/ui/card'

export default function EnterpriseHome() {
  const features = [
    {
      icon: Code,
      title: "RESTful API",
      description: "Complete REST API with comprehensive documentation for seamless integration."
    },
    {
      icon: Database,
      title: "Real-time Data",
      description: "Access real-time appointment data with webhooks and instant updates."
    },
    {
      icon: Shield,
      title: "Enterprise Security",
      description: "Bank-level security with OAuth 2.0, rate limiting, and data encryption."
    },
    {
      icon: Zap,
      title: "High Performance",
      description: "99.9% uptime SLA with global CDN and optimized response times."
    },
    {
      icon: Globe,
      title: "Global Scale",
      description: "Multi-region deployment with automatic failover and load balancing."
    },
    {
      icon: Lock,
      title: "Compliance Ready",
      description: "GDPR, SOC 2, and HIPAA compliant with enterprise-grade audit trails."
    }
  ]

  const pricingTiers = [
    {
      name: "Developer",
      price: "Free",
      description: "Perfect for testing and small applications",
      features: ["1,000 API calls/month", "Basic documentation", "Community support"]
    },
    {
      name: "Business API",
      price: "Custom",
      description: "Scalable solution for growing businesses",
      features: ["Custom rate limits", "Priority support", "SLA guarantee"]
    },
    {
      name: "Enterprise",
      price: "Contact Us",
      description: "Complete solution for large organizations",
      features: ["Unlimited API calls", "Dedicated support", "Custom features"]
    }
  ]

  return (
    <>
      <Head>
        <title>Enterprise API - App-Oint</title>
        <meta name="description" content="Enterprise API solutions for App-Oint scheduling platform" />
      </Head>

      <div className="min-h-screen bg-gradient-to-br from-green-50 to-white">
        <main className="py-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h1 className="text-5xl font-bold text-gray-900 mb-4">
                Enterprise API Solutions
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                Power your applications with App-Oint's robust scheduling API. Built for scale, security, and reliability.
              </p>
              <div className="mt-6 p-4 bg-green-50 rounded-lg max-w-2xl mx-auto">
                <p className="text-green-800 font-medium">
                  Note: Enterprise API is separate from our regular business subscription plans.
                </p>
              </div>
            </div>

            {/* Key Features */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-gray-900 text-center mb-12">Enterprise-Grade API Platform</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {features.map((feature, index) => (
                  <Card key={index} className="text-center h-full hover:shadow-lg transition-shadow">
                    <CardHeader>
                      <feature.icon className="h-12 w-12 text-green-600 mx-auto mb-4" />
                      <CardTitle className="text-xl">{feature.title}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <CardDescription>{feature.description}</CardDescription>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            {/* API Pricing */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-gray-900 text-center mb-4">API Pricing Plans</h2>
              <p className="text-xl text-gray-600 text-center mb-12 max-w-3xl mx-auto">
                Flexible pricing options designed to grow with your business. Enterprise solutions are completely separate from our standard business subscriptions.
              </p>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                {pricingTiers.map((tier, index) => (
                  <Card key={index} className="relative">
                    <CardHeader>
                      <CardTitle className="text-2xl">{tier.name}</CardTitle>
                      <CardDescription>{tier.description}</CardDescription>
                      <div className="text-3xl font-bold">{tier.price}</div>
                    </CardHeader>
                    <CardContent>
                      <ul className="space-y-3">
                        {tier.features.map((feature, idx) => (
                          <li key={idx} className="text-gray-600">• {feature}</li>
                        ))}
                      </ul>
                      <Button className="w-full mt-6">
                        {tier.price === "Free" ? "Get Started Free" : "Contact Sales"}
                      </Button>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            <div className="text-center">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Ready to Build with App-Oint API?
              </h2>
              <p className="text-xl text-gray-600 mb-8">
                Join hundreds of companies already building amazing scheduling experiences with our enterprise API platform.
              </p>
              <Button size="lg" className="mr-4">Get Started</Button>
              <Button variant="outline" size="lg">Contact Us</Button>
              <div className="mt-6">
                <p className="text-gray-500">
                  Have questions? Contact our enterprise sales team at enterprise@app-oint.com
                </p>
              </div>
            </div>
          </div>
        </main>
      </div>
    </>
  )
}
