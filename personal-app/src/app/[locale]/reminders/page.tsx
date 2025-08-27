import Link from 'next/link';

export default function RemindersPage() {
    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4">
            <h1 className="text-2xl font-semibold">Reminders</h1>
            <div className="grid gap-3">
                <button className="rounded-xl border p-3 text-left hover:shadow">⏰ Create Reminder</button>
                <button className="rounded-xl border p-3 text-left hover:shadow">🔁 Recurrence Options</button>
                <button className="rounded-xl border p-3 text-left hover:shadow">🔗 Link to a Meeting</button>
            </div>
            <div className="rounded-2xl border p-4">
                <div className="font-semibold mb-1">Coming soon</div>
                <div className="text-sm opacity-70">This section will manage personal and family reminders.</div>
            </div>
            <Link href="../home" className="inline-block rounded-xl border px-4 py-2 hover:shadow">← Back to Home</Link>
        </main>
    );
}

