export type MeetingType = 'personal' | 'group' | 'virtual' | 'business' | 'playtime' | 'opencall';

export interface Participant {
    id: string;
    name: string;
    status: 'accepted' | 'pending' | 'declined';
}

export interface MeetingDetails {
    date: string;         // ISO date (YYYY-MM-DD)
    time: string;         // HH:mm
    location?: string;    // Venue or URL
    platform?: string;    // Zoom/Meet/Phone etc.
}

export interface ChatMessage {
    id: string;
    at: number;           // epoch ms
    author: string;       // display name
    text: string;
}

export interface Meeting {
    id: string;
    title: string;
    type: MeetingType;
    details: MeetingDetails;
    participants: Participant[];
    externalLink?: string;  // virtual URL (if any)
    messages: ChatMessage[];
}
