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
                Choose the perfect plan for your needs. Personal app available on mobile, business plans for web dashboard.
              </p>
            </div>

            {/* Personal App Section */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-center text-gray-900 mb-8">Personal App (Mobile)</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
                <Card className="relative">
                  <CardHeader>
                    <CardTitle className="text-2xl">Free Trial</CardTitle>
                    <CardDescription>Perfect for personal use</CardDescription>
                    <div className="text-3xl font-bold">Free<span className="text-lg font-normal"> - 5 meetings</span></div>
                  </CardHeader>
                  <CardContent>
                    <ul className="space-y-3">
                      <li className="flex items-center">
                        <Check className="h-5 w-5 text-green-500 mr-3" />
                        5 free meetings with full features
                      </li>
                      <li className="flex items-center">
                        <Check className="h-5 w-5 text-green-500 mr-3" />
                        Map access included
                      </li>
                      <li className="flex items-center">
                        <Check className="h-5 w-5 text-green-500 mr-3" />
                        No ads
                      </li>
                    </ul>
                    <Button className="w-full mt-6">Download App</Button>
                  </CardContent>
                </Card>
                
                <Card className="relative border-blue-500 shadow-lg">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm">Recommended</span>
                  </div>
                  <CardHeader>
                    <CardTitle className="text-2xl">Premium</CardTitle>
                    <CardDescription>Unlimited personal meetings</CardDescription>
                    <div className="text-3xl font-bold">€4<span className="text-lg font-normal">/month</span></div>
                  </CardHeader>
                  <CardContent>
                    <ul className="space-y-3">
                      <li className="flex items-center">
                        <Check className="h-5 w-5 text-green-500 mr-3" />
                        Up to 20 meetings/week
                      </li>
                      <li className="flex items-center">
                        <Check className="h-5 w-5 text-green-500 mr-3" />
                        Full map access
                      </li>
                      <li className="flex items-center">
                        <Check className="h-5 w-5 text-green-500 mr-3" />
                        Ad-free experience
                      </li>
                      <li className="flex items-center">
                        <Check className="h-5 w-5 text-green-500 mr-3" />
                        Premium support
                      </li>
                    </ul>
                    <Button className="w-full mt-6">Upgrade in App</Button>
                  </CardContent>
                </Card>
              </div>
            </div>

            {/* Business Plans Section */}
            <div className="mb-16">
              <h2 className="text-3xl font-bold text-center text-gray-900 mb-8">Business Plans (Web Dashboard)</h2>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
              {/* Starter Plan */}
              <Card className="relative">
                <CardHeader>
                  <CardTitle className="text-2xl">Starter</CardTitle>
                  <CardDescription>Perfect for small businesses</CardDescription>
                  <div className="text-3xl font-bold">Free<span className="text-lg font-normal"></span></div>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-3">
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Unlimited appointments
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Basic calendar sync
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Email notifications
                    </li>
                    <li className="flex items-center text-gray-400">
                      <span className="h-5 w-5 mr-3">✗</span>
                      No map access
                    </li>
                    <li className="flex items-center text-gray-400">
                      <span className="h-5 w-5 mr-3">✗</span>
                      No branding
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
                      Unlimited appointments
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      200 map loads/month included
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
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Analytics & CRM features
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
                      Everything in Professional
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      500 map loads/month included
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Advanced analytics
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Priority support
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Excel export
                    </li>
                    <li className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3" />
                      Custom integrations
                    </li>
                  </ul>
                  <Button className="w-full mt-6">{t('buttons.getStarted')}</Button>
                </CardContent>
              </Card>
            </div>

            {/* Additional Information */}
            <div className="text-center bg-gray-50 rounded-lg p-8">
              <h3 className="text-2xl font-bold text-gray-900 mb-4">Important Notes</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-left max-w-4xl mx-auto">
                <div>
                  <h4 className="font-semibold text-gray-800 mb-2">Personal App (Mobile)</h4>
                  <ul className="text-gray-600 space-y-1">
                    <li>• After 5 free meetings: Ad-supported with no map access</li>
                    <li>• Premium subscription via App Store/Google Play</li>
                    <li>• Children always free, no map access unless upgraded</li>
                    <li>• Map access in business meetings charged to business</li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-semibold text-gray-800 mb-2">Business Plans (Web)</h4>
                  <ul className="text-gray-600 space-y-1">
                    <li>• All plans include unlimited meetings</li>
                    <li>• Map overage: €0.01 per extra load beyond limit</li>
                    <li>• Professional: 200 maps/month included</li>
                    <li>• Business Plus: 500 maps/month included</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </>
  )
}