import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export const config = {
  matcher: ["/app/:path*", "/dashboard/:path*", "/api/:path*"],
};

export default function middleware(req: NextRequest) {
  const path = req.nextUrl.pathname;
  
  // Only protect specific paths: /app, /dashboard, /api
  // Allow root and public pages to pass through
  
  // For protected paths, implement your auth logic here
  // For now, we'll just pass through (you can add auth checks later)
  
  // Example auth check (uncomment when ready):
  // const token = req.cookies.get('auth-token')?.value;
  // if (!token && (path.startsWith('/app') || path.startsWith('/dashboard') || path.startsWith('/api'))) {
  //   return NextResponse.redirect(new URL('/', req.url));
  // }
  
  return NextResponse.next();
}
