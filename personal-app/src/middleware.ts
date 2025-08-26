import { NextRequest, NextResponse } from "next/server";

export function middleware(request: NextRequest) {
  // Get user's preferred language from browser
  const acceptLanguage = request.headers.get("accept-language") || "";
  const userCountry = request.geo?.country || "";

  // Smart locale detection logic - PRIORITIZE ITALIAN
  let detectedLocale = "en"; // fallback

  // Check browser language preference - ITALIAN FIRST
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
    url.pathname = `/${detectedLocale}${pathname}`;

    // Add debug headers
    const response = NextResponse.redirect(url);
    response.headers.set("x-detected-locale", detectedLocale);
    response.headers.set("x-accept-language", acceptLanguage);
    response.headers.set("x-user-country", userCountry);

    return response;
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    // Skip static files and API routes
    "/((?!api|_next/static|_next/image|favicon.ico).*)",
  ],
};
