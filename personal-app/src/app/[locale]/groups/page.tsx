export default function GroupsPage() {
    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-4">
            <h1 className="text-2xl font-semibold">Groups</h1>
            <div className="grid gap-3">
                <button className="rounded-xl border p-3 text-left hover:shadow">👥 Create a Group</button>
                <button className="rounded-xl border p-3 text-left hover:shadow">🔗 Generate Invite Link</button>
                <button className="rounded-xl border p-3 text-left hover:shadow">📅 Group Events</button>
            </div>
            <div className="rounded-2xl border p-4">
                <div className="font-semibold mb-1">Coming soon</div>
                <div className="text-sm opacity-70">Links shared externally will let people join groups.</div>
            </div>
        </main>
    );
}

