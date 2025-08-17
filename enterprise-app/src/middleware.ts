import type { NextRequest } from 'next/server'
import { NextResponse } from 'next/server'

export function middleware(request: NextRequest) {
  const path = request.nextUrl.pathname
  const publicPaths = ['/', '/login', '/register']
  const isPublic = publicPaths.includes(path)
  if (isPublic) return NextResponse.next()

  // Subscriber-only gate: require auth cookies for dashboard and API pages (non-public)
  if (path.startsWith('/dashboard') || path.startsWith('/app')) {
    const hasSession = Boolean(request.cookies.get('session-token') || request.cookies.get('firebase-auth-token'))
    if (!hasSession) return NextResponse.redirect(new URL('/login', request.url))
  }
  return NextResponse.next()
}

export const config = { matcher: ['/((?!_next/static|_next/image|favicon.ico|api/public).*)'] }


