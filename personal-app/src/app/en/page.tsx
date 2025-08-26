'use client';
import BottomNav from '@/components/personal/BottomNav';
import LocaleSwitcher from '@/components/personal/LocaleSwitcher';
import QuickActions from '@/components/personal/QuickActions';
import { useParams, useRouter } from 'next/navigation';

export default function EnglishPage() {
  const params = useParams<{ locale: string }>();
  const router = useRouter();
  const locale = 'en';

  return (
    <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
      <div className="flex justify-end mb-4">
        <LocaleSwitcher />
      </div>
      <header className="mb-6">
        <div className="text-2xl font-semibold">Hi Gabriel, what would you like to do today?</div>
      </header>

      <section className="mb-6">
        <QuickActions locale={locale} />
      </section>

      <section className="space-y-3">
        <div className="text-lg font-semibold">What would you like to do today?</div>
        <div className="grid grid-cols-1 gap-3">
          <button onClick={() => router.push(`/${locale}/create/meeting`)} className="rounded-xl border p-3 text-left hover:shadow">
            ➕ Create Meeting
          </button>
          <button onClick={() => router.push(`/${locale}/reminders`)} className="rounded-xl border p-3 text-left hover:shadow">
            ⏰ Create Reminder
          </button>
          <button onClick={() => router.push(`/${locale}/playtime`)} className="rounded-xl border p-3 text-left hover:shadow">
            🎮 Playtime
          </button>
          <button onClick={() => router.push(`/${locale}/groups`)} className="rounded-xl border p-3 text-left hover:shadow">
            👥 Groups
          </button>
          <button onClick={() => router.push(`/${locale}/family`)} className="rounded-xl border p-3 text-left hover:shadow">
            👨‍👩‍👧 Family Management
          </button>
        </div>
      </section>

      <BottomNav locale={locale} />
    </main>
  );
}
