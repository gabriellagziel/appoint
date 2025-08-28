"use client";
import { getAuthApi, isFirebaseAvailable } from "@/lib/firebase";
import { FS } from "@/lib/fs";
import type { Meeting } from "@/lib/models";
import { useEffect, useState } from "react";

export function MeetingsList() {
    const [rows, setRows] = useState<Meeting[]>([]);
    useEffect(() => {
        if (!isFirebaseAvailable()) return;
        let unsub: any;
        (async () => {
            const Auth = getAuthApi();
            const u = await Auth.ensureAnon();
            if (!u?.uid) return;
            unsub = FS.onMeetingsByUser(u.uid, setRows);
        })();
        return () => unsub?.();
    }, []);
    if (!isFirebaseAvailable()) return <p className="text-sm opacity-70">No Firestore (env missing).</p>;
    return (
        <ul className="list-disc pl-5">
            {rows.map((m) => (
                <li key={m.id}>{m.title || m.type} — {new Date(m.startsAt).toLocaleString()}</li>
            ))}
        </ul>
    );
}
