import type { ReactNode } from 'react';
import { isRTL, normalizeLocale, LOCALES } from '../../i18n';

export async function generateMetadata({ params }: { params: { locale: string } }) {
  const loc = normalizeLocale(params.locale);
  // Map every locale to its root; Next.js will resolve relative URLs.
  const languages = Object.fromEntries(LOCALES.map(l => [l, `/${l}`]));
  return { alternates: { languages } };
}

export default function LocaleLayout({ children, params }: { children: ReactNode; params: { locale: string } }) {
  const loc = normalizeLocale(params.locale);
  const dir = isRTL(loc) ? 'rtl' : 'ltr';
  return (
    <html lang={loc} dir={dir}>
      <body>{children}</body>
    </html>
  );
}
