'use client';

import { Meeting, ChatMessage } from '@/types/meeting';

const K = 'appoint.personal.meetings.v1';

function loadAll(): Record<string, Meeting> {
  try {
    if (typeof window === 'undefined') return {};
    const raw = localStorage.getItem(K);
    return raw ? JSON.parse(raw) : {};
  } catch {
    return {};
  }
}

function saveAll(map: Record<string, Meeting>) {
  if (typeof window === 'undefined') return;
  localStorage.setItem(K, JSON.stringify(map));
}

export function upsertMeeting(m: Meeting) {
  const map = loadAll();
  map[m.id] = m;
  saveAll(map);
}

export function getMeeting(id: string): Meeting | undefined {
  const map = loadAll();
  return map[id];
}

export function ensureDemoMeeting(): Meeting {
  const map = loadAll();
  const first = Object.values(map)[0];
  if (first) return first;
  const demo: Meeting = {
    id: 'demo-' + Math.random().toString(36).slice(2,9),
    title: 'Coffee with Dana & Ron',
    type: 'group',
    details: { date: '2025-09-01', time: '17:00', location: 'Caffè Giusti, Modena', platform: '' },
    participants: [
      { id: 'g', name: 'Gabriel', status: 'accepted' },
      { id: 'd', name: 'Dana', status: 'pending' },
      { id: 'r', name: 'Ron', status: 'accepted' },
    ],
    externalLink: '',
    messages: [
      { id: 'm1', at: Date.now()-600000, author:'Dana', text:'Parking is tricky—come early' },
      { id: 'm2', at: Date.now()-300000, author:'Ron',  text:'Got a table outdoors.' }
    ]
  };
  map[demo.id] = demo;
  saveAll(map);
  return demo;
}

export function postMessage(meetingId: string, author: string, text: string): ChatMessage {
  const map = loadAll();
  const m = map[meetingId];
  const msg: ChatMessage = { id: 'msg-'+Math.random().toString(36).slice(2,9), at: Date.now(), author, text };
  if (m) {
    m.messages.push(msg);
    map[meetingId] = m;
    saveAll(map);
  }
  return msg;
}

export function markArrived(meetingId: string, who: string) {
  const map = loadAll();
  const m = map[meetingId];
  if (!m) return;
  // In a real backend we'd update presence; here we append a system-like message.
  m.messages.push({ id:'sys-'+Date.now(), at:Date.now(), author:'System', text:`${who} has arrived.` });
  saveAll(map);
}

export function markLate(meetingId: string, who: string, minutes: number) {
  const map = loadAll();
  const m = map[meetingId];
  if (!m) return;
  m.messages.push({ id:'sys-'+Date.now(), at:Date.now(), author:'System', text:`${who} is running ~${minutes} min late.` });
  saveAll(map);
}
