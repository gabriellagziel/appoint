import Head from 'next/head'
import { useRouter } from 'next/router'
import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Check } from 'lucide-react'
import { useTranslation } from '@/lib/i18n'

export default function PricingPage() {
  const router = useRouter()
  const { t } = useTranslation(router.locale)

  return (
    <>
      <Head>
        <title>Pricing - App-Oint</title>
        <meta name="description" content="Simple, transparent pricing for App-Oint scheduling platform" />
      </Head>
      
      <div className="min-h-screen bg-gray-50">
        <Navbar />
        
        <main className="py-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h1 className="text-4xl font-bold text-gray-900 mb-4">
                Simple, Transparent Pricing
              </h1>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto">
                Choose the perfect plan for your business. All plans include our core scheduling features.
              </p>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
              {/* Starter Plan */}
              <Card className="relative">
                <CardHeader>
                  <CardTitle className="text-2xl">Starter</CardTitle>
                  <CardDescription>Perfect for small businesses</CardDescription>
                  <div className="text-3xl font-bold">€5<span className="text-lg font-normal">/month</span></div>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-3">
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      100 appointments/month
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Basic calendar sync
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Email notifications
                    </li>
                  </ul>
                  <Button className="w-full mt-6">{t('buttons.getStarted')}</Button>
                </CardContent>
              </Card>
              
              {/* Professional Plan */}
              <Card className="relative border-blue-500 shadow-lg">
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm">Most Popular</span>
                </div>
                <CardHeader>
                  <CardTitle className="text-2xl">Professional</CardTitle>
                  <CardDescription>Advanced features for growing businesses</CardDescription>
                  <div className="text-3xl font-bold">€15<span className="text-lg font-normal">/month</span></div>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-3">
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      500 appointments/month
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Advanced calendar sync
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      SMS & Email notifications
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Custom branding
                    </li>
                  </ul>
                  <Button className="w-full mt-6">{t('buttons.getStarted')}</Button>
                </CardContent>
              </Card>
              
              {/* Business Plus Plan */}
              <Card className="relative">
                <CardHeader>
                  <CardTitle className="text-2xl">Business Plus</CardTitle>
                  <CardDescription>Enterprise-grade solution</CardDescription>
                  <div className="text-3xl font-bold">€25<span className="text-lg font-normal">/month</span></div>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-3">
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Unlimited appointments
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Full API access
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Priority support
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Advanced analytics
                    </li>
                  </ul>
                  <Button className="w-full mt-6">{t('buttons.getStarted')}</Button>
                </CardContent>
              </Card>
            </div>
          </div>
        </main>
      </div>
    </>
  )
}