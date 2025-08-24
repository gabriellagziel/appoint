import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

export function middleware(req: NextRequest) {
    const p = req.nextUrl.pathname;

    // Always allow home page, assets, health, and public files
    const allow =
        p === '/' ||
        p === '/robots.txt' ||
        p === '/sitemap.xml' ||
        p.startsWith('/_next') ||
        p.startsWith('/assets') ||
        p === '/favicon.ico' ||
        p.startsWith('/api/status');

    if (allow) return NextResponse.next();

    // Only protect internal areas if they exist
    const protectedPath = p.startsWith('/dashboard') || p.startsWith('/app');
    if (!protectedPath) return NextResponse.next();

    // For protected paths, redirect to home if not authenticated
    const url = req.nextUrl.clone();
    url.pathname = '/';
    return NextResponse.redirect(url);
}

export const config = { matcher: ['/dashboard/:path*', '/app/:path*', '/api/status'] };
