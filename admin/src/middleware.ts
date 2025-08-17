import type { NextRequest } from "next/server";
import { NextResponse } from "next/server";
import { isMobileOrTablet } from "./utils/deviceDetection";

// Admin route protection
function isAdminRoute(pathname: string): boolean {
  return pathname.startsWith('/admin') && pathname !== '/admin/login';
}

// Check if user is authenticated (simplified for middleware)
function isAuthenticated(request: NextRequest): boolean {
  // Check for Firebase auth token in cookies
  const authToken = request.cookies.get('firebase-auth-token');
  const sessionToken = request.cookies.get('session-token');

  // In production, verify the JWT token with Firebase Admin SDK
  // For now, we'll let the client-side auth handle this
  return !!authToken || !!sessionToken;
}

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl
  const userAgent = request.headers.get('user-agent') || ''

  // Skip middleware for static files and API routes
  if (
    pathname.startsWith('/_next') ||
    pathname.startsWith('/api') ||
    pathname.includes('.') ||
    pathname === '/manifest.json' ||
    pathname === '/icon.svg' ||
    pathname === '/favicon.ico'
  ) {
    return NextResponse.next()
  }

  // Re-enable admin route protection: ensure only authenticated users can access `/admin/*`.
  // Rationale: This was previously disabled for testing. In production we must enforce access control at the edge.
  if (isAdminRoute(pathname)) {
    // If no auth cookies are present, redirect to admin login and preserve intended destination.
    if (!isAuthenticated(request)) {
      const loginUrl = new URL('/admin/login', request.url)
      loginUrl.searchParams.set('callbackUrl', pathname)
      return NextResponse.redirect(loginUrl)
    }
  }

  // Device-based routing
  const isMobile = isMobileOrTablet(userAgent)

  // If accessing root on mobile, redirect to quick dashboard
  if (pathname === '/' && isMobile) {
    return NextResponse.redirect(new URL('/quick', request.url))
  }

  // If accessing quick dashboard on desktop, show desktop version
  if (pathname === '/quick' && !isMobile) {
    // Allow access but add a header to indicate desktop access
    const response = NextResponse.next()
    response.headers.set('x-device-type', 'desktop')
    return response
  }

  return NextResponse.next()
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public files (public folder)
     */
    '/((?!_next/static|_next/image|favicon.ico|.*\\..*|api).*)',
  ],
} 