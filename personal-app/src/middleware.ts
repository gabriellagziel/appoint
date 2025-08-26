import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { LOCALES, normalizeLocale } from './i18n';

export const config = { matcher: ['/((?!_next|favicon|robots|sitemap|manifest).*)'] };

export default function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl;
  const seg = pathname.split('/')[1];
  if (LOCALES.includes(seg as any)) return NextResponse.next();

  // 1) User preference cookie wins
  const pref = req.cookies.get('NEXT_LOCALE')?.value;
  if (pref && LOCALES.includes(normalizeLocale(pref) as any)) {
    const url = req.nextUrl.clone();
    url.pathname = `/${normalizeLocale(pref)}${pathname}`;
    return NextResponse.redirect(url, { status: 307 });
  }

  // 2) Fallback to Accept-Language
  const header = req.headers.get('accept-language') || '';
  const first = header.split(',')[0] || 'en';
  const best = normalizeLocale(first);
  const url = req.nextUrl.clone();
  url.pathname = `/${best}${pathname}`;
  return NextResponse.redirect(url, { status: 307 });
}

