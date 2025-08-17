import type { NextRequest } from "next/server"
import { NextResponse } from "next/server"

export function middleware(request: NextRequest) {
  // Get the pathname of the request
  const path = request.nextUrl.pathname

  // Define public paths that don't require authentication
  const publicPaths = ['/login', '/access-denied', '/']

  // Check if the current path is public
  const isPublicPath = publicPaths.some(publicPath =>
    path === publicPath || path.startsWith(publicPath + '/')
  )

  // If it's a public path, allow access
  if (isPublicPath) {
    return NextResponse.next()
  }

  // Server-side gating for dashboard: require presence of auth cookies.
  // Deeper subscription checks occur within API routes and can also be enforced here if desired.
  if (path.startsWith('/dashboard')) {
    const hasSession = Boolean(request.cookies.get('session-token') || request.cookies.get('firebase-auth-token'))
    if (!hasSession) {
      return NextResponse.redirect(new URL('/login', request.url))
    }
    return NextResponse.next()
  }

  // For any other protected routes, redirect to login
  return NextResponse.redirect(new URL('/login', request.url))
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     */
    '/((?!api|_next/static|_next/image|favicon.ico).*)',
  ],
} 