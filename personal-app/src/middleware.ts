import type { NextRequest } from "next/server";
import { NextResponse } from "next/server";
import { LOCALES } from "./i18n";

export default function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl;

  // Skip static assets and API routes
  if (
    pathname.startsWith('/_next') ||
    pathname.startsWith('/api') ||
    pathname.includes('.') ||
    pathname.startsWith('/_vercel')
  ) {
    return NextResponse.next();
  }

  // Handle root redirect to default locale
  if (pathname === "/") {
    const url = req.nextUrl.clone();
    url.pathname = "/en";
    return NextResponse.redirect(url);
  }

  // Check if pathname starts with a locale
  const pathnameSegments = pathname.split('/').filter(Boolean);
  const firstSegment = pathnameSegments[0];

  if (firstSegment && LOCALES.includes(firstSegment as any)) {
    // Valid locale in path, continue
    return NextResponse.next();
  }

  // No locale in path, redirect to default locale with full path
  const url = req.nextUrl.clone();
  url.pathname = `/en${pathname}`;
  return NextResponse.redirect(url);
}

export const config = {
  matcher: [
    // Skip all internal paths (_next)
    '/((?!_next|_vercel|.*\\..*).*)',
    // Optional: only run on root (/) URL
    // '/'
  ],
};

