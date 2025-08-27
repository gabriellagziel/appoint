'use client';
import { upsertMeeting } from '@/lib/localStore';
import { Meeting, MeetingType } from '@/types/meeting';
import { useParams, useRouter } from 'next/navigation';
import { useState } from 'react';

export default function CreateMeeting() {
    const { locale } = useParams<{ locale: string }>();
    const router = useRouter();
    const [step, setStep] = useState<1 | 2 | 3 | 4 | 5>(1);
    const [type, setType] = useState<MeetingType>('personal');
    const [participants, setParticipants] = useState<string[]>([]);
    const [details, setDetails] = useState({ date: '', time: '', location: '', platform: '' });
    const [createdMeetingId, setCreatedMeetingId] = useState<string>('');

    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4">
            <h1 className="text-2xl font-semibold">Create a Meeting</h1>

            {step === 1 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">What kind of meeting do you want to create?</div>
                    <div className="grid grid-cols-2 gap-3">
                        {([
                            ['personal', '👤 Personal 1:1'],
                            ['group', '👥 Group / Event'],
                            ['virtual', '💻 Virtual'],
                            ['business', '🏢 With a Business'],
                            ['playtime', '🎮 Playtime'],
                            ['opencall', '📢 Open Call']
                        ] as [MeetingType, string][]).map(([val, label]) => (
                            <button key={val} onClick={() => { setType(val); setStep(2); }} className="rounded-xl border p-3 text-left hover:shadow">
                                {label}
                            </button>
                        ))}
                    </div>
                </section>
            )}

            {step === 2 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">Who would you like to meet with?</div>
                    <input className="w-full rounded-xl border p-3" placeholder="Type a name (mock)"
                        onKeyDown={(e) => {
                            const v = (e.target as HTMLInputElement).value.trim();
                            if (e.key === 'Enter' && v) {
                                setParticipants(p => [...p, v]);
                                (e.target as HTMLInputElement).value = '';
                            }
                        }}
                    />
                    <div className="flex flex-wrap gap-2">
                        {participants.map(p => <span key={p} className="rounded-full border px-3 py-1 text-sm">{p}</span>)}
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(1)} className="rounded-xl border px-4 py-2">← Back</button>
                        <button onClick={() => setStep(3)} className="rounded-xl border px-4 py-2">Next →</button>
                    </div>
                </section>
            )}

            {step === 3 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">When and where?</div>
                    <div className="grid gap-3">
                        <input className="rounded-xl border p-3" placeholder="Date (e.g., 2025-09-01)"
                            value={details.date} onChange={e => setDetails({ ...details, date: e.target.value })} />
                        <input className="rounded-xl border p-3" placeholder="Time (e.g., 17:00)"
                            value={details.time} onChange={e => setDetails({ ...details, time: e.target.value })} />
                        <input className="rounded-xl border p-3" placeholder="Location or Platform (Zoom/Meet/Phone)"
                            value={details.location} onChange={e => setDetails({ ...details, location: e.target.value })} />
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(2)} className="rounded-xl border px-4 py-2">← Back</button>
                        <button onClick={() => setStep(4)} className="rounded-xl border px-4 py-2">Next →</button>
                    </div>
                </section>
            )}

            {step === 4 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">Review</div>
                    <div className="rounded-2xl border p-4">
                        <div>Type: <b>{type}</b></div>
                        <div>Participants: {participants.join(', ') || '—'}</div>
                        <div>Date/Time: {details.date || '—'} {details.time || ''}</div>
                        <div>Location: {details.location || '—'}</div>
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(3)} className="rounded-xl border px-4 py-2">✏️ Edit</button>
                        <button onClick={() => {
                            const meeting: Meeting = {
                                id: 'meeting-' + Math.random().toString(36).slice(2, 9),
                                title: `${type} meeting`,
                                type,
                                details,
                                participants: participants.map((name, i) => ({ id: `p${i}`, name, status: 'pending' as const })),
                                externalLink: '',
                                messages: []
                            };
                            upsertMeeting(meeting);
                            setCreatedMeetingId(meeting.id);
                            setStep(5);
                        }} className="rounded-xl border px-4 py-2">✅ Confirm</button>
                    </div>
                </section>
            )}

            {step === 5 && (
                <section className="space-y-2">
                    <div className="rounded-2xl border p-4">
                        <div className="text-green-700 font-semibold">Meeting saved!</div>
                        <div className="text-sm opacity-70">Your meeting has been created and saved.</div>
                    </div>
                    <div className="flex gap-2">
                        <a href={`/${locale}/meetings`} className="inline-block rounded-xl border px-4 py-2 hover:shadow">Go to Meetings →</a>
                        {createdMeetingId && (
                            <button onClick={() => router.push(`/${locale}/meetings/${createdMeetingId}`)} className="inline-block rounded-xl border px-4 py-2 hover:shadow bg-blue-50">
                                Open Meeting Hub →
                            </button>
                        )}
                    </div>
                </section>
            )}
        </main>
    );
}
