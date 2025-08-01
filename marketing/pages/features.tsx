import { Navbar } from '../src/components/Navbar'
import { Button } from '../src/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../src/components/ui/card'
import { useI18n } from '../src/lib/i18n'
import { BarChart3, Calendar, CreditCard, MessageSquare, Palette, Users } from 'lucide-react'
import Head from 'next/head'

export default function FeaturesPage() {
  const { t } = useI18n()

  const features = [
    {
      icon: Calendar,
      title: "Smart Calendar Integration",
      description: "Seamlessly sync with Google Calendar, Outlook, and other popular calendar platforms."
    },
    {
      icon: Users,
      title: "Customer Management",
      description: "Complete customer profiles with history, preferences, and notes."
    },
    {
      icon: BarChart3,
      title: "Business Analytics",
      description: "Detailed insights into your business performance and customer behavior."
    },
    {
      icon: Palette,
      title: "Custom Branding",
      description: "Customize the look and feel to match your business brand."
    },
    {
      icon: MessageSquare,
      title: "Communication Hub",
      description: "Built-in messaging system for customer communication."
    },
    {
      icon: CreditCard,
      title: "Payment Integration",
      description: "Accept payments directly through the booking platform."
    }
  ]

  return (
    <>
      <Head>
        <title>Features - App-Oint</title>
        <meta name="description" content="Discover all the powerful features of App-Oint scheduling platform" />
      </Head>

      <div className="min-h-screen bg-gray-50">
        <Navbar />

        <main className="py-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h1 className="text-4xl font-bold text-gray-900 mb-4">
                Everything You Need to Manage Appointments
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                App-Oint provides a complete suite of tools to streamline your booking process and grow your business.
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {features.map((feature, index) => (
                <Card key={index} className="h-full">
                  <CardHeader>
                    <feature.icon className="h-12 w-12 text-blue-600 mb-4" />
                    <CardTitle className="text-xl">{feature.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <CardDescription className="text-gray-600">
                      {feature.description}
                    </CardDescription>
                  </CardContent>
                </Card>
              ))}
            </div>

            <div className="text-center mt-16">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Ready to Experience All These Features?
              </h2>
              <p className="text-xl text-gray-600 mb-8">
                Start your free trial today and discover how App-Oint can transform your business.
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