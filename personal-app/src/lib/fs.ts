import { getDb } from "@/lib/firebase";
import { collection, deleteDoc, doc, getDoc, onSnapshot, query, setDoc, updateDoc, where } from "firebase/firestore";
import type { Id, Meeting, Reminder } from "./models";

const now = () => Date.now();

const cols = {
    meetings: () => collection(getDb()!, "meetings"),
    reminders: () => collection(getDb()!, "reminders"),
};

export const FS = {
    // Write guards: call only if db is defined
    upsertMeeting: async (m: Partial<Meeting>, uid: Id) => {
        const id = m.id ?? crypto.randomUUID();
        const data: Meeting = {
            id,
            createdBy: uid,
            type: (m.type as any) ?? "video",
            title: m.title ?? "",
            startsAt: m.startsAt ?? now() + 3_600_000,
            endsAt: m.endsAt,
            allDay: m.allDay ?? false,
            placeId: m.placeId,
            participants: m.participants ?? [],
            lang: m.lang,
            createdAt: (m.createdAt as number) ?? now(),
            updatedAt: now(),
        };
        await setDoc(doc(cols.meetings(), id), data);
        return data;
    },

    upsertReminder: async (r: Partial<Reminder>, uid: Id) => {
        const id = r.id ?? crypto.randomUUID();
        const data: Reminder = {
            id,
            createdBy: uid,
            text: r.text ?? "",
            dueAt: r.dueAt,
            done: r.done ?? false,
            recurrence: r.recurrence,
            createdAt: (r.createdAt as number) ?? now(),
            updatedAt: now(),
        };
        await setDoc(doc(cols.reminders(), id), data);
        return data;
    },

    onMeetingsByUser: (uid: Id, cb: (rows: Meeting[]) => void) => {
        const q = query(cols.meetings(), where("createdBy", "==", uid));
        return onSnapshot(q, (snap) => cb(snap.docs.map((d) => d.data() as Meeting)));
    },

    onRemindersByUser: (uid: Id, cb: (rows: Reminder[]) => void) => {
        const q = query(cols.reminders(), where("createdBy", "==", uid));
        return onSnapshot(q, (snap) => cb(snap.docs.map((d) => d.data() as Reminder)));
    },

    updateMeetingTimes: async (id: string, startsAt: number, endsAt?: number, allDay?: boolean) => {
        const db = getDb();
        if (!db) return;
        await updateDoc(doc(db, "meetings", id), {
            startsAt, endsAt: endsAt ?? null, allDay: !!allDay, updatedAt: Date.now(),
        });
    },

    deleteMeeting: async (id: string) => {
        const db = getDb();
        if (!db) return;
        await deleteDoc(doc(db, "meetings", id));
    },

    updateMeetingTitle: async (id: string, title: string) => {
        const db = getDb();
        if (!db) return;
        await updateDoc(doc(db, "meetings", id), { title, updatedAt: Date.now() });
    },

    // lightweight restore (used by Undo)
    restoreMeeting: async (payload: Meeting) => {
        const db = getDb();
        if (!db) return;
        await setDoc(doc(db, "meetings", payload.id), { ...payload, updatedAt: Date.now() });
    },

    // convenience getter (optional)
    getMeeting: async (id: string) => {
        const db = getDb();
        if (!db) return undefined;
        const snap = await getDoc(doc(db, "meetings", id));
        return snap.exists() ? (snap.data() as Meeting) : undefined;
    },
};
