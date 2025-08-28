"use client";
import { MeetingsList } from "@/components/meetings/MeetingsList";
import { AccountMenu } from "@/components/settings/AccountMenu";
import { getAuthApi, isFirebaseAvailable } from "@/lib/firebase";
import { FS } from "@/lib/fs";

export default function PersistencePreview() {
    const createDemo = async () => {
        if (!isFirebaseAvailable()) return;
        const Auth = getAuthApi();
        const u = await Auth.ensureAnon();
        await FS.upsertMeeting({ type: "video", title: "Demo RT", startsAt: Date.now() + 600000 }, u.uid);
    };
    return (
        <main className="p-4 max-w-xl mx-auto space-y-4">
            <h2 className="text-lg font-semibold">Persistence Preview</h2>
            <AccountMenu />
            <button className="px-3 py-2 rounded-xl border" onClick={createDemo} disabled={!isFirebaseAvailable()}>
                Create demo meeting
            </button>
            <MeetingsList />
            <p className="text-sm opacity-70">Open in two tabs to see real-time updates.</p>
        </main>
    );
}
