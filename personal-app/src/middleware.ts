import { NextRequest, NextResponse } from "next/server";

export function middleware(request: NextRequest) {
  // Get user's preferred language from browser
  const acceptLanguage = request.headers.get("accept-language") || "";
  const userCountry = request.geo?.country || "";
  
  // Smart locale detection logic
  let detectedLocale = "en"; // fallback
  
  // Check browser language preference
  if (acceptLanguage.includes("it") || userCountry === "IT") {
    detectedLocale = "it";
  } else if (acceptLanguage.includes("he") || userCountry === "IL") {
    detectedLocale = "he";
  } else if (acceptLanguage.includes("en")) {
    detectedLocale = "en";
  }
  
  // Get pathname
  const pathname = request.nextUrl.pathname;
  
  // If no locale in path, redirect to detected locale
  if (!pathname.startsWith("/en") && !pathname.startsWith("/it") && !pathname.startsWith("/he")) {
    const url = request.nextUrl.clone();
    url.pathname = \`/\${detectedLocale}\${pathname}\`;
    return NextResponse.redirect(url);
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: [
    // Skip static files and API routes
    "/((?!api|_next/static|_next/image|favicon.ico).*)",
  ],
};
