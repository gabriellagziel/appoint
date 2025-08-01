import Head from 'next/head'
import Link from 'next/link'
import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Home, Mail } from 'lucide-react'
import { useI18n } from '@/lib/i18n'

export default function Custom404() {
  const { t } = useI18n()

  return (
    <>
      <Head>
        <title>{t('errors.404.title')} - App-Oint</title>
        <meta name="description" content={t('errors.404.description')} />
        <meta name="robots" content="noindex, nofollow" />
      </Head>

      <div className="min-h-screen bg-gray-50">
        <Navbar />

        <div className="flex items-center justify-center min-h-[calc(100vh-4rem)]">
          <div className="max-w-md mx-auto text-center px-4">
            <div className="mb-8">
              <div className="text-6xl font-bold text-blue-600 mb-4">404</div>
              <h1 className="text-3xl font-bold text-gray-900 mb-4">
                {t('errors.404.title')}
              </h1>
              <p className="text-xl text-gray-600 mb-2">
                {t('errors.404.subtitle')}
              </p>
              <p className="text-gray-500">
                {t('errors.404.description')}
              </p>
            </div>

            <div className="space-y-4">
              <div className="flex flex-col sm:flex-row gap-3 justify-center">
                <Button asChild size="lg">
                  <Link href="/">
                    <Home className="w-4 h-4 mr-2" />
                    {t('errors.404.goHome')}
                  </Link>
                </Button>
                <Button asChild variant="outline" size="lg">
                  <Link href="/contact">
                    <Mail className="w-4 h-4 mr-2" />
                    {t('errors.404.contactSupport')}
                  </Link>
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}

