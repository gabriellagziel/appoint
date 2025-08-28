'use client';
import { useConvo } from '../../stores/useConvo';

export function ConvoSurface() {
    const { step, history, answer } = useConvo();
    return (
        <div className="w-full max-w-xl mx-auto p-4 space-y-3">
            <Transcript items={history} />
            <Question prompt={step.prompt} />
            {step.options?.length ? (
                <OptionRail options={step.options} onSelect={(opt) => answer(opt)} />
            ) : step.input ? (
                <SmartInput type={step.input.type} placeholder={step.input.placeholder} onSubmit={(val) => answer(val)} />
            ) : null}
        </div>
    );
}

function Transcript({ items }: { items: { from: 'system' | 'user'; text: string }[] }) {
    return (
        <div className="space-y-2">
            {items.map((m, i) => (
                <div key={i} className={m.from === 'user' ? 'text-right' : 'text-left'}>
                    <div className={`inline-block px-3 py-2 rounded-2xl shadow ${m.from === 'user' ? 'bg-gray-200' : 'bg-white'}`}>
                        {m.text}
                    </div>
                </div>
            ))}
        </div>
    );
}

function Question({ prompt }: { prompt: string }) {
    return <div className="text-lg font-medium">{prompt}</div>;
}

function OptionRail({ options, onSelect }: { options: { id: string; label: string }[]; onSelect: (o: any) => void }) {
    return (
        <div className="flex flex-wrap gap-2">
            {options.map((o) => (
                <button
                    key={o.id}
                    className="px-3 py-2 rounded-xl border shadow-sm active:scale-95"
                    onClick={() => onSelect(o)}
                >
                    {o.label}
                </button>
            ))}
        </div>
    );
}

function SmartInput({
    type, placeholder, onSubmit,
}: { type: 'text' | 'date' | 'time' | 'people' | 'place'; placeholder?: string; onSubmit: (v: any) => void }) {
    if (type === 'date' || type === 'time') {
        return (
            <form
                onSubmit={(e) => {
                    e.preventDefault();
                    const data = new FormData(e.currentTarget as HTMLFormElement);
                    onSubmit(data.get('val'));
                }}
                className="flex gap-2"
            >
                <input name="val" type={type} placeholder={placeholder} className="flex-1 px-3 py-2 rounded-xl border" />
                <button className="px-3 py-2 rounded-xl border shadow-sm">OK</button>
            </form>
        );
    }
    return (
        <form
            onSubmit={(e) => {
                e.preventDefault();
                const data = new FormData(e.currentTarget as HTMLFormElement);
                onSubmit(data.get('val'));
            }}
            className="flex gap-2"
        >
            <input name="val" type="text" placeholder={placeholder || 'Type…'} className="flex-1 px-3 py-2 rounded-xl border" />
            <button className="px-3 py-2 rounded-xl border shadow-sm">Send</button>
        </form>
    );
}
