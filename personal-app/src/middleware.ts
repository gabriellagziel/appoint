import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { LOCALES, normalizeLocale } from './i18n';

export const config = {
  matcher: ['/((?!_next|favicon|robots|sitemap).*)']
};

export default function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl;
  // If path already starts with a supported locale, pass through
  const seg = pathname.split('/')[1];
  if (LOCALES.includes(seg as any)) return NextResponse.next();

  // Inspect Accept-Language
  const header = req.headers.get('accept-language') || '';
  const first = header.split(',')[0] || 'en';
  const best = normalizeLocale(first);

  const url = req.nextUrl.clone();
  url.pathname = `/${best}${pathname}`;
  return NextResponse.redirect(url, { status: 307 });
}
