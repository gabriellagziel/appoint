import { Providers } from "@/components/Providers"
import type { Metadata, Viewport } from "next"
import { Inter } from "next/font/google"
import "./globals.css"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "App-Oint Admin",
  description: "Admin dashboard for App-Oint",
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "Admin Dashboard",
  },
  formatDetection: {
    telephone: false,
  },
  openGraph: {
    type: "website",
    title: "App-Oint Admin Dashboard",
    description: "Mobile-optimized admin dashboard for App-Oint platform",
    siteName: "App-Oint Admin",
  },
  robots: {
    index: false,
    follow: false,
  },
}

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  themeColor: "#3b82f6",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="icon" href="/icon.svg" type="image/svg+xml" />
        <link rel="apple-touch-icon" href="/icon.svg" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="REDACTED_TOKEN" content="default" />
        <meta name="apple-mobile-web-app-title" content="Admin" />
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="msapplication-TileColor" content="#3b82f6" />
        <meta name="msapplication-tap-highlight" content="no" />
        {/* SYSTEM_TAG: 🔐 App-Oint Admin Panel */}
        {/* SYSTEM_TAG: 📦 Type = Firebase-powered internal dashboard */}
        {/* SYSTEM_TAG: 🧠 Purpose = Moderation, Analytics, User Management */}
        {/* SYSTEM_TAG: 🔒 Protected by Firebase Auth with Admin role */}
        {/* SYSTEM_TAG: 🚫 Not part of user-facing site */}
      </head>
      <body className={`${inter.className} bg-gray-50 min-h-screen`}>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  )
}
