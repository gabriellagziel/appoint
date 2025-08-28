import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

export const config = {
    matcher: ['/app/:path*', '/dashboard/:path*', '/api/(?!public/).*']
};

export function middleware(_req: NextRequest) {
    return NextResponse.next();
}
