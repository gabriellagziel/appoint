module.exports = {
  i18n: {
    defaultLocale: 'en',
    locales: [
      'am', 'ar', 'bg', 'bn', 'bn_BD', 'bs', 'ca', 'cs', 'cy', 'da', 'de', 'en', 
      'es', 'es_419', 'et', 'eu', 'fa', 'fi', 'fo', 'fr', 'ga', 'gl', 'ha', 'he', 
      'hi', 'hr', 'hu', 'id', 'is', 'it', 'ja', 'ko', 'lt', 'lv', 'mk', 'ms', 
      'mt', 'nl', 'no', 'pl', 'pt', 'pt_BR', 'ro', 'ru', 'sk', 'sl', 'sq', 'sr', 
      'sv', 'th', 'tr', 'uk', 'ur', 'vi', 'zh', 'zh_Hant'
    ],
    localeDetection: true,
  },
  reloadOnPrerender: process.env.NODE_ENV === 'development',
  defaultNS: 'common',
  ns: ['common', 'navbar', 'footer', 'pricing', 'features', 'enterprise', 'about', 'contact', 'errors'],
  fallbackLng: 'en',
  interpolation: {
    escapeValue: false,
  },
  // RTL languages
  rtl: ['ar', 'he', 'fa', 'ur'],
}