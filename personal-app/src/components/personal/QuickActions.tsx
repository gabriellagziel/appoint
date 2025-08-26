'use client';
import Link from 'next/link';

const labels = {
    en: {
        newMeeting: { title: "New Meeting", subtitle: "Set, Send, Done" },
        reminder: { title: "Reminder" },
        playtime: { title: "Playtime" },
        groups: { title: "Groups" },
        family: { title: "Family" }
    },
    it: {
        newMeeting: { title: "Nuova Riunione", subtitle: "Imposta, Invia, Fatto" },
        reminder: { title: "Promemoria" },
        playtime: { title: "Tempo di Gioco" },
        groups: { title: "Gruppi" },
        family: { title: "Famiglia" }
    },
    he: {
        newMeeting: { title: "פגישה חדשה", subtitle: "קבע, שלח, סיים" },
        reminder: { title: "תזכורת" },
        playtime: { title: "זמן משחק" },
        groups: { title: "קבוצות" },
        family: { title: "משפחה" }
    }
};

function Card({ href, emoji, title, subtitle }: { href: string; emoji: string; title: string; subtitle?: string }) {
    return (
        <Link href={href} className="rounded-2xl border p-4 hover:shadow-md transition">
            <div className="text-3xl">{emoji}</div>
            <div className="mt-2 text-base font-semibold">{title}</div>
            {subtitle ? <div className="text-sm opacity-70">{subtitle}</div> : null}
        </Link>
    );
}

export default function QuickActions({ locale }: { locale: string }) {
    const localeLabels = labels[locale as keyof typeof labels] || labels.en;

    return (
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
            <Card href={`/${locale}/create/meeting`} emoji="➕" title={localeLabels.newMeeting.title} subtitle={localeLabels.newMeeting.subtitle} />
            <Card href={`/${locale}/reminders`} emoji="⏰" title={localeLabels.reminder.title} />
            <Card href={`/${locale}/playtime`} emoji="🎮" title={localeLabels.playtime.title} />
            <Card href={`/${locale}/groups`} emoji="👥" title={localeLabels.groups.title} />
            <Card href={`/${locale}/family`} emoji="👨‍👩‍👧" title={localeLabels.family.title} />
        </div>
    );
}
