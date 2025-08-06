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

  // For dashboard routes, we'll let the client-side auth handle the protection
  // since we need to check Firebase Auth state and user roles
  if (path.startsWith('/dashboard')) {
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