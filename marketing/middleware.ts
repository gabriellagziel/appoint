import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

// Middleware יחול רק על נתיבי /app, /dashboard ו-/api (מוגנים/פנימיים)
export function middleware(req: NextRequest) {
    const { pathname } = req.nextUrl;

    // API ציבורי לא מוגן
    if (pathname.startsWith('/api/public')) {
        return NextResponse.next();
    }

    // TODO: כאן לוגיקת אימות למסלולים מוגנים (אם צריך)
    return NextResponse.next();
}

export const config = {
    matcher: ['/app/:path*', '/dashboard/:path*', '/api/:path*'],
};
