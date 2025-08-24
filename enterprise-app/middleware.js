import { NextResponse } from "next/server";

export const config = { 
  matcher: ["/app/:path*", "/dashboard/:path*", "/api/:path*"] 
};

export default function middleware(req) {
  // Place your auth/session checks here if needed; public root (/) remains accessible
  return NextResponse.next();
}

