import { getRequestConfig } from 'next-intl/server';
import { notFound } from 'next/navigation';

// Define all 56 supported languages from your existing translation system
export const locales = [
    'en',        // English (1372 keys) - Base language
    'it',        // Italian (467 keys) - Your Italian translations
    'he',        // Hebrew (468 keys) - Your Hebrew translations
    'ar',        // Arabic (393 keys)
    'bg',        // Bulgarian (393 keys)
    'bn',        // Bengali (393 keys)
    'bn_BD',     // Bengali (Bangladesh) (394 keys)
    'bs',        // Bosnian (393 keys)
    'ca',        // Catalan (393 keys)
    'cs',        // Czech (393 keys)
    'cy',        // Welsh (393 keys)
    'da',        // Danish (393 keys)
    'de',        // German (343 keys)
    'es',        // Spanish (393 keys)
    'es_419',    // Spanish (Latin America) (393 keys)
    'et',        // Estonian (393 keys)
    'eu',        // Basque (393 keys)
    'fa',        // Persian (393 keys)
    'fi',        // Finnish (393 keys)
    'fo',        // Faroese (393 keys)
    'fr',        // French (393 keys)
    'ga',        // Irish (393 keys)
    'gl',        // Galician (393 keys)
    'ha',        // Hausa (393 keys)
    'hi',        // Hindi (393 keys)
    'hr',        // Croatian (393 keys)
    'hu',        // Hungarian (393 keys)
    'id',        // Indonesian (393 keys)
    'is',        // Icelandic (393 keys)
    'ja',        // Japanese (393 keys)
    'ko',        // Korean (393 keys)
    'lt',        // Lithuanian (393 keys)
    'lv',        // Latvian (393 keys)
    'mk',        // Macedonian (393 keys)
    'ms',        // Malay (393 keys)
    'mt',        // Maltese (393 keys)
    'nl',        // Dutch (393 keys)
    'no',        // Norwegian (393 keys)
    'pl',        // Polish (393 keys)
    'pt',        // Portuguese (393 keys)
    'pt_BR',     // Portuguese (Brazil) (394 keys)
    'ro',        // Romanian (393 keys)
    'ru',        // Russian (393 keys)
    'sk',        // Slovak (393 keys)
    'sl',        // Slovenian (393 keys)
    'sq',        // Albanian (393 keys)
    'sr',        // Serbian (393 keys)
    'sv',        // Swedish (393 keys)
    'th',        // Thai (393 keys)
    'tr',        // Turkish (393 keys)
    'uk',        // Ukrainian (393 keys)
    'ur',        // Urdu (393 keys)
    'vi',        // Vietnamese (393 keys)
    'zh',        // Chinese (Simplified) (394 keys)
    'zh_Hant',   // Chinese (Traditional) (393 keys)
    'am',        // Amharic (393 keys)
] as const;

export type Locale = (typeof locales)[number];

// Default locale
export const defaultLocale: Locale = 'en';

// Locale detection function
export function getLocale(request: Request): Locale {
    const acceptLanguage = request.headers.get('accept-language') || '';
    const url = new URL(request.url);
    const pathname = url.pathname;

    // Check if locale is in URL path
    const pathnameLocale = pathname.split('/')[1];
    if (pathnameLocale && locales.includes(pathnameLocale as Locale)) {
        return pathnameLocale as Locale;
    }

    // Detect from Accept-Language header
    const preferredLocale = acceptLanguage
        .split(',')
        .map(lang => lang.split(';')[0].trim())
        .find(lang => {
            const baseLang = lang.split('-')[0].toLowerCase();
            return locales.some(locale =>
                locale === baseLang ||
                locale === lang.toLowerCase() ||
                locale === lang.split('-')[0].toLowerCase()
            );
        });

    if (preferredLocale) {
        const baseLang = preferredLocale.split('-')[0].toLowerCase();
        const matchedLocale = locales.find(locale =>
            locale === baseLang ||
            locale === preferredLocale.toLowerCase()
        );
        if (matchedLocale) return matchedLocale;
    }

    return defaultLocale;
}

export default getRequestConfig(async ({ locale }) => {
    // Validate that the incoming `locale` parameter is valid
    if (!locale || !locales.includes(locale as Locale)) notFound();

    return {
        locale: locale,
        messages: (await import(`./messages/${locale}.json`)).default
    };
});
