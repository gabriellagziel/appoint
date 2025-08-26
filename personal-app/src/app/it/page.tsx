'use client';
import BottomNav from '@/components/personal/BottomNav';
import QuickActions from '@/components/personal/QuickActions';
import { useParams, useRouter } from 'next/navigation';

export default function ItalianPage() {
  const params = useParams<{ locale: string }>();
  const router = useRouter();
  const locale = 'it';

  return (
    <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
      <header className="mb-6">
        <div className="text-2xl font-semibold">Ciao Gabriel, cosa vorresti fare oggi?</div>
      </header>

      <section className="mb-6">
        <QuickActions locale={locale} />
      </section>

      <section className="space-y-3">
        <div className="text-lg font-semibold">Cosa vorresti fare oggi?</div>
        <div className="grid grid-cols-1 gap-3">
          <button onClick={() => router.push(`/${locale}/create/meeting`)} className="rounded-xl border p-3 text-left hover:shadow">
            ➕ Crea Riunione
          </button>
          <button onClick={() => router.push(`/${locale}/reminders`)} className="rounded-xl border p-3 text-left hover:shadow">
            ⏰ Crea Promemoria
          </button>
          <button onClick={() => router.push(`/${locale}/playtime`)} className="rounded-xl border p-3 text-left hover:shadow">
            🎮 Tempo di Gioco
          </button>
          <button onClick={() => router.push(`/${locale}/groups`)} className="rounded-xl border p-3 text-left hover:shadow">
            👥 Gruppi
          </button>
          <button onClick={() => router.push(`/${locale}/family`)} className="rounded-xl border p-3 text-left hover:shadow">
            👨‍👩‍👧 Gestione Famiglia
          </button>
        </div>
      </section>

      <BottomNav locale={locale} />
    </main>
  );
}
