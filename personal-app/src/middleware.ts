import createMiddleware from 'next-intl/middleware';
import { defaultLocale, locales } from '../i18n';

export default createMiddleware({
  // A list of all locales that are supported
  locales: locales,
  
  // Used when no locale matches
  defaultLocale: defaultLocale,
  
  // Always show the locale in the URL
  localePrefix: 'always',
  
  // Locale detection strategy
  localeDetection: true,
  
  // Redirect to the locale prefix
  alternateLinks: true,
});

export const config = {
  // Skip static files and API routes
  matcher: [
    '/((?!api|_next|_vercel|.*\\..*).*)',
  ],
};
