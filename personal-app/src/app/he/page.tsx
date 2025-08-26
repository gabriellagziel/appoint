'use client';
import BottomNav from '@/components/personal/BottomNav';
import LocaleSwitcher from '@/components/personal/LocaleSwitcher';
import QuickActions from '@/components/personal/QuickActions';
import { useParams, useRouter } from 'next/navigation';

export default function HebrewPage() {
  const params = useParams<{ locale: string }>();
  const router = useRouter();
  const locale = 'he';

  return (
    <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8" dir="rtl">
      <div className="flex justify-end mb-4">
        <LocaleSwitcher />
      </div>
      <header className="mb-6">
        <div className="text-2xl font-semibold">היי גבריאל, מה תרצה לעשות היום?</div>
      </header>

      <section className="mb-6">
        <QuickActions locale={locale} />
      </section>

      <section className="space-y-3">
        <div className="text-lg font-semibold">מה תרצה לעשות היום?</div>
        <div className="grid grid-cols-1 gap-3">
          <button onClick={() => router.push(`/${locale}/create/meeting`)} className="rounded-xl border p-3 text-left hover:shadow">
            ➕ צור פגישה
          </button>
          <button onClick={() => router.push(`/${locale}/reminders`)} className="rounded-xl border p-3 text-left hover:shadow">
            ⏰ צור תזכורת
          </button>
          <button onClick={() => router.push(`/${locale}/playtime`)} className="rounded-xl border p-3 text-left hover:shadow">
            🎮 זמן משחק
          </button>
          <button onClick={() => router.push(`/${locale}/groups`)} className="rounded-xl border p-3 text-left hover:shadow">
            👥 קבוצות
          </button>
          <button onClick={() => router.push(`/${locale}/family`)} className="rounded-xl border p-3 text-left hover:shadow">
            👨‍👩‍👧 ניהול משפחה
          </button>
        </div>
      </section>

      <BottomNav locale={locale} />
    </main>
  );
}
