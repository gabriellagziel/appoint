"use client";
import { getAuthApi, isFirebaseAvailable } from "@/lib/firebase";
import { FS } from "@/lib/fs";
import type { Meeting } from "@/lib/models";
import { useConvo } from "@/stores/useConvo";
import { format, getDay, parse, startOfWeek } from "date-fns";
import { enUS, it } from "date-fns/locale";
import { useEffect, useMemo, useRef, useState } from "react";
import { Calendar, dateFnsLocalizer, Views } from "react-big-calendar";
import withDragAndDrop from "react-big-calendar/lib/addons/dragAndDrop";

const DnDCalendar = withDragAndDrop(Calendar);

const locales = { en: enUS, it };
const makeLocalizer = (locale: string) =>
    dateFnsLocalizer({ format, parse, startOfWeek, getDay, locales });

type Ev = { id: string; title: string; start: Date; end: Date; meta: Meeting };

const startAccessor = (event: any) => (event as Ev).start;
const endAccessor = (event: any) => (event as Ev).end;

// Custom event chip with inline delete
function EventChip({ event, onDelete }: { event: Ev; onDelete: (e: Ev) => void }) {
    return (
        <div className="flex items-center gap-2">
            <span className="truncate">{event.title}</span>
            <button
                aria-label="Delete"
                className="ml-auto text-xs px-2 py-0.5 rounded border opacity-70 hover:opacity-100"
                onClick={(e) => { e.stopPropagation(); onDelete(event); }}
            >×</button>
        </div>
    );
}

// Custom toolbar with basic RTL alignment
function Toolbar({ label, onNavigate, onView, rtl }: {
    label: string; onNavigate: (action: "TODAY" | "PREV" | "NEXT") => void;
    onView: (v: any) => void; rtl: boolean;
}) {
    return (
        <div className={`flex items-center justify-between mb-2 ${rtl ? "flex-row-reverse" : ""}`}>
            <div className="flex gap-2">
                <button className="px-2 py-1 rounded border" onClick={() => onNavigate("TODAY")}>Today</button>
                <button className="px-2 py-1 rounded border" onClick={() => onNavigate("PREV")}>{rtl ? "▶" : "◀"}</button>
                <button className="px-2 py-1 rounded border" onClick={() => onNavigate("NEXT")}>{rtl ? "◀" : "▶"}</button>
            </div>
            <div className="font-semibold">{label}</div>
            <div className="flex gap-2">
                {["month", "week", "day", "agenda"].map(v => (
                    <button key={v} className="px-2 py-1 rounded border" onClick={() => onView(v)}>{v}</button>
                ))}
            </div>
        </div>
    );
}

// Simple Undo snackbar
function UndoToast({ visible, msg, onUndo }: { visible: boolean; msg: string; onUndo: () => void }) {
    if (!visible) return null;
    return (
        <div className="fixed bottom-4 left-1/2 -translate-x-1/2 bg-black text-white rounded-xl px-4 py-2 shadow-lg">
            <span className="mr-3">{msg}</span>
            <button className="underline" onClick={onUndo}>Undo</button>
        </div>
    );
}

export default function CalendarBoard({ locale = "en" }: { locale?: string }) {
    const [events, setEvents] = useState<Ev[]>([]);
    const [loading, setLoading] = useState(true);
    const [toast, setToast] = useState<{ visible: boolean; payload?: Meeting }>({ visible: false });
    const toastTimer = useRef<number | null>(null);
    const convo = useConvo();

    const localizer = useMemo(() => makeLocalizer(locale), [locale]);

    useEffect(() => {
        let unsub: undefined | (() => void);
        (async () => {
            if (!isFirebaseAvailable()) { setLoading(false); return; }
            const Auth = getAuthApi();
            const u = await Auth.ensureAnon();
            if (!u?.uid) { setLoading(false); return; }
            unsub = FS.onMeetingsByUser(u.uid, (rows) => {
                const mapped = rows.map((m) => ({
                    id: m.id,
                    title: m.title || labelForType(m.type),
                    start: new Date(m.startsAt),
                    end: new Date(m.endsAt ?? (m.startsAt + 60 * 60 * 1000)),
                    meta: m,
                }));
                setEvents(mapped);
                setLoading(false);
            });
        })();
        return () => unsub?.();
    }, []);

    const onEventDrop = async ({ event, start, end }: any) => {
        if (!isFirebaseAvailable()) return;
        await FS.updateMeetingTimes(event.id, +start, +end, event.meta?.allDay);
    };

    const onEventResize = async ({ event, start, end }: any) => {
        if (!isFirebaseAvailable()) return;
        await FS.updateMeetingTimes(event.id, +start, +end, event.meta?.allDay);
    };

    const onSelectSlot = async ({ start, end, action }: any) => {
        const dur = +end - +start;
        const allDay = dur >= 24 * 60 * 60 * 1000 - 1 || action === "select";
        convo.startIntent("meeting");
        if (!isFirebaseAvailable()) return;
        const Auth = getAuthApi();
        const u = await Auth.ensureAnon();
        await FS.upsertMeeting(
            {
                type: "video" as Meeting["type"],
                title: allDay ? "All-day meeting" : "Quick meeting",
                startsAt: +start,
                endsAt: +end,
                allDay,
            },
            u.uid,
        );
    };

    const onSelectEvent = (event: any, e: React.SyntheticEvent) => {
        const ev = event as Ev;
        console.log('📊 calendar_event_edit', { eventId: ev.id, title: ev.title, type: ev.meta.type });
        convo.startEditMeeting(ev.meta);
    };

    // delete with undo
    const requestDelete = async (ev: Ev) => {
        if (!isFirebaseAvailable()) return;
        setToast({ visible: true, payload: ev.meta });
        console.log('📊 calendar_event_delete', { eventId: ev.id, title: ev.title });
        window.clearTimeout(toastTimer.current as any);
        toastTimer.current = window.setTimeout(async () => {
            try { await FS.deleteMeeting(ev.id); } finally { setToast({ visible: false }); }
        }, 10000); // 10s undo window
    };

    const undoDelete = async () => {
        if (!isFirebaseAvailable()) { setToast({ visible: false }); return; }
        window.clearTimeout(toastTimer.current as any);
        if (toast.payload) {
            await FS.restoreMeeting(toast.payload);
            console.log('📊 undo_delete', { eventId: toast.payload.id, title: toast.payload.title });
        }
        setToast({ visible: false, payload: undefined });
    };

    const rtl = false; // or rtlDetector(locale) if you have it

    return (
        <div className="w-full max-w-5xl mx-auto p-3">
            <div className="flex items-center justify-between mb-2">
                <h2 className="text-lg font-semibold">Calendar</h2>
                {loading ? <span className="text-sm opacity-70">Loading…</span> : null}
            </div>
            <DnDCalendar
                localizer={localizer}
                events={events}
                defaultView={Views.WEEK}
                views={[Views.MONTH, Views.WEEK, Views.DAY, Views.AGENDA]}
                startAccessor={startAccessor}
                endAccessor={endAccessor}
                selectable
                resizable
                onEventDrop={onEventDrop}
                onEventResize={onEventResize}
                onSelectSlot={onSelectSlot}
                onSelectEvent={onSelectEvent}
                style={{ height: "calc(100dvh - 180px)" }}
                components={{
                    toolbar: (props: any) => (
                        <Toolbar
                            label={props.label}
                            onNavigate={props.onNavigate}
                            onView={props.onView}
                            rtl={rtl}
                        />
                    ),
                    event: (props: any) => (
                        <EventChip event={props.event as Ev} onDelete={requestDelete} />
                    ),
                }}
            />

            <UndoToast visible={toast.visible} msg="Meeting deleted" onUndo={undoDelete} />
        </div>
    );
}

function labelForType(t: Meeting["type"]) {
    if (t === "inperson") return "In-person";
    if (t === "phone") return "Phone";
    return "Video call";
}
