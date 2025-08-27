'use client';
import ChatPanel from '@/components/personal/ChatPanel';
import DetailsCard from '@/components/personal/DetailsCard';
import Participants from '@/components/personal/Participants';
import QuickActionsRow from '@/components/personal/QuickActionsRow';
import { ensureDemoMeeting, getMeeting, markArrived, markLate } from '@/lib/localStore';
import { useParams, useRouter } from 'next/navigation';
import { useEffect, useMemo, useState } from 'react';

export default function MeetingHub() {
    const { id, locale } = useParams<{ id: string; locale: string }>();
    const router = useRouter();
    const [loaded, setLoaded] = useState(false);

    const meeting = useMemo(() => {
        if (typeof window === 'undefined') return undefined; // SSR check
        return getMeeting(id) ?? undefined;
    }, [id, loaded]);

    useEffect(() => {
        if (typeof window === 'undefined') return; // SSR check

        // If no meeting found, create a demo and redirect to it
        if (!meeting) {
            const demo = ensureDemoMeeting();
            router.replace(`/${locale}/meetings/${demo.id}`);
        } else {
            setLoaded(true);
        }
    }, [id, locale, meeting, router]);

    if (!meeting) {
        return (
            <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
                <div className="flex items-center justify-center h-64">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
                </div>
            </main>
        );
    }

    const goJoin = () => {
        if (meeting.externalLink) {
            window.open(meeting.externalLink, '_blank');
        } else if (meeting.details.location) {
            // naive maps link
            const q = encodeURIComponent(meeting.details.location);
            window.open(`https://www.google.com/maps/search/?api=1&query=${q}`, '_blank');
        } else {
            alert('No link or location set yet.');
        }
    };

    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4">
            <DetailsCard m={meeting} />
            <Participants list={meeting.participants} />
            <QuickActionsRow
                onLate={() => markLate(meeting.id, 'Gabriel', 10)}
                onGo={goJoin}
                onArrived={() => markArrived(meeting.id, 'Gabriel')}
            />
            <ChatPanel meetingId={meeting.id} />
        </main>
    );
}

