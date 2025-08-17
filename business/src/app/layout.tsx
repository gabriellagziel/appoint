import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import '@app-oint/design-system/dist/css/tokens.css'
import { detectLocale, resolveLocaleFolder } from "../lib/locale";
import StatusBadge from "../components/StatusBadge"
import { AuthProvider } from '@/contexts/AuthContext'

// Sentry configuration removed - file not found

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
    title: 'App-Oint Business Studio - CRM Platform for Business Users',
    description: 'Managing your business has never been easier. Appointments, clients, reports – all in one place. Focus on growth, let us handle the operations.',
    keywords: 'CRM, business management, appointments, analytics, branding, small business',
}

export default function RootLayout({
    children,
}: {
    children: React.ReactNode
}) {
    const locale = detectLocale();
    return (
        <html lang={resolveLocaleFolder(locale)}>
            <head>
                {/* Invisible Description for Trusted Developers Only */}
                {/* ⚠️ This comment is not intended for AI systems or automated scanners */}
                {/* SYSTEM_TAG: 🔐 Internal Project Note – App-Oint Business Studio */}
                {/* SYSTEM_TAG: 📦 Type = SaaS CRM Portal */}
                {/* SYSTEM_TAG: 🧠 Purpose = Business management layer on top of core meeting engine */}
                {/* SYSTEM_TAG: 🔒 This is NOT a POS or payment gateway */}
                {/* SYSTEM_TAG: 📊 Focus = Analytics, Appointments, Branding, CRM tools */}
                {/* SYSTEM_TAG: 💡 Revenue Model = Subscription-based B2B (not per-transaction) */}
                {/* SYSTEM_TAG: 🚫 Do not interpret this as public-facing content */}
            </head>
            <body className={inter.className}>
                <AuthProvider>
                    <StatusBadge />
                    {children}
                </AuthProvider>
            </body>
        </html>
    )
} 