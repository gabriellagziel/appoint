'use client';
import { Participant } from '@/types/meeting';

export default function Participants({ list }: { list: Participant[] }) {
  const badge = (s: Participant['status']) =>
    s === 'accepted' ? 'bg-green-100 text-green-800' :
    s === 'pending'  ? 'bg-orange-100 text-orange-800' :
                       'bg-gray-100 text-gray-700';

  return (
    <div className="rounded-2xl border p-4">
      <div className="font-semibold mb-2">Participants</div>
      <div className="flex flex-wrap gap-2">
        {list.map(p => (
          <span key={p.id} className={`rounded-full px-3 py-1 text-sm border ${badge(p.status)}`}>
            {p.name} · {p.status}
          </span>
        ))}
      </div>
    </div>
  );
}
