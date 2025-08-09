export interface MeetingMessage {
  id: string;
  meetingId: string;
  authorUid: string;
  authorRole: 'business' | 'user' | 'staff';
  text: string;
  createdAt: string;
  seenBy?: Record<string, string>;
}

export interface SendMessageData {
  meetingId: string;
  authorUid: string;
  authorRole: 'business' | 'user' | 'staff';
  text: string;
}




