'use client';
import { useParams } from 'next/navigation';
import { useState } from 'react';

type MeetingType = 'personal' | 'group' | 'virtual' | 'business' | 'playtime' | 'opencall';

export default function CreateMeeting() {
    const { locale } = useParams<{ locale: string }>();
    const [step, setStep] = useState<1 | 2 | 3 | 4 | 5>(1);
    const [type, setType] = useState<MeetingType>('personal');
    const [participants, setParticipants] = useState<string[]>([]);
    const [details, setDetails] = useState({ date: '', time: '', location: '', platform: '' });

    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4" dir="rtl">
            <h1 className="text-2xl font-semibold">צור פגישה</h1>
            {step === 1 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">איזה סוג פגישה תרצה ליצור?</div>
                    <div className="grid grid-cols-2 gap-3">
                        {([
                            ['personal', '👤 אישית 1:1'],
                            ['group', '👥 קבוצה / אירוע'],
                            ['virtual', '💻 וירטואלית'],
                            ['business', '🏢 עם עסק'],
                            ['playtime', '🎮 זמן משחק'],
                            ['opencall', '📢 שיחה פתוחה']
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
                    <div className="text-lg font-semibold">עם מי תרצה להיפגש?</div>
                    <input className="w-full rounded-xl border p-3" placeholder="הקלד שם (mock)" onKeyDown={(e) => {
                        const v = (e.target as HTMLInputElement).value.trim();
                        if (e.key === 'Enter' && v) { setParticipants(p => [...p, v]); (e.target as HTMLInputElement).value = ''; }
                    }} />
                    <div className="flex flex-wrap gap-2">
                        {participants.map(p => <span key={p} className="rounded-full border px-3 py-1 text-sm">{p}</span>)}
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(1)} className="rounded-xl border px-4 py-2">← חזור</button>
                        <button onClick={() => setStep(3)} className="rounded-xl border px-4 py-2">המשך →</button>
                    </div>
                </section>
            )}

            {step === 3 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">מתי ואיפה?</div>
                    <div className="grid gap-3">
                        <input className="rounded-xl border p-3" placeholder="תאריך (למשל, 2025-09-01)" value={details.date} onChange={e => setDetails({ ...details, date: e.target.value })} />
                        <input className="rounded-xl border p-3" placeholder="שעה (למשל, 17:00)" value={details.time} onChange={e => setDetails({ ...details, time: e.target.value })} />
                        <input className="rounded-xl border p-3" placeholder="מיקום או פלטפורמה (Zoom/Meet/טלפון)" value={details.location} onChange={e => setDetails({ ...details, location: e.target.value })} />
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(2)} className="rounded-xl border px-4 py-2">← חזור</button>
                        <button onClick={() => setStep(4)} className="rounded-xl border px-4 py-2">המשך →</button>
                    </div>
                </section>
            )}

            {step === 4 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">סקירה</div>
                    <div className="rounded-2xl border p-4">
                        <div>סוג: <b>{type}</b></div>
                        <div>משתתפים: {participants.join(', ') || '—'}</div>
                        <div>תאריך/שעה: {details.date || '—'} {details.time || ''}</div>
                        <div>מיקום: {details.location || '—'}</div>
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(3)} className="rounded-xl border px-4 py-2">✏️ ערוך</button>
                        <button onClick={() => setStep(5)} className="rounded-xl border px-4 py-2">✅ אישור</button>
                    </div>
                </section>
            )}

            {step === 5 && (
                <section className="space-y-2">
                    <div className="rounded-2xl border p-4">
                        <div className="text-green-700 font-semibold">פגישה נשמרה (mock)</div>
                        <div className="text-sm opacity-70">פרימיום: נשמרת מיד. חינמי: יופיע זרם פרסומות.</div>
                    </div>
                    <a href="/he/meetings" className="inline-block rounded-xl border px-4 py-2 hover:shadow">לך לפגישות →</a>
                </section>
            )}
        </main>
    );
}
