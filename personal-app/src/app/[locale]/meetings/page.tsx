import Link from 'next/link';
import { ensureDemoMeeting } from '@/lib/localStore';
import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';

export default function MeetingsPage() {
    const { locale } = useParams<{ locale: string }>();
    const [meetingId, setMeetingId] = useState<string>('');
    useEffect(() => { const m = ensureDemoMeeting(); setMeetingId(m.id); }, []);
    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-3">
            <h1 className="text-2xl font-semibold">Meetings</h1>
            <p className="opacity-70">Your meetings will appear here.</p>
            {meetingId ? (
                <Link href={`/${locale}/meetings/${meetingId}`} className="inline-block rounded-xl border px-4 py-2 hover:shadow bg-blue-50">Open Meeting Hub →</Link>
            ) : null}
        </main>
    );
}

