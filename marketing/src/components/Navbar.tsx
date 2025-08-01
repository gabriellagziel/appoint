import { LanguageSwitcher } from '@/components/LanguageSwitcher'
import { Button } from '@/components/ui/button'
import { useI18n } from '@/lib/i18n'
import { Menu, X } from 'lucide-react'
import Link from 'next/link'
import { useState } from 'react'

export function Navbar() {
    const [isMenuOpen, setIsMenuOpen] = useState(false)
    const { t } = useI18n()

    return (
        <nav className="bg-white shadow-sm border-b">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between items-center h-16">
                    {/* Logo */}
                    <div className="flex-shrink-0">
                        <Link href="/" className="flex items-center">
                            <svg
                                className="h-8 w-8 text-blue-600"
                                fill="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
                            </svg>
                            <span className="ml-2 text-xl font-bold text-gray-900">App-Oint</span>
                        </Link>
                    </div>

                    {/* Desktop Navigation */}
                    <div className="hidden md:flex items-center space-x-6">
                        <div className="flex items-baseline space-x-4">
                            <Link href="/" className="text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                                {t('navigation.home')}
                            </Link>
                            <Link href="/features" className="text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                                {t('navigation.features')}
                            </Link>
                            <Link href="/pricing" className="text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                                {t('navigation.pricing')}
                            </Link>
                            <Link href="/enterprise" className="text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                                {t('navigation.enterprise')}
                            </Link>
                            <Link href="/about" className="text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                                {t('navigation.about')}
                            </Link>
                            <Link href="/contact" className="text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                                {t('navigation.contact')}
                            </Link>
                        </div>
                        <LanguageSwitcher />
                    </div>

                    {/* Mobile menu button */}
                    <div className="md:hidden">
                        <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => setIsMenuOpen(!isMenuOpen)}
                            className="text-gray-500 hover:text-gray-900"
                        >
                            {isMenuOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
                        </Button>
                    </div>
                </div>

                {/* Mobile Navigation */}
                {isMenuOpen && (
                    <div className="md:hidden">
                        <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
                            <Link href="/" className="text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors">
                                {t('navigation.home')}
                            </Link>
                            <Link href="/features" className="text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors">
                                {t('navigation.features')}
                            </Link>
                            <Link href="/pricing" className="text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors">
                                {t('navigation.pricing')}
                            </Link>
                            <Link href="/enterprise" className="text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors">
                                {t('navigation.enterprise')}
                            </Link>
                            <Link href="/about" className="text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors">
                                {t('navigation.about')}
                            </Link>
                            <Link href="/contact" className="text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors">
                                {t('navigation.contact')}
                            </Link>
                            <div className="px-3 py-2">
                                <LanguageSwitcher />
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </nav>
    )
} 