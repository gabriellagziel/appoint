import InstallPrompt from '@/components/InstallPrompt'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'App-Oint Personal',
  description: 'ניהול פגישות אישיות וזיכרונות',
  manifest: '/manifest.json',
  themeColor: '#0a84ff',
  appleWebApp: {
    capable: true,
    statusBarStyle: 'default',
    title: 'App-Oint Personal',
  },
  icons: {
    apple: '/icons/icon-152.svg',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="he" dir="rtl">
      <body className={inter.className}>
        {children}
        <InstallPrompt />
        <script
          dangerouslySetInnerHTML={{
            __html: `
              if ('serviceWorker' in navigator) {
                window.addEventListener('load', function() {
                  navigator.serviceWorker.register('/sw.js')
                    .then(function(registration) {
                      console.log('SW registered: ', registration);
                    })
                    .catch(function(registrationError) {
                      console.log('SW registration failed: ', registrationError);
                    });
                });
              }
            `,
          }}
        />
      </body>
    </html>
  )
}
