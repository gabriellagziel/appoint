import type { NextRequest } from "next/server";
import { NextResponse } from "next/server";

const SUPPORTED = ["en", "it", "he", "ar", "fa", "ur", "ps", "ku"]; // extend later
const DEFAULT = "en";

export function middleware(req: NextRequest) {
    const { pathname } = req.nextUrl;

    if (
        pathname.startsWith("/_next") ||
        pathname.startsWith("/api") ||
        pathname.startsWith("/favicon") ||
        pathname.startsWith("/preview") || // Allow preview routes directly
        pathname.match(/\.[a-zA-Z0-9]+$/)
    ) return NextResponse.next();

    const seg = pathname.split("/")[1];
    if (SUPPORTED.includes(seg)) return NextResponse.next();

    const url = req.nextUrl.clone();
    url.pathname = `/${DEFAULT}${pathname}`;
    return NextResponse.rewrite(url);
}

export const config = { matcher: ["/:path*"] };
