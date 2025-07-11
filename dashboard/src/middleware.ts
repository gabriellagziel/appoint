import { withAuth } from "next-auth/middleware"
import { NextResponse } from "next/server"

export default withAuth(
  function middleware(req) {
    const token = req.nextauth.token
    const isClient = token?.role === "client"
    const isDashboardRoute = req.nextUrl.pathname.startsWith("/dashboard")

    if (isDashboardRoute && !isClient) {
      return NextResponse.redirect(new URL("/auth/signin", req.url))
    }
  },
  {
    callbacks: {
      authorized: ({ token }) => !!token && token.role === "client"
    },
  }
)

export const config = {
  matcher: ["/dashboard/:path*"]
} 