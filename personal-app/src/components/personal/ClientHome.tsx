'use client';
import { useConvo } from '../../stores/useConvo';
import { ConvoSurface } from '../convo/ConvoSurface';

export default function ClientHome() {
    const { startIntent } = useConvo();

    return (
        <div className="space-y-6">
            <section>
                <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
                    <QuickAction label="➕ Meeting" onClick={() => startIntent('meeting')} />
                    <QuickAction label="⏰ Reminder" onClick={() => startIntent('reminder')} />
                    <QuickAction label="🎮 Playtime" onClick={() => startIntent('playtime')} />
                    <QuickAction label="👥 Groups" onClick={() => startIntent('groups')} />
                    <QuickAction label="👨‍👩‍👧 Family" onClick={() => startIntent('family')} />
                </div>
            </section>

            <section className="border-t pt-6">
                <ConvoSurface />
            </section>
        </div>
    );
}

function QuickAction({ label, onClick }: { label: string; onClick: () => void }) {
    return (
        <button
            onClick={onClick}
            className="aspect-video rounded-2xl border shadow-sm p-3 text-left active:scale-95 hover:shadow-md transition-shadow"
        >
            <div className="text-base font-medium">{label}</div>
        </button>
    );
}
