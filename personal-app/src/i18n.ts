export const LOCALES = [
    // Africa
    'af', 'am', 'ar', 'ha', 'ig', 'sw', 'yo', 'zu',
    // Americas + Europe core
    'en', 'es', 'fr', 'pt', 'pt-BR', 'de', 'it', 'nl', 'pl', 'ru', 'uk',
    // Nordics + Balkans + Central/Eastern
    'sv', 'da', 'no', 'fi', 'cs', 'sk', 'sl', 'hr', 'sr',
    // Middle East / South Asia
    'he', 'fa', 'ur', 'tr', 'ku', 'ps', 'hy',
    // East & Southeast Asia
    'zh', 'zh-CN', 'zh-TW', 'ja', 'ko', 'th', 'vi', 'id', 'ms', 'tl',
    // South Asia continued
    'hi', 'bn', 'ta', 'te', 'ml', 'mr', 'gu', 'pa',
    // Extras to reach 56 neatly
    'ro', 'el', 'hu', 'bg', 'lt', 'lv', 'et'
] as const;

export type Locale = typeof LOCALES[number];

export const RTL_LOCALES: Locale[] = [
    'ar', 'he', 'fa', 'ur', 'ps'
] as any;

// Map variants → base (e.g., de-AT → de)
export function normalizeLocale(input: string): Locale {
    const lc = input.toLowerCase();
    const direct = LOCALES.find(l => l.toLowerCase() === lc);
    if (direct) return direct as Locale;

    // map regional variants to 2-letter where sensible
    const base = lc.split('-')[0];
    const match = LOCALES.find(l => l.toLowerCase() === base);
    if (match) return match as Locale;

    // zh special-casing
    if (lc.startsWith('zh-tw')) return 'zh-TW' as Locale;
    if (lc.startsWith('zh-cn')) return 'zh-CN' as Locale;

    // default fallback
    return 'en';
}

export function isRTL(locale: string) {
    return RTL_LOCALES.includes(normalizeLocale(locale) as any);
}
