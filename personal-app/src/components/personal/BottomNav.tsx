import Link from 'next/link';

export default function BottomNav({ locale }: { locale: string }) {
    const items = [
        { href: `/${locale}`, label: 'Home' },
        { href: `/${locale}/meetings`, label: 'Meetings' },
        { href: `/${locale}/reminders`, label: 'Reminders' },
        { href: `/${locale}/groups`, label: 'Groups' },
        { href: `/${locale}/family`, label: 'Family' },
        { href: `/${locale}/settings`, label: 'Settings' }
    ];
    return (
        <nav>
            <ul>
                {items.map(i => (
                    <li key={i.href}><Link href={i.href}>{i.label}</Link></li>
                ))}
            </ul>
        </nav>
    );
}
