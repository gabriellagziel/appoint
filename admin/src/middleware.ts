import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"
import { isMobileOrTablet } from "./utils/deviceDetection"

// Admin UID validation - replace with actual Firebase Auth check
function isAdminUser(request: NextRequest): boolean {
  // Check for admin session cookie
  const adminSession = request.cookies.get('admin-session')
  const authToken = request.cookies.get('auth-token')
  
  // For production, implement proper Firebase Auth verification
  // This should check against a list of authorized admin UIDs
  const authorizedAdminUIDs = [
    'admin_uid_1', // Replace with actual admin UIDs
    'admin_uid_2',
    'admin_uid_3'
  ]
  
  // For now, allow access (replace with real auth logic)
  // In production, verify JWT token and check UID against authorized list
  return true
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
    pathname === '/icon.svg'
  ) {
    return NextResponse.next()
  }

  // Check if user is admin
  if (!isAdminUser(request)) {
    // Redirect to auth page (implement as needed)
    const loginUrl = new URL('/auth/login', request.url)
    loginUrl.searchParams.set('callbackUrl', pathname)
    return NextResponse.redirect(loginUrl)
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