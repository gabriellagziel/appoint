'use client';
import { postMessage } from '@/lib/localStore';
import { ChatMessage } from '@/types/meeting';
import { useEffect, useRef, useState } from 'react';

export default function ChatPanel({ meetingId, me = 'Gabriel' }: { meetingId: string; me?: string }) {
    const [msgs, setMsgs] = useState<ChatMessage[]>([]);
    const [input, setInput] = useState('');
    const ref = useRef<HTMLDivElement>(null);

    // A very simple "subscribe" pattern via storage events (demo only)
    useEffect(() => {
        const load = () => {
            try {
                const raw = localStorage.getItem('appoint.personal.meetings.v1');
                if (!raw) return;
                const map = JSON.parse(raw);
                const m = map[meetingId];
                setMsgs(m?.messages ?? []);
                setTimeout(() => ref.current?.scrollTo({ top: 999999, behavior: 'smooth' }), 10);
            } catch { }
        };
        load();
        const onStorage = (e: StorageEvent) => { if (e.key === 'appoint.personal.meetings.v1') load(); };
        window.addEventListener('storage', onStorage);
        const iv = setInterval(load, 1000);
        return () => { window.removeEventListener('storage', onStorage); clearInterval(iv); };
    }, [meetingId]);

    function send() {
        const t = input.trim();
        if (!t) return;
        postMessage(meetingId, me, t);
        setInput('');
        // Force reload our own view too
        const ev = new StorageEvent('storage', { key: 'appoint.personal.meetings.v1' } as any);
        window.dispatchEvent(ev);
    }

    return (
        <div className="rounded-2xl border p-0 overflow-hidden">
            <div ref={ref} className="h-56 overflow-auto p-3 bg-white">
                {msgs.map(m => (
                    <div key={m.id} className="mb-2">
                        <div className="text-xs opacity-60">{new Date(m.at).toLocaleTimeString()}</div>
                        <div><b>{m.author}:</b> {m.text}</div>
                    </div>
                ))}
            </div>
            <div className="border-t p-2 flex gap-2">
                <input
                    value={input}
                    onChange={e => setInput(e.target.value)}
                    onKeyDown={e => e.key === 'Enter' && send()}
                    className="flex-1 rounded-xl border px-3 py-2"
                    placeholder="Write a message…"
                />
                <button onClick={send} className="rounded-xl border px-4 py-2 hover:shadow">Send</button>
            </div>
        </div>
    );
}
