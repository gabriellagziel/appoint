'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

const labels = {
    en: {
        home: 'Home',
        meetings: 'Meetings',
        reminders: 'Reminders',
        groups: 'Groups',
        family: 'Family',
        settings: 'Settings'
    },
    it: {
        home: 'Casa',
        meetings: 'Riunioni',
        reminders: 'Promemoria',
        groups: 'Gruppi',
        family: 'Famiglia',
        settings: 'Impostazioni'
    },
    he: {
        home: 'בית',
        meetings: 'פגישות',
        reminders: 'תזכורות',
        groups: 'קבוצות',
        family: 'משפחה',
        settings: 'הגדרות'
    }
};

const items = [
    { href: 'home', key: 'home' },
    { href: 'meetings', key: 'meetings' },
    { href: 'reminders', key: 'reminders' },
    { href: 'groups', key: 'groups' },
    { href: 'family', key: 'family' },
    { href: 'settings', key: 'settings' }
];

export default function BottomNav({ locale }: { locale: string }) {
    const pathname = usePathname();
    const localeLabels = labels[locale as keyof typeof labels] || labels.en;

    return (
        <nav className="fixed bottom-0 left-0 right-0 mx-auto max-w-screen-sm border-t bg-white/90 backdrop-blur">
            <ul className="grid grid-cols-6 text-center text-sm">
                {items.map((it) => {
                    const href = `/${locale}/${it.href}`;
                    const active = pathname?.startsWith(href);
                    return (
                        <li key={it.href}>
                            <Link href={href} className={`block py-3 ${active ? 'font-semibold' : 'opacity-80'}`}>
                                {localeLabels[it.key as keyof typeof localeLabels]}
                            </Link>
                        </li>
                    );
                })}
            </ul>
        </nav>
    );
}
