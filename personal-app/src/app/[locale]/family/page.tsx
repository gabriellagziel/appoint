export default function FamilyPage() {
    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4">
            <h1 className="text-2xl font-semibold">Family</h1>
            <div className="grid gap-3">
                <button className="rounded-xl border p-3 text-left hover:shadow">👨‍👩‍👧 Link Child Account</button>
                <button className="rounded-xl border p-3 text-left hover:shadow">⏰ Shared Reminders</button>
                <button className="rounded-xl border p-3 text-left hover:shadow">📅 Family Calendar</button>
            </div>
            <div className="rounded-2xl border p-4">
                <div className="font-semibold mb-1">Kids are always free</div>
                <div className="text-sm opacity-70">Under 18 accounts do not see ads.</div>
            </div>
        </main>
    );
}

