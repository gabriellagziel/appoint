import type { ReactNode } from 'react';
import { isRTL, normalizeLocale } from '../../i18n';

export default function LocaleLayout({
  children, params
}: { children: ReactNode; params: { locale: string } }) {
  const loc = normalizeLocale(params.locale);
  const dir = isRTL(loc) ? 'rtl' : 'ltr';
  return (
    <html lang={loc} dir={dir}>
      <body>{children}</body>
    </html>
  );
}
