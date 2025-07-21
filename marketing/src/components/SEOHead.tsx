import Head from 'next/head'
import { useRouter } from 'next/router'

interface SEOProps {
  title?: string
  description?: string
  canonical?: string
  ogImage?: string
  ogType?: string
  noindex?: boolean
  structuredData?: object
}

export function SEOHead({
  title = 'App-Oint - Smart Appointment Scheduling Platform',
  description = 'Streamline your business with App-Oint\'s intelligent scheduling platform. Support for 56 languages, enterprise API, and advanced analytics.',
  canonical,
  ogImage = '/og-image.jpg',
  ogType = 'website',
  noindex = false,
  structuredData
}: SEOProps) {
  const router = useRouter()
  const { locale, asPath } = router
  
  const baseUrl = 'https://app-oint.com'
  const currentUrl = canonical || `${baseUrl}${locale === 'en' ? '' : `/${locale}`}${asPath}`
  
  const defaultStructuredData = {
    '@context': 'https://schema.org',
    '@type': 'SoftwareApplication',
    name: 'App-Oint',
    applicationCategory: 'BusinessApplication',
    description: description,
    url: baseUrl,
    operatingSystem: 'Web',
    offers: {
      '@type': 'Offer',
      price: '5',
      priceCurrency: 'EUR',
      priceValidUntil: '2025-12-31'
    },
    aggregateRating: {
      '@type': 'AggregateRating',
      ratingValue: '4.8',
      ratingCount: '1250'
    },
    featureList: [
      'Appointment Scheduling',
      'Calendar Integration', 
      'Multi-language Support',
      'Business Analytics',
      'Customer Management'
    ]
  }

  const jsonLd = structuredData || defaultStructuredData

  return (
    <Head>
      {/* Basic Meta Tags */}
      <title>{title}</title>
      <meta name="description" content={description} />
      {noindex && <meta name="robots" content="noindex, nofollow" />}
      <link rel="canonical" href={currentUrl} />
      
      {/* Open Graph */}
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:type" content={ogType} />
      <meta property="og:url" content={currentUrl} />
      <meta property="og:image" content={`${baseUrl}${ogImage}`} />
      <meta property="og:site_name" content="App-Oint" />
      <meta property="og:locale" content={locale} />
      
      {/* Twitter Card */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={`${baseUrl}${ogImage}`} />
      
      {/* Additional Meta Tags */}
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <meta name="theme-color" content="#2563eb" />
      <meta name="apple-mobile-web-app-capable" content="yes" />
      <meta name="REDACTED_TOKEN" content="default" />
      
      {/* Favicons */}
      <link rel="icon" href="/favicon.ico" />
      <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
      
      {/* Structured Data */}
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      
      {/* Language Alternates */}
      <link rel="alternate" hrefLang="x-default" href={`${baseUrl}${asPath}`} />
      <link rel="alternate" hrefLang="en" href={`${baseUrl}/en${asPath}`} />
      <link rel="alternate" hrefLang="es" href={`${baseUrl}/es${asPath}`} />
      <link rel="alternate" hrefLang="fr" href={`${baseUrl}/fr${asPath}`} />
      <link rel="alternate" hrefLang="de" href={`${baseUrl}/de${asPath}`} />
      
      {/* Preconnect for Performance */}
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
    </Head>
  )
}