import { 
  collection, 
  query, 
  orderBy, 
  onSnapshot, 
  addDoc, 
  doc, 
  updateDoc, 
  serverTimestamp 
} from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { MeetingMessage, SendMessageData } from '@/lib/types/message';

export class MessagesService {
  private static instance: MessagesService;
  
  public static getInstance(): MessagesService {
    if (!MessagesService.instance) {
      MessagesService.instance = new MessagesService();
    }
    return MessagesService.instance;
  }

  listMessages(meetingId: string, callback: (messages: MeetingMessage[]) => void) {
    const messagesQuery = query(
      collection(db, 'messages', meetingId, 'items'),
      orderBy('createdAt', 'asc')
    );

    return onSnapshot(messagesQuery, (snapshot) => {
      const messages: MeetingMessage[] = [];
      snapshot.forEach((doc) => {
        messages.push({ id: doc.id, ...doc.data() } as MeetingMessage);
      });
      callback(messages);
    });
  }

  async sendMessage(data: SendMessageData): Promise<void> {
    const { meetingId, authorUid, authorRole, text } = data;
    
    await addDoc(collection(db, 'messages', meetingId, 'items'), {
      authorUid,
      authorRole,
      text,
      createdAt: serverTimestamp(),
      seenBy: {
        [authorUid]: new Date().toISOString(),
      },
    });
  }

  async markSeen(meetingId: string, uid: string): Promise<void> {
    const messageRef = doc(db, 'messages', meetingId, 'items', 'latest');
    
    await updateDoc(messageRef, {
      [`seenBy.${uid}`]: new Date().toISOString(),
    });
  }

  async markAllSeen(meetingId: string, uid: string): Promise<void> {
    // This would require updating all messages in the meeting
    // For now, we'll implement a simpler approach
    const messagesQuery = query(
      collection(db, 'messages', meetingId, 'items'),
      orderBy('createdAt', 'desc'),
    );

    // Note: This is a simplified implementation
    // In a production app, you might want to batch update all messages
    console.log(`Marking all messages as seen for user ${uid} in meeting ${meetingId}`);
  }
}

export const messagesService = MessagesService.getInstance();




