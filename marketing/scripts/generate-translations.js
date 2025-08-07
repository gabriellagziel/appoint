const fs = require('fs');
const path = require('path');

const supportedLanguages = [
  'am', 'ar', 'bg', 'bn', 'bn_BD', 'bs', 'ca', 'cs', 'cy', 'da', 'de', 'en', 
  'es', 'es_419', 'et', 'eu', 'fa', 'fi', 'fo', 'fr', 'ga', 'gl', 'ha', 'he', 
  'hi', 'hr', 'hu', 'id', 'is', 'it', 'ja', 'ko', 'lt', 'lv', 'mk', 'ms', 
  'mt', 'nl', 'no', 'pl', 'pt', 'pt_BR', 'ro', 'ru', 'sk', 'sl', 'sq', 'sr', 
  'sv', 'th', 'tr', 'uk', 'ur', 'vi', 'zh', 'zh_Hant'
];

const nameTranslations = {
  // Core translations - will use placeholders for others
  'ar': 'العربية',
  'de': 'Deutsch', 
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'he': 'עברית',
  'hi': 'हिन्दी',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'nl': 'Nederlands',
  'pt': 'Português',
  'ru': 'Русский',
  'zh': '中文'
};

const namespaces = ['common', 'pricing', 'features', 'enterprise', 'about', 'contact', 'errors'];

// Read the English base files
const enDir = path.join(__dirname, '../public/locales/en');
const enTranslations = {};

namespaces.forEach(ns => {
  try {
    const filePath = path.join(enDir, `${ns}.json`);
    if (fs.existsSync(filePath)) {
      enTranslations[ns] = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    }
  } catch (err) {
    console.warn(`Warning: Could not read ${ns}.json for English`);
  }
});

// Create a simple placeholder translation function
function translateText(text, locale) {
  // For demo purposes, we'll keep English for most languages
  // In production, you'd use a translation service
  if (locale === 'en') return text;
  
  // Basic brand name preservation
  if (text === 'App-Oint') return 'App-Oint';
  
  // For languages with specific translations, add them here
  const basicTranslations = {
    'es': {
      'Home': 'Inicio',
      'Features': 'Características',
      'Pricing': 'Precios',
      'Enterprise': 'Empresa',
      'About': 'Acerca de',
      'Contact': 'Contacto',
      'Get Started': 'Comenzar',
      'Learn More': 'Saber más',
    },
    'fr': {
      'Home': 'Accueil',
      'Features': 'Fonctionnalités',
      'Pricing': 'Tarification',
      'Enterprise': 'Entreprise',
      'About': 'À propos',
      'Contact': 'Contact',
      'Get Started': 'Commencer',
      'Learn More': 'En savoir plus',
    },
    'de': {
      'Home': 'Startseite',
      'Features': 'Funktionen',
      'Pricing': 'Preise',
      'Enterprise': 'Unternehmen',
      'About': 'Über uns',
      'Contact': 'Kontakt',
      'Get Started': 'Loslegen',
      'Learn More': 'Mehr erfahren',
    }
  };
  
  if (basicTranslations[locale] && basicTranslations[locale][text]) {
    return basicTranslations[locale][text];
  }
  
  // Fallback to English with language indicator for development
  return `${text}`;
}

// Recursively translate an object
function translateObject(obj, locale) {
  const result = {};
  
  for (const [key, value] of Object.entries(obj)) {
    if (typeof value === 'string') {
      result[key] = translateText(value, locale);
    } else if (typeof value === 'object' && value !== null) {
      result[key] = translateObject(value, locale);
    } else {
      result[key] = value;
    }
  }
  
  return result;
}

// Generate translation files for all languages
supportedLanguages.forEach(locale => {
  const localeDir = path.join(__dirname, '../public/locales', locale);
  
  // Create directory if it doesn't exist
  if (!fs.existsSync(localeDir)) {
    fs.mkdirSync(localeDir, { recursive: true });
  }
  
  // Generate each namespace file
  namespaces.forEach(ns => {
    if (enTranslations[ns]) {
      const translatedContent = translateObject(enTranslations[ns], locale);
      
      // Update language-specific content
      if (translatedContent.language) {
        translatedContent.language.currentLanguage = nameTranslations[locale] || locale.toUpperCase();
      }
      
      const filePath = path.join(localeDir, `${ns}.json`);
      fs.writeFileSync(filePath, JSON.stringify(translatedContent, null, 2), 'utf8');
      console.log(`Generated ${locale}/${ns}.json`);
    }
  });
});

console.log('Translation generation complete!');
console.log(`Generated translations for ${supportedLanguages.length} languages`);