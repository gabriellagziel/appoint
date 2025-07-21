// Simple i18n implementation for built-in Next.js i18n
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const translations: Record<string, Record<string, any>> = {
  en: {
    'brand.name': "App-Oint",
    'brand.tagline': "Time Organized",
    'brand.subtitle': "Set • Send • Done",
    'navigation.home': "Home",
    'navigation.features': "Features", 
    'navigation.pricing': "Pricing",
    'navigation.enterprise': "Enterprise",
    'navigation.about': "About",
    'navigation.contact': "Contact",
    'buttons.getStarted': "Get Started",
    'buttons.learnMore': "Learn More",
    'buttons.contactUs': "Contact Us",
    'seo.defaultTitle': "App-Oint - Smart Appointment Scheduling Platform",
    'seo.defaultDescription': "Streamline your business with App-Oint's intelligent scheduling platform. Support for 56 languages, enterprise API, and advanced analytics.",
    'language.switchLanguage': "Switch Language",
    'language.moreLanguages': "More languages coming soon...",
    'errors.404.title': "Page Not Found",
    'errors.404.subtitle': "The page you're looking for doesn't exist.",
    'errors.404.description': "It looks like the page you were trying to reach doesn't exist.",
    'errors.404.goHome': "Go Home",
    'errors.404.contactSupport': "Contact Support",
    'errors.500.title': "Server Error", 
    'errors.500.subtitle': "Something went wrong on our end.",
    'errors.500.description': "We're experiencing technical difficulties.",
    'errors.500.tryAgain': "Try Again",
    'errors.500.reportIssue': "Report Issue"
  },
  // Other languages would fallback to English for now
  es: {
    'brand.name': "App-Oint",
    'brand.tagline': "Tiempo Organizado", 
    'brand.subtitle': "Programar • Enviar • Hecho",
    'navigation.home': "Inicio",
    'navigation.features': "Características",
    'navigation.pricing': "Precios", 
    'navigation.enterprise': "Empresa",
    'navigation.about': "Acerca de",
    'navigation.contact': "Contacto",
    'buttons.getStarted': "Comenzar",
    'buttons.learnMore': "Saber más",
    'buttons.contactUs': "Contactanos"
  }
}

export function useTranslation(locale: string = 'en') {
  const t = (key: string): string => {
    const localeTranslations = translations[locale] || translations.en
    return localeTranslations[key] || translations.en[key] || key
  }
  
  return { t }
}