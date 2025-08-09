'use client';
import { useEffect, useState } from 'react';

type Service = {
  name: string;
  healthz: { ok: boolean; status?: string };
  version?: { sha?: string; buildTime?: string };
};
type Status = { ok: boolean; services: Service[]; timestamp: string };

export default function StatusPage() {
  const [data, setData] = useState<Status | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function fetchStatus() {
    setError(null);
    try {
      const res = await fetch('/api/status', { cache: 'no-store' });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      setData(await res.json());
    } catch (e: any) {
      setError(e?.message || 'Failed to load status');
    }
  }

  useEffect(() => {
    fetchStatus();
    const id = setInterval(fetchStatus, 15000);
    return () => clearInterval(id);
  }, []);

  const badge = (ok: boolean) => (ok ? 'bg-green-500' : 'bg-red-500');

  return (
    <main className="mx-auto max-w-3xl p-6">
      <h1 className="text-2xl font-bold mb-4">App-Oint Status</h1>
      <div className="mb-4 text-sm text-gray-600">
        Last updated: {data?.timestamp || '—'}
        {error && <span className="ml-2 text-red-600">({error})</span>}
      </div>
      <div className="grid gap-4">
        {data?.services?.length ? (
          data.services.map((s) => (
            <div key={s.name} className="rounded-xl border p-4 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <span className={`inline-block h-3 w-3 rounded-full ${badge(!!s.healthz?.ok)}`} />
                <div>
                  <div className="font-medium">{s.name}</div>
                  <div className="text-xs text-gray-500">
                    {s.version?.sha ? `SHA ${s.version.sha.slice(0, 7)} • ` : ''}
                    {s.version?.buildTime ? new Date(s.version.buildTime).toLocaleString() : ''}
                  </div>
                </div>
              </div>
              <div className="text-sm">{s.healthz?.status || (s.healthz?.ok ? 'OK' : 'DOWN')}</div>
            </div>
          ))
        ) : (
          <div>No data yet…</div>
        )}
      </div>
    </main>
  );
}



