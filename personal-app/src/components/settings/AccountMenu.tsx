"use client";
import { getAuthApi, isFirebaseAvailable } from "@/lib/firebase";
import { useState } from "react";

export function AccountMenu() {
    const [busy, setBusy] = useState(false);
    if (!isFirebaseAvailable()) return <p className="text-sm opacity-70">Firebase disabled (no env).</p>;

    const Auth = getAuthApi();
    return (
        <div className="flex gap-2">
            <button className="px-3 py-2 rounded-xl border" disabled={busy}
                onClick={async () => { setBusy(true); try { await Auth.google(); } finally { setBusy(false); } }}>
                Sign in with Google
            </button>
            <button className="px-3 py-2 rounded-xl border" disabled={busy}
                onClick={async () => { setBusy(true); try { await Auth.signOut(); await Auth.ensureAnon(); } finally { setBusy(false); } }}>
                Sign out
            </button>
        </div>
    );
}
