export type Id = string;
export type TS = number; // ms epoch

export type Meeting = {
    id: Id;
    createdBy: Id;
    type: "inperson" | "video" | "phone";
    title?: string;
    startsAt: TS;
    endsAt?: TS;
    allDay?: boolean; // NEW
    placeId?: string;
    participants?: string[];
    lang?: string;
    createdAt: TS;
    updatedAt: TS;
};

export type Reminder = {
    id: Id;
    createdBy: Id;
    text: string;
    dueAt?: TS;
    done?: boolean;
    recurrence?: string;
    createdAt: TS;
    updatedAt: TS;
};

export type Group = {
    id: Id; createdBy: Id; name: string; members: string[];
    createdAt: TS; updatedAt: TS;
};

export type Family = {
    id: Id; createdBy: Id; members: Array<{ name: string; role?: string; }>;
    createdAt: TS; updatedAt: TS;
};
