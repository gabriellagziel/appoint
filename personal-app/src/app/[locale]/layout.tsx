import type { ReactNode } from 'react';
import BottomNav from '../../components/personal/BottomNav';
import InstallPrompt from '../../components/pwa/InstallPrompt';
import PWARegister from '../../components/pwa/PWARegister';
import { isRTL, LOCALES, normalizeLocale } from '../../i18n';

export async function generateMetadata({ params }: { params: { locale: string } }) {
    const loc = normalizeLocale(params.locale);
    const languages = Object.fromEntries(LOCALES.map(l => [l, `/${l}`]));
    return {
        alternates: { languages },
        manifest: `/${loc}/manifest.webmanifest`,
        themeColor: '#0ea5e9',
        other: {
            'apple-mobile-web-app-capable': 'yes',
            'REDACTED_TOKEN': 'default'
        }
    };
}

export default function LocaleLayout({ children, params }: { children: ReactNode; params: { locale: string } }) {
    const loc = normalizeLocale(params.locale);
    const dir = isRTL(loc) ? 'rtl' : 'ltr';
    return (
        <html lang={loc} dir={dir}>
            <body>
                <PWARegister locale={loc} />
                <InstallPrompt locale={loc} />
                {children}
                <BottomNav locale={loc} />
            </body>
        </html>
    );
}
