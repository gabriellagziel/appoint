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
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4">
            <h1 className="text-2xl font-semibold">Crea una Riunione</h1>
            {step === 1 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">Che tipo di riunione vuoi creare?</div>
                    <div className="grid grid-cols-2 gap-3">
                        {([
                            ['personal', '👤 Personale 1:1'],
                            ['group', '👥 Gruppo / Evento'],
                            ['virtual', '💻 Virtuale'],
                            ['business', '🏢 Con un Business'],
                            ['playtime', '🎮 Tempo di Gioco'],
                            ['opencall', '📢 Chiamata Aperta']
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
                    <div className="text-lg font-semibold">Con chi vorresti incontrarti?</div>
                    <input className="w-full rounded-xl border p-3" placeholder="Scrivi un nome (mock)" onKeyDown={(e) => {
                        const v = (e.target as HTMLInputElement).value.trim();
                        if (e.key === 'Enter' && v) { setParticipants(p => [...p, v]); (e.target as HTMLInputElement).value = ''; }
                    }} />
                    <div className="flex flex-wrap gap-2">
                        {participants.map(p => <span key={p} className="rounded-full border px-3 py-1 text-sm">{p}</span>)}
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(1)} className="rounded-xl border px-4 py-2">← Indietro</button>
                        <button onClick={() => setStep(3)} className="rounded-xl border px-4 py-2">Avanti →</button>
                    </div>
                </section>
            )}

            {step === 3 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">Quando e dove?</div>
                    <div className="grid gap-3">
                        <input className="rounded-xl border p-3" placeholder="Data (es., 2025-09-01)" value={details.date} onChange={e => setDetails({ ...details, date: e.target.value })} />
                        <input className="rounded-xl border p-3" placeholder="Ora (es., 17:00)" value={details.time} onChange={e => setDetails({ ...details, time: e.target.value })} />
                        <input className="rounded-xl border p-3" placeholder="Luogo o Piattaforma (Zoom/Meet/Telefono)" value={details.location} onChange={e => setDetails({ ...details, location: e.target.value })} />
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(2)} className="rounded-xl border px-4 py-2">← Indietro</button>
                        <button onClick={() => setStep(4)} className="rounded-xl border px-4 py-2">Avanti →</button>
                    </div>
                </section>
            )}

            {step === 4 && (
                <section className="space-y-3">
                    <div className="text-lg font-semibold">Rivedi</div>
                    <div className="rounded-2xl border p-4">
                        <div>Tipo: <b>{type}</b></div>
                        <div>Partecipanti: {participants.join(', ') || '—'}</div>
                        <div>Data/Ora: {details.date || '—'} {details.time || ''}</div>
                        <div>Luogo: {details.location || '—'}</div>
                    </div>
                    <div className="flex gap-3">
                        <button onClick={() => setStep(3)} className="rounded-xl border px-4 py-2">✏️ Modifica</button>
                        <button onClick={() => setStep(5)} className="rounded-xl border px-4 py-2">✅ Conferma</button>
                    </div>
                </section>
            )}

            {step === 5 && (
                <section className="space-y-2">
                    <div className="rounded-2xl border p-4">
                        <div className="text-green-700 font-semibold">Riunione salvata (mock)</div>
                        <div className="text-sm opacity-70">Premium: salvata istantaneamente. Gratuito: apparirebbe il flusso pubblicitario.</div>
                    </div>
                    <a href="/it/meetings" className="inline-block rounded-xl border px-4 py-2 hover:shadow">Vai alle Riunioni →</a>
                </section>
            )}
        </main>
    );
}
