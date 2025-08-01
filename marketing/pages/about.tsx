import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useI18n } from '@/lib/i18n'
import { Eye, Heart, Target, Users } from 'lucide-react'
import Head from 'next/head'

export default function AboutPage() {
  const { t } = useI18n()

  const stats = [
    { label: "Active Businesses", value: "5,000+" },
    { label: "Appointments Scheduled", value: "1M+" },
    { label: "Supported Languages", value: "56" },
    { label: "Platform Uptime", value: "99.9%" }
  ]

  const values = [
    {
      icon: Target,
      name: "Innovation",
      description: "Continuously pushing the boundaries of scheduling technology"
    },
    {
      icon: Eye,
      name: "Simplicity",
      description: "Making complex scheduling problems simple and intuitive"
    },
    {
      icon: Heart,
      name: "Reliability",
      description: "Building robust systems that businesses can depend on"
    },
    {
      icon: Users,
      name: "Customer Focus",
      description: "Putting our customers success at the center of everything we do"
    }
  ]

  return (
    <>
      <Head>
        <title>About - App-Oint</title>
        <meta name="description" content="Learn about App-Oint mission to revolutionize appointment scheduling" />
      </Head>

      <div className="min-h-screen bg-gray-50">
        <Navbar />

        <main className="py-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h1 className="text-4xl font-bold text-gray-900 mb-4">
                Revolutionizing Appointment Scheduling
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                At App-Oint, we believe that scheduling should not be complicated. We are building the future of appointment management with innovative technology and elegant design.
              </p>
            </div>

            {/* Stats Section */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-16">
              {stats.map((stat, index) => (
                <div key={index} className="text-center">
                  <div className="text-3xl font-bold text-blue-600 mb-2">{stat.value}</div>
                  <div className="text-gray-600">{stat.label}</div>
                </div>
              ))}
            </div>

            {/* Mission & Vision */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-12 mb-16">
              <Card>
                <CardHeader>
                  <CardTitle className="text-2xl text-center">Our Mission</CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600 text-center">
                    To empower businesses of all sizes with intelligent scheduling solutions that save time, increase efficiency, and improve customer experiences.
                  </p>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="text-2xl text-center">Our Vision</CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600 text-center">
                    A world where every business can focus on what they do best, while intelligent systems handle the complexity of scheduling and coordination.
                  </p>
                </CardContent>
              </Card>
            </div>

            {/* Core Values */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-gray-900 text-center mb-12">Our Core Values</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                {values.map((value, index) => (
                  <Card key={index} className="text-center h-full">
                    <CardHeader>
                      <value.icon className="h-12 w-12 text-blue-600 mx-auto mb-4" />
                      <CardTitle className="text-xl">{value.name}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <CardDescription>{value.description}</CardDescription>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            <div className="text-center">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Ready to Join Our Mission?
              </h2>
              <p className="text-xl text-gray-600 mb-8">
                Whether you are a business looking for better scheduling solutions or a developer interested in our API, we would love to have you on this journey.
              </p>
              <Button size="lg" className="mr-4">{t('buttons.getStarted')}</Button>
              <Button variant="outline" size="lg">{t('buttons.contactUs')}</Button>
            </div>
          </div>
        </main>
      </div>
    </>
  )
}