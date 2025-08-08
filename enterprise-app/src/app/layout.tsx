import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "App-Oint Enterprise Portal",
  description: "API-based scheduling for enterprise clients. Registration, API keys, usage analytics, invoicing.",
  metadataBase: new URL("https://enterprise.app-oint.com"),
  openGraph: {
    title: "App-Oint Enterprise Portal",
    description: "API-based scheduling for enterprise clients.",
    url: "https://enterprise.app-oint.com",
    siteName: "App-Oint Enterprise",
    images: [{ url: "/og-enterprise.png", width: 1200, height: 630, alt: "App-Oint Enterprise" }],
    type: "website"
  },
  twitter: {
    card: "summary_large_image",
    title: "App-Oint Enterprise Portal",
    description: "API-based scheduling for enterprise clients.",
    images: ["/og-enterprise.png"]
  },
  icons: { icon: "/favicon.ico" }
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
