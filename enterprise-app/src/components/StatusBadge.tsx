'use client';
import { useEffect, useState } from 'react';

export default function StatusBadge() {
  const disabled = (process.env.NEXT_PUBLIC_STATUS_BADGE || process.env.STATUS_BADGE || '').toLowerCase() === 'off';
  const [ok, setOk] = useState<boolean | null>(null);

  useEffect(() => {
    if (disabled) return;
    let alive = true;
    const ping = async () => {
      try {
        const res = await fetch('/api/healthz', { cache: 'no-store' });
        if (alive) setOk(res.ok);
      } catch {
        if (alive) setOk(false);
      }
    };
    ping();
    const id = setInterval(ping, 30000);
    return () => {
      alive = false;
      clearInterval(id);
    };
  }, [disabled]);

  if (disabled) return null;
  const color = ok === null ? 'bg-gray-400' : ok ? 'bg-green-500' : 'bg-red-500';
  const title = ok === null ? 'status: unknown' : ok ? 'status: ok' : 'status: down';

  return (
    <div title={title} aria-label={title} className="fixed top-2 right-2 z-50">
      <span className={`inline-block h-3 w-3 rounded-full ${color}`} />
    </div>
  );
}



