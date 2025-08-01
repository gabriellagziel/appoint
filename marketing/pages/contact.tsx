import { Navbar } from '../src/components/Navbar'
import { Button } from '../src/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../src/components/ui/card'
import { useI18n } from '../src/lib/i18n'
import { Clock, Mail, MapPin, Phone } from 'lucide-react'
import Head from 'next/head'

export default function ContactPage() {
  const { t } = useI18n()

  const contactMethods = [
    {
      icon: Mail,
      title: "Email Support",
      details: "support@app-oint.com",
      description: "24-48 hour response time"
    },
    {
      icon: Phone,
      title: "Phone Support",
      details: "+1 (555) 123-4567",
      description: "Premium customers only"
    },
    {
      icon: MapPin,
      title: "Office Address",
      details: "123 Innovation Drive, Tech Hub, CA 94107",
      description: "United States"
    },
    {
      icon: Clock,
      title: "Support Hours",
      details: "Monday - Friday: 9:00 AM - 6:00 PM EST",
      description: "Emergency support available 24/7 for Enterprise customers"
    }
  ]

  const faqItems = [
    {
      question: "How quickly can I get started?",
      answer: "You can sign up and start using App-Oint immediately. Our onboarding process takes less than 5 minutes."
    },
    {
      question: "Do you offer phone support?",
      answer: "Yes! Premium and Enterprise customers get priority phone support. Starter plan users can access our chat support."
    },
    {
      question: "Can I migrate from another scheduling platform?",
      answer: "Absolutely. We offer free data migration assistance for all new customers switching from competitors."
    },
    {
      question: "Is my data secure?",
      answer: "Yes, we use enterprise-grade security with SSL encryption, regular backups, and GDPR compliance."
    }
  ]

  return (
    <>
      <Head>
        <title>Contact - App-Oint</title>
        <meta name="description" content="Get in touch with App-Oint support team for help and questions" />
      </Head>

      <div className="min-h-screen bg-gray-50">
        <Navbar />

        <main className="py-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h1 className="text-4xl font-bold text-gray-900 mb-4">
                Get in Touch
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                Have questions about App-Oint? Need technical support? Want to explore partnerships? We are here to help and would love to hear from you.
              </p>
            </div>

            {/* Contact Methods */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16">
              {contactMethods.map((method, index) => (
                <Card key={index} className="text-center h-full">
                  <CardHeader>
                    <method.icon className="h-12 w-12 text-blue-600 mx-auto mb-4" />
                    <CardTitle className="text-xl">{method.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="font-semibold text-gray-900 mb-2">{method.details}</p>
                    <CardDescription>{method.description}</CardDescription>
                  </CardContent>
                </Card>
              ))}
            </div>

            {/* Simple Contact Form */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 mb-16">
              <Card>
                <CardHeader>
                  <CardTitle className="text-2xl">Send us a Message</CardTitle>
                  <CardDescription>Fill out the form and we will get back to you within 24 hours.</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Full Name</label>
                      <input
                        type="text"
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="John Doe"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                      <input
                        type="email"
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="john@example.com"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Subject</label>
                      <input
                        type="text"
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="How can we help you?"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Message</label>
                      <textarea
                        rows={4}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Please provide details about your inquiry..."
                      />
                    </div>
                    <Button className="w-full">Send Message</Button>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="text-2xl">Visit Our Office</CardTitle>
                  <CardDescription>Located in the heart of San Francisco tech district.</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="bg-gray-100 h-48 rounded-lg flex items-center justify-center mb-6">
                    <p className="text-gray-500">Interactive Map Coming Soon</p>
                  </div>
                  <div className="space-y-4">
                    <div>
                      <h4 className="font-semibold text-gray-900">Public Transit</h4>
                      <p className="text-gray-600">2 blocks from Montgomery St. BART station</p>
                    </div>
                    <div>
                      <h4 className="font-semibold text-gray-900">Parking</h4>
                      <p className="text-gray-600">Validated parking available in building garage</p>
                    </div>
                    <div>
                      <h4 className="font-semibold text-gray-900">Accessibility</h4>
                      <p className="text-gray-600">Fully wheelchair accessible with elevator access</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* FAQ Section */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-gray-900 text-center mb-12">Frequently Asked Questions</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                {faqItems.map((item, index) => (
                  <Card key={index}>
                    <CardHeader>
                      <CardTitle className="text-lg">{item.question}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <p className="text-gray-600">{item.answer}</p>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            <div className="text-center">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Ready to Get Started?
              </h2>
              <p className="text-xl text-gray-600 mb-8">
                Do not wait to revolutionize your scheduling process. Start your free trial today.
              </p>
              <Button size="lg" className="mr-4">{t('buttons.getStarted')}</Button>
              <Button variant="outline" size="lg">{t('buttons.learnMore')}</Button>
            </div>
          </div>
        </main>
      </div>
    </>
  )
}