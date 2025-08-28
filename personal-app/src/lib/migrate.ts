import { FS } from "@/lib/fs";
import type { Meeting, Reminder } from "@/lib/models";

const LS = {
    meetings: "appoint.meetings",
    reminders: "appoint.reminders",
};

export async function migrateLocalToCloud(uid: string) {
    if (typeof window === "undefined") return;
    const flag = `appoint.migrated.${uid}`;
    if (localStorage.getItem(flag) === "1") return;

    const meetings: Meeting[] = JSON.parse(localStorage.getItem(LS.meetings) || "[]");
    const reminders: Reminder[] = JSON.parse(localStorage.getItem(LS.reminders) || "[]");

    for (const m of meetings) await FS.upsertMeeting(m, uid).catch(() => { });
    for (const r of reminders) await FS.upsertReminder(r, uid).catch(() => { });

    localStorage.setItem(flag, "1");
}
