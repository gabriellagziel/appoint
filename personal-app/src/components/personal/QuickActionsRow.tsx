'use client';
export default function QuickActionsRow({ onLate, onGo, onArrived }: {
    onLate: () => void; onGo: () => void; onArrived: () => void;
}) {
    return (
        <div className="grid grid-cols-3 gap-3">
            <button onClick={onLate} className="rounded-xl border p-3 hover:shadow">🚶 I'm Late</button>
            <button onClick={onGo} className="rounded-xl border p-3 hover:shadow">📍 Go / Join</button>
            <button onClick={onArrived} className="rounded-xl border p-3 hover:shadow">✅ I've Arrived</button>
        </div>
    );
}
