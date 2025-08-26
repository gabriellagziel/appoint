'use client';
import { Meeting } from '@/types/meeting';

export default function DetailsCard({ m }: { m: Meeting }) {
  const { date, time, location } = m.details;
  return (
    <div className="rounded-2xl border p-4">
      <div className="text-lg font-semibold">{m.title}</div>
      <div className="mt-2 text-sm">
        <div><b>Date:</b> {date || '—'} <b>Time:</b> {time || '—'}</div>
        <div><b>Location:</b> {location || (m.externalLink ? 'Virtual' : '—')}</div>
        {m.externalLink ? <div><b>Link:</b> <a className="text-blue-600 underline" href={m.externalLink} target="_blank">Join</a></div> : null}
      </div>
    </div>
  );
}
