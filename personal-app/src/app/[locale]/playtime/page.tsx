export default function PlaytimePage() {
    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4">
            <h1 className="text-2xl font-semibold">Playtime</h1>
            <div className="grid gap-3">
                <button className="rounded-xl border p-3 text-left hover:shadow">🏀 Create Physical Playtime</button>
                <button className="rounded-xl border p-3 text-left hover:shadow">🎮 Create Virtual Session</button>
            </div>
            <div className="rounded-2xl border p-4">
                <div className="font-semibold mb-1">Organize games like meetings</div>
                <div className="text-sm opacity-70">Playtime events are managed similarly to meetings with tailored UI.</div>
            </div>
        </main>
    );
}

