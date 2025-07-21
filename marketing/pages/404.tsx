import { GetStaticProps } from 'next'
import { useTranslation } from 'next-i18next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'
import Head from 'next/head'
import Link from 'next/link'
import { Navbar } from '@/components/Navbar'
import { Button } from '@/components/ui/button'
import { Home, Mail } from 'lucide-react'

export default function Custom404() {
  const { t } = useTranslation('errors')

  return (
    <>
      <Head>
        <title>{t('404.title')} - App-Oint</title>
        <meta name="description" content={t('404.description')} />
        <meta name="robots" content="noindex, nofollow" />
      </Head>
      
      <div className="min-h-screen bg-gray-50">
        <Navbar />
        
        <div className="flex items-center justify-center min-h-[calc(100vh-4rem)]">
          <div className="max-w-md mx-auto text-center px-4">
            <div className="mb-8">
              <div className="text-6xl font-bold text-blue-600 mb-4">404</div>
              <h1 className="text-3xl font-bold text-gray-900 mb-4">
                {t('404.title')}
              </h1>
              <p className="text-xl text-gray-600 mb-2">
                {t('404.subtitle')}
              </p>
              <p className="text-gray-500">
                {t('404.description')}
              </p>
            </div>
            
            <div className="space-y-4">
              <div className="flex flex-col sm:flex-row gap-3 justify-center">
                <Button asChild size="lg">
                  <Link href="/">
                    <Home className="w-4 h-4 mr-2" />
                    {t('404.goHome')}
                  </Link>
                </Button>
                <Button asChild variant="outline" size="lg">
                  <Link href="/contact">
                    <Mail className="w-4 h-4 mr-2" />
                    {t('404.contactSupport')}
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

export const getStaticProps: GetStaticProps = async ({ locale }) => {
  return {
    props: {
      ...(await serverSideTranslations(locale ?? 'en', ['common', 'errors'])),
    },
  }
}