import { NextRequest, NextResponse } from 'next/server';
import { locales, defaultLocale, Locale } from '../i18n';

export function middleware(request: NextRequest) {
  // Get user's preferred language from browser
  const acceptLanguage = request.headers.get('accept-language') || '';
  const pathname = request.nextUrl.pathname;
  
  // Check if locale is already in URL path
  const pathnameLocale = pathname.split('/')[1];
  if (pathnameLocale && locales.includes(pathnameLocale as Locale)) {
    return NextResponse.next();
  }
  
  // Smart locale detection logic - PRIORITIZE ITALIAN
  let detectedLocale: Locale = defaultLocale;
  
  // Check browser language preference - ITALIAN FIRST
  if (acceptLanguage.includes('it') || acceptLanguage.includes('it-IT')) {
    detectedLocale = 'it';
  } else if (acceptLanguage.includes('he') || acceptLanguage.includes('he-IL')) {
    detectedLocale = 'he';
  } else if (acceptLanguage.includes('es') || acceptLanguage.includes('es-ES')) {
    detectedLocale = 'es';
  } else if (acceptLanguage.includes('fr') || acceptLanguage.includes('fr-FR')) {
    detectedLocale = 'fr';
  } else if (acceptLanguage.includes('de') || acceptLanguage.includes('de-DE')) {
    detectedLocale = 'de';
  } else if (acceptLanguage.includes('ar')) {
    detectedLocale = 'ar';
  } else if (acceptLanguage.includes('zh')) {
    detectedLocale = 'zh';
  } else if (acceptLanguage.includes('ja')) {
    detectedLocale = 'ja';
  } else if (acceptLanguage.includes('ko')) {
    detectedLocale = 'ko';
  } else if (acceptLanguage.includes('ru')) {
    detectedLocale = 'ru';
  } else if (acceptLanguage.includes('pt')) {
    detectedLocale = 'pt';
  } else if (acceptLanguage.includes('nl')) {
    detectedLocale = 'nl';
  } else if (acceptLanguage.includes('pl')) {
    detectedLocale = 'pl';
  } else if (acceptLanguage.includes('tr')) {
    detectedLocale = 'tr';
  } else if (acceptLanguage.includes('hi')) {
    detectedLocale = 'hi';
  } else if (acceptLanguage.includes('bn')) {
    detectedLocale = 'bn';
  } else if (acceptLanguage.includes('fa')) {
    detectedLocale = 'fa';
  } else if (acceptLanguage.includes('ur')) {
    detectedLocale = 'ur';
  } else if (acceptLanguage.includes('th')) {
    detectedLocale = 'th';
  } else if (acceptLanguage.includes('vi')) {
    detectedLocale = 'vi';
  } else if (acceptLanguage.includes('id')) {
    detectedLocale = 'id';
  } else if (acceptLanguage.includes('ms')) {
    detectedLocale = 'ms';
  } else if (acceptLanguage.includes('sw')) {
    detectedLocale = 'sw' as Locale;
  } else if (acceptLanguage.includes('am')) {
    detectedLocale = 'am';
  } else if (acceptLanguage.includes('zu')) {
    detectedLocale = 'zu' as Locale;
  } else if (acceptLanguage.includes('xh')) {
    detectedLocale = 'xh' as Locale;
  } else if (acceptLanguage.includes('af')) {
    detectedLocale = 'af' as Locale;
  } else if (acceptLanguage.includes('st')) {
    detectedLocale = 'st' as Locale;
  } else if (acceptLanguage.includes('tn')) {
    detectedLocale = 'tn' as Locale;
  } else if (acceptLanguage.includes('ss')) {
    detectedLocale = 'ss' as Locale;
  } else if (acceptLanguage.includes('en')) {
    detectedLocale = 'en';
  }
  
  // If no locale in path, redirect to detected locale
  if (!pathname.startsWith('/en') && !pathname.startsWith('/it') && !pathname.startsWith('/he') && 
      !pathname.startsWith('/es') && !pathname.startsWith('/fr') && !pathname.startsWith('/de') &&
      !pathname.startsWith('/ar') && !pathname.startsWith('/zh') && !pathname.startsWith('/ja') &&
      !pathname.startsWith('/ko') && !pathname.startsWith('/ru') && !pathname.startsWith('/pt') &&
      !pathname.startsWith('/nl') && !pathname.startsWith('/pl') && !pathname.startsWith('/tr') &&
      !pathname.startsWith('/hi') && !pathname.startsWith('/bn') && !pathname.startsWith('/fa') &&
      !pathname.startsWith('/ur') && !pathname.startsWith('/th') && !pathname.startsWith('/vi') &&
      !pathname.startsWith('/id') && !pathname.startsWith('/ms') && !pathname.startsWith('/sw') &&
      !pathname.startsWith('/am') && !pathname.startsWith('/zu') && !pathname.startsWith('/xh') &&
      !pathname.startsWith('/af') && !pathname.startsWith('/st') && !pathname.startsWith('/tn') &&
      !pathname.startsWith('/ss')) {
    
    const url = request.nextUrl.clone();
    url.pathname = `/${detectedLocale}${pathname}`;
    
    // Add debug headers
    const response = NextResponse.redirect(url);
    response.headers.set('x-detected-locale', detectedLocale);
    response.headers.set('x-accept-language', acceptLanguage);
    
    return response;
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: [
    '/((?!api|_next|_vercel|.*\\..*).*)',
  ],
};
