import { appWithTranslation } from 'next-i18next'
import { useRouter } from 'next/router'
import { useEffect } from 'react'
import '../styles/globals.css'

function MyApp({ Component, pageProps }: any) {
  const router = useRouter()
  const isRTL = ['ar', 'he', 'fa', 'ur'].includes(router.locale || 'en')

  useEffect(() => {
    document.documentElement.dir = isRTL ? 'rtl' : 'ltr'
    document.documentElement.lang = router.locale || 'en'
  }, [router.locale, isRTL])

  return <Component {...pageProps} />
}

export default appWithTranslation(MyApp) 