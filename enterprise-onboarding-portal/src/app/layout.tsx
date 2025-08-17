import './globals.css'
import '@app-oint/design-system/dist/css/tokens.css'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'App-Oint Enterprise Portal',
  description: 'Enterprise onboarding and management portal for App-Oint',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-gray-50">
        {children}
      </body>
    </html>
  )
} 