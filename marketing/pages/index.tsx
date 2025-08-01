import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useI18n } from '@/lib/i18n'
import { ArrowRight, Briefcase, Server, Shield } from 'lucide-react'
import Head from 'next/head'
import Image from 'next/image'
import { useRouter } from 'next/router'

export default function Home() {
  const router = useRouter()
  const { t } = useI18n()

  return (
    <>
      <Head>
        <title>{t('seo.defaultTitle')}</title>
        <meta name="description" content={t('seo.defaultDescription')} />
        <meta property="og:title" content={t('seo.defaultTitle')} />
        <meta property="og:description" content={t('seo.defaultDescription')} />
        <meta property="og:type" content="website" />
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={t('seo.defaultTitle')} />
        <meta name="twitter:description" content={t('seo.defaultDescription')} />
      </Head>

      <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-blue-50">
        <Navbar />
        <main className="relative">
          {/* Hero Section */}
          <section className="relative py-20 lg:py-32 overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-50/50 to-transparent"></div>
            <div className="relative container mx-auto px-4 sm:px-6 lg:px-8">
              <div className="flex min-h-[80vh] flex-col items-center justify-center text-center">
                {/* Logo */}
                <div className="mb-8 animate-fade-in">
                  <Image
                    src="/logo.svg"
                    alt="App-Oint Logo"
                    width={120}
                    height={120}
                    className="mx-auto drop-shadow-lg"
                  />
                </div>

                {/* Slogan */}
                <div className="mb-12 animate-fade-in-up">
                  <h1 className="text-5xl lg:text-6xl font-light text-gray-900 mb-6 tracking-tight leading-tight">
                    {t('brand.tagline')}
                  </h1>
                  <div className="text-xl lg:text-2xl text-gray-600 font-light space-x-4">
                    {t('brand.subtitle')}
                  </div>
                </div>

                {/* Intro Text */}
                <p className="text-lg lg:text-xl text-gray-700 max-w-3xl mx-auto mb-16 leading-relaxed animate-fade-in-up">
                  App-Oint is a smart scheduling system for individuals, businesses, and enterprise clients.
                  Choose your portal to get started.
                </p>

                {/* Navigation Cards */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-7xl w-full animate-fade-in-up">
                  {/* Business Portal Card */}
                  <Card className="group hover:shadow-xl hover:shadow-blue-200/50 transition-all duration-300 hover:scale-[1.02] cursor-pointer border-gray-200/50 bg-white/90 backdrop-blur-sm hover:bg-white">
                    <CardHeader className="text-center pb-4">
                      <div className="mx-auto mb-4 w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                        <Briefcase className="w-8 h-8 text-blue-600" />
                      </div>
                      <CardTitle className="text-xl font-semibold text-gray-900">
                        Business Portal
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="text-center">
                      <CardDescription className="text-gray-600 mb-6 leading-relaxed">
                        Manage appointments, staff, rooms, and analytics with our comprehensive business management suite.
                      </CardDescription>
                      <Button
                        asChild
                        className="w-full bg-blue-600 hover:bg-blue-700 text-white shadow-lg hover:shadow-xl transition-all duration-200 group-hover:shadow-blue-200/50"
                      >
                        <a href="https://business.app-oint.com" target="_blank" rel="noopener noreferrer" className="flex items-center justify-center gap-2">
                          Enter Business Portal
                          <ArrowRight className="w-4 h-4" />
                        </a>
                      </Button>
                    </CardContent>
                  </Card>

                  {/* Enterprise API Card */}
                  <Card className="group hover:shadow-xl hover:shadow-green-200/50 transition-all duration-300 hover:scale-[1.02] cursor-pointer border-gray-200/50 bg-white/90 backdrop-blur-sm hover:bg-white">
                    <CardHeader className="text-center pb-4">
                      <div className="mx-auto mb-4 w-16 h-16 bg-green-100 rounded-full flex items-center justify-center group-hover:bg-green-200 transition-colors">
                        <Server className="w-8 h-8 text-green-600" />
                      </div>
                      <CardTitle className="text-xl font-semibold text-gray-900">
                        Enterprise API
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="text-center">
                      <CardDescription className="text-gray-600 mb-6 leading-relaxed">
                        Integrate scheduling & geolocation via our REST API for seamless enterprise solutions.
                      </CardDescription>
                      <Button
                        asChild
                        className="w-full bg-green-600 hover:bg-green-700 text-white shadow-lg hover:shadow-xl transition-all duration-200 group-hover:shadow-green-200/50"
                      >
                        <a href="https://enterprise.app-oint.com" target="_blank" rel="noopener noreferrer" className="flex items-center justify-center gap-2">
                          Explore API Access
                          <ArrowRight className="w-4 h-4" />
                        </a>
                      </Button>
                    </CardContent>
                  </Card>

                  {/* Admin Panel Card */}
                  <Card className="group hover:shadow-xl hover:shadow-purple-200/50 transition-all duration-300 hover:scale-[1.02] cursor-pointer border-gray-200/50 bg-white/90 backdrop-blur-sm hover:bg-white">
                    <CardHeader className="text-center pb-4">
                      <div className="mx-auto mb-4 w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center group-hover:bg-purple-200 transition-colors">
                        <Shield className="w-8 h-8 text-purple-600" />
                      </div>
                      <CardTitle className="text-xl font-semibold text-gray-900">
                        Admin Panel
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="text-center">
                      <CardDescription className="text-gray-600 mb-6 leading-relaxed">
                        Internal system dashboard for App-Oint administrators with full system oversight.
                      </CardDescription>
                      <Button
                        asChild
                        className="w-full bg-purple-600 hover:bg-purple-700 text-white shadow-lg hover:shadow-xl transition-all duration-200 group-hover:shadow-purple-200/50"
                      >
                        <a href="https://admin.app-oint.com" target="_blank" rel="noopener noreferrer" className="flex items-center justify-center gap-2">
                          Go to Admin Panel
                          <ArrowRight className="w-4 h-4" />
                        </a>
                      </Button>
                    </CardContent>
                  </Card>
                </div>

                {/* Future Features Placeholder */}
                <div className="mt-20 text-center animate-fade-in-up">
                  <p className="text-sm text-gray-400">
                    More features coming soon • Multilingual support • Enhanced analytics
                  </p>
                </div>
              </div>
            </div>
          </section>
        </main>
      </div>
    </>
  )
}
