import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

export function middleware(req: NextRequest) {
  if (req.nextUrl.pathname.startsWith('/api/status') || req.nextUrl.pathname === '/status') {
    const res = NextResponse.next();
    res.headers.set('Cache-Control', 'no-store');
    return res;
  }
  return NextResponse.next();
}



