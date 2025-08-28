import type { Meeting } from '@/lib/models';
import { create } from 'zustand';

export type ConvoOption = { id: string; label: string; value?: any };
export type ConvoInputType = 'text' | 'date' | 'time' | 'people' | 'place';

export interface ConvoStep {
    id: string;
    prompt: string;
    options?: ConvoOption[];
    input?: { type: ConvoInputType; placeholder?: string };
}

interface ConvoState {
    step: ConvoStep;
    history: Array<{ from: 'system' | 'user'; text: string }>;
    meetingType: string;
    meetingDate: string;
    meetingTime: string;
    meetingLocation: string;
    draftMeeting?: Meeting | null;

    // NEW temp fields for edit (optional)
    editDate?: string | null; // "YYYY-MM-DD"
    editTime?: string | null; // "HH:mm"
    editAllDay?: boolean;     // all-day toggle

    startIntent: (intent: 'meeting' | 'reminder' | 'playtime' | 'groups' | 'family') => void;
    setDraftMeeting: (m: Meeting | null) => void;
    startEditMeeting: (m: Meeting) => void;
    answer: (value: any) => void;
    reset: () => void;
}

// Helper function for merging date and time inputs into epoch timestamp
function mergeDateTimeToEpoch(d?: string | null, t?: string | null, fallbackMs?: number) {
    if (!d && !t) return fallbackMs ?? Date.now();
    // If only one provided, merge with the other from fallback
    const base = new Date(fallbackMs ?? Date.now());
    const [Y, M, D] = (d ? d.split("-").map(n => parseInt(n, 10)) : [base.getFullYear(), base.getMonth() + 1, base.getDate()]);
    const [h, m] = (t ? t.split(":").map(n => parseInt(n, 10)) : [base.getHours(), base.getMinutes()]);
    return new Date(Y, (M - 1), D, h, m, 0, 0).getTime();
}

const initialStep: ConvoStep = {
    id: 'intent',
    prompt: 'Hi Gabriel 👋 What would you like to do today?',
    options: [
        { id: 'meeting', label: '➕ New Meeting' },
        { id: 'reminder', label: '⏰ Reminder' },
        { id: 'playtime', label: '🎮 Playtime' },
        { id: 'groups', label: '👥 Groups' },
        { id: 'family', label: '👨‍👩‍👧 Family' },
    ],
};

export const useConvo = create<ConvoState>((set, get) => ({
    step: initialStep,
    history: [{ from: 'system', text: initialStep.prompt }],
    meetingType: '',
    meetingDate: '',
    meetingTime: '',
    meetingLocation: '',
    draftMeeting: null,
    editDate: null,
    editTime: null,
    editAllDay: false,
    setDraftMeeting: (m) => set({ draftMeeting: m }),
    startEditMeeting: (m) => {
        set({
            draftMeeting: m,
            editDate: null,
            editTime: null,
            editAllDay: !!m.allDay,
        });
        // Kick conversational edit flow:
        set({
            step: {
                id: "meeting.edit.title",
                prompt: `Editing "${m.title || "Untitled"}". Change the title?`,
                options: [
                    { id: "keep", label: "Keep title" },
                    { id: "change", label: "Change title" },
                    { id: "delete", label: "Delete meeting" },
                ],
            },
            history: [...get().history, { from: "system", text: "Opened edit for a meeting." }],
        });
    },
    startIntent: (intent) => {
        // For PR-1 we route only Meeting intent into existing meeting flow scaffolding.
        if (intent === 'meeting') {
            set({
                step: {
                    id: 'meeting.type',
                    prompt: 'What kind of meeting is it?',
                    options: [
                        { id: 'inperson', label: 'In-person' },
                        { id: 'video', label: 'Video call' },
                        { id: 'phone', label: 'Phone call' },
                    ],
                },
                history: [...get().history, { from: 'user', text: 'New Meeting' }],
            });
        } else {
            set({
                history: [...get().history, { from: 'user', text: intent }],
                step: {
                    id: `${intent}.comingSoon`,
                    prompt: 'This flow is coming soon. Want to create a meeting instead?',
                    options: [{ id: 'go.meeting', label: 'Create a meeting' }],
                },
            });
        }
    },
    answer: async (value) => {
        const { step, history } = get();
        // Minimal PR-1 state machine:
        if (step.id === 'meeting.type') {
            set({
                history: [...history, { from: 'user', text: String(value?.label ?? value) }],
                step: {
                    id: 'meeting.when',
                    prompt: 'When would you like to meet?',
                    input: { type: 'date', placeholder: 'Pick a date' },
                },
                meetingType: value?.id || String(value),
            });
            return;
        }
        if (step.id === 'meeting.when') {
            set({
                history: [...history, { from: 'user', text: String(value) }],
                step: {
                    id: 'meeting.time',
                    prompt: 'What time?',
                    input: { type: 'time', placeholder: 'Choose a time' },
                },
                meetingDate: String(value),
            });
            return;
        }
        if (step.id === 'meeting.time') {
            set({
                history: [...history, { from: 'user', text: String(value) }],
                step: {
                    id: 'meeting.where',
                    prompt: 'Where would you like to meet?',
                    input: { type: 'text', placeholder: 'Address, Zoom, or Phone' },
                },
                meetingTime: String(value),
            });
            return;
        }
        if (step.id === 'meeting.where') {
            set({
                history: [...history, { from: 'user', text: String(value) }],
                step: {
                    id: 'meeting.confirm',
                    prompt: 'Looks good. Create this meeting?',
                    options: [
                        { id: 'yes', label: 'Create' },
                        { id: 'no', label: 'Cancel' },
                    ],
                },
                meetingLocation: String(value),
            });
            return;
        }
        if (step.id === 'meeting.confirm') {
            if (value?.id === 'yes') {
                // Try Firestore first, fallback to localStorage
                try {
                    const { isFirebaseAvailable, getAuthApi } = await import('@/lib/firebase');
                    const { FS } = await import('@/lib/fs');

                    if (isFirebaseAvailable()) {
                        const Auth = getAuthApi();
                        const u = await Auth.ensureAnon();
                        if (u?.uid) {
                            const meetingData = {
                                type: (get().meetingType as "inperson" | "video" | "phone") || 'inperson',
                                startsAt: new Date(get().meetingDate + 'T' + get().meetingTime).getTime(),
                                title: `${get().meetingType || 'inperson'} meeting`,
                                participants: [],
                                placeId: get().meetingLocation || '',
                            };

                            await FS.upsertMeeting(meetingData, u.uid);
                            set({
                                history: [...history, { from: 'user', text: 'Create' }, { from: 'system', text: '✅ Meeting created and saved to cloud!' }],
                                step: initialStep,
                            });
                            return;
                        }
                    }
                } catch (error) {
                    console.warn('Firestore failed, falling back to localStorage:', error);
                }

                // Fallback to localStorage (existing behavior)
                const meetings = JSON.parse(localStorage.getItem('appoint.meetings') || '[]');
                const newMeeting = {
                    id: crypto.randomUUID(),
                    type: get().meetingType || 'inperson',
                    startsAt: new Date(get().meetingDate + 'T' + get().meetingTime).getTime(),
                    title: `${get().meetingType || 'inperson'} meeting`,
                    participants: [],
                    placeId: get().meetingLocation || '',
                    createdAt: Date.now(),
                    updatedAt: Date.now(),
                };
                meetings.push(newMeeting);
                localStorage.setItem('appoint.meetings', JSON.stringify(meetings));

                set({
                    history: [...history, { from: 'user', text: 'Create' }, { from: 'system', text: '✅ Meeting created and saved locally!' }],
                    step: initialStep,
                });
            } else {
                set({
                    history: [...history, { from: 'user', text: 'Cancel' }, { from: 'system', text: '❎ Canceled.' }],
                    step: initialStep,
                });
            }
            return;
        }
        if (step.id.endsWith('.comingSoon') && value?.id === 'go.meeting') {
            get().startIntent('meeting');
            return;
        }

        // Edit: title choice
        if (step.id === "meeting.edit.title") {
            const draftMeeting = get().draftMeeting;
            if (!draftMeeting) return set({ step: initialStep });

            if (value?.id === "delete") {
                // soft-confirm
                set({
                    step: {
                        id: "meeting.edit.delete.confirm",
                        prompt: "Delete this meeting?",
                        options: [{ id: "yes", label: "Delete" }, { id: "no", label: "Cancel" }],
                    },
                    history: [...history, { from: "user", text: value.label }],
                });
                return;
            }
            if (value?.id === "change") {
                set({
                    step: {
                        id: "meeting.edit.title.input",
                        prompt: "New title?",
                        input: { type: "text", placeholder: draftMeeting.title || "Title" },
                    },
                    history: [...history, { from: "user", text: "Change title" }],
                });
                return;
            }
            // keep
            set({
                step: {
                    id: "meeting.edit.date",
                    prompt: "Change the date?",
                    input: { type: "date" },
                },
                history: [...history, { from: "user", text: "Keep title" }],
            });
            return;
        }

        // Title input
        if (step.id === "meeting.edit.title.input") {
            const title = String(value ?? "").trim();
            const currentDraft = get().draftMeeting;
            if (!currentDraft) return;

            set({
                draftMeeting: { ...currentDraft, title },
                step: { id: "meeting.edit.date", prompt: "Change the date?", input: { type: "date" } },
                history: [...history, { from: "user", text: title || "(empty)" }],
            });
            return;
        }

        // Date input → ask all-day
        if (step.id === "meeting.edit.date") {
            set({
                editDate: value ? String(value) : null,
                history: [...history, { from: "user", text: String(value || "no change") }],
                step: {
                    id: "meeting.edit.allDay",
                    prompt: "Is this an all-day meeting?",
                    options: [{ id: "allday_yes", label: "All-day" }, { id: "allday_no", label: "Timed" }],
                }
            });
            return;
        }

        // All-day choice → ask time if needed
        if (step.id === "meeting.edit.allDay") {
            const allDay = value?.id === "allday_yes";
            set({ editAllDay: allDay });
            if (allDay) {
                set({
                    step: { id: "meeting.edit.confirm", prompt: "Save changes?", options: [{ id: "yes", label: "Save" }, { id: "no", label: "Cancel" }] },
                    history: [...history, { from: "user", text: allDay ? "All-day" : "Timed" }],
                });
                return;
            }
            set({
                step: { id: "meeting.edit.time", prompt: "What time?", input: { type: "time" } },
                history: [...history, { from: "user", text: "Timed" }],
            });
            return;
        }

        // Time input → confirm save
        if (step.id === "meeting.edit.time") {
            set({
                editTime: value ? String(value) : null,
                history: [...history, { from: "user", text: String(value || "no change") }],
                step: {
                    id: "meeting.edit.confirm",
                    prompt: "Save changes?",
                    options: [{ id: "yes", label: "Save" }, { id: "no", label: "Cancel" }],
                },
            });
            return;
        }

        // Delete confirm
        if (step.id === "meeting.edit.delete.confirm") {
            if (value?.id === "yes") {
                const currentDraft = get().draftMeeting;
                if (currentDraft?.id) {
                    const { isFirebaseAvailable, getAuthApi } = await import("@/lib/firebase").then(m => ({
                        isFirebaseAvailable: m.isFirebaseAvailable, getAuthApi: m.getAuthApi
                    }));
                    const { FS } = await import("@/lib/fs");
                    try {
                        if (isFirebaseAvailable()) await FS.deleteMeeting(currentDraft.id);
                        // else: optional local fallback
                    } catch { }
                    set({
                        history: [...history, { from: "user", text: "Delete" }, { from: "system", text: "🗑️ Meeting deleted." }],
                        draftMeeting: null,
                        step: { id: "intent", prompt: "What would you like to do next?" },
                    });
                    return;
                }
            }
            // cancel delete
            set({
                history: [...history, { from: "user", text: "Cancel" }, { from: "system", text: "❎ Canceled." }],
                step: { id: "intent", prompt: "What would you like to do next?" },
                draftMeeting: null,
            });
            return;
        }

        // Save confirm
        if (step.id === "meeting.edit.confirm") {
            if (value?.id !== "yes" || !get().draftMeeting) {
                set({
                    history: [...history, { from: "user", text: "Cancel" }, { from: "system", text: "❎ Canceled." }],
                    draftMeeting: null, editDate: null, editTime: null, editAllDay: false,
                    step: { id: "intent", prompt: "What would you like to do next?" },
                });
                return;
            }

            try {
                const { isFirebaseAvailable, getAuthApi } = await import("@/lib/firebase").then(m => ({
                    isFirebaseAvailable: m.isFirebaseAvailable, getAuthApi: m.getAuthApi
                }));
                const { FS } = await import("@/lib/fs");

                if (isFirebaseAvailable()) {
                    const Auth = getAuthApi();
                    const u = await Auth.ensureAnon();
                    const currentDraft = get().draftMeeting;
                    if (!currentDraft?.id) return;

                    // Title update if changed
                    if (currentDraft.title && currentDraft.title !== (await FS.getMeeting(currentDraft.id))?.title) {
                        await FS.updateMeetingTitle(currentDraft.id, currentDraft.title);
                    }

                    // Time update if date/time/allDay changed
                    if (get().editDate !== null || get().editTime !== null || typeof get().editAllDay === "boolean") {
                        const current = await FS.getMeeting(currentDraft.id);
                        const startMs = mergeDateTimeToEpoch(get().editDate, get().editTime, current?.startsAt ?? currentDraft.startsAt);
                        const endMs = current?.endsAt ?? (startMs + 60 * 60 * 1000);
                        await FS.updateMeetingTimes(currentDraft.id, startMs, endMs, get().editAllDay ?? current?.allDay);
                    }
                }
                set({
                    history: [...history, { from: "user", text: "Save" }, { from: "system", text: "✅ Changes saved." }],
                    draftMeeting: null, editDate: null, editTime: null, editAllDay: false,
                    step: { id: "intent", prompt: "What would you like to do next?" },
                });
            } catch {
                set({
                    history: [...history, { from: "system", text: "⚠️ Couldn't save—please retry." }],
                });
            }
            return;
        }
    },
    reset: () => set({
        step: initialStep,
        history: [{ from: 'system', text: initialStep.prompt }],
        meetingType: '',
        meetingDate: '',
        meetingTime: '',
        meetingLocation: '',
        draftMeeting: null, editDate: null, editTime: null, editAllDay: false,
    }),
}));
