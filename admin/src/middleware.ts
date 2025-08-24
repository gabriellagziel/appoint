import { getToken } from "next-auth/jwt"
import type { NextRequest } from "next/server"
import { NextResponse } from "next/server"
import { isMobileOrTablet } from "./utils/deviceDetection"

// Admin UIDs - loaded from environment variables in production
const getAdminUids = (): string[] => {
  const envUids = process.env.ADMIN_UID_WHITELIST
  if (envUids) {
    return envUids.split(',').map(uid => uid.trim())
  }

  // Fallback for development
  return [
    "admin_001",
    "admin_002",
    "admin_003"
  ]
}

// Check if user is admin
async function isAdminUser(request: NextRequest): Promise<boolean> {
  try {
    const adminUids = getAdminUids()

    // Check for admin header (for API routes)
    const adminHeader = request.headers.get('x-admin-user')
    if (adminHeader && adminUids.includes(adminHeader)) {
      return true
    }

    // Check for admin session cookie
    const adminCookie = request.cookies.get('admin-session')
    if (adminCookie && adminUids.includes(adminCookie.value)) {
      return true
    }

    // Check NextAuth JWT token
    const token = await getToken({
      req: request,
      secret: process.env.NEXTAUTH_SECRET
    })

    if (token?.role === 'admin' || adminUids.includes(token?.sub || '')) {
      return true
    }

    return false
  } catch (error) {
    console.error('Admin check error:', error)
    return false
  }
}

export async function middleware(request: NextRequest) {
  // Allow public access if PUBLIC_MODE is enabled
  if (process.env.PUBLIC_MODE === 'true') {
    return NextResponse.next()
  }

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

  // Check if accessing admin routes
  if (pathname.startsWith('/admin') || pathname === '/') {
    const isAdmin = await isAdminUser(request)

    if (!isAdmin) {
      // Redirect to auth page
      const loginUrl = new URL('/auth/login', request.url)
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