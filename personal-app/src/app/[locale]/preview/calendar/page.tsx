"use client";
import CalendarBoard from "@/components/calendar/CalendarBoard";

export default function CalendarPreview() {
    return (
        <main className="p-4">
            <CalendarBoard />
            <p className="text-sm opacity-70 mt-3">
                Drag events to reschedule. Select empty slots to create quick meetings.
            </p>
        </main>
    );
}
