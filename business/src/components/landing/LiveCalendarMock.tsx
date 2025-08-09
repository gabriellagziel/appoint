import Link from "next/link";

const hours = Array.from({ length: 13 }).map((_, i) => 8 + i); // 08..20

export default function LiveCalendarMock() {
  return (
    <section className="py-20">
      <h3 className="text-2xl font-semibold mb-6">Live Calendar Preview</h3>
      <div className="grid md:grid-cols-3 gap-6">
        <div className="md:col-span-2 rounded-2xl border border-white/10 bg-white/5 p-4">
          <ul className="divide-y divide-white/10">
            {hours.map((h) => (
              <li key={h} className="py-3 flex items-center justify-between">
                <span className="text-slate-300">{String(h).padStart(2, "0")}:00</span>
                {h === 10 && (
                  <span className="rounded-md px-2 py-1 bg-blue-500/20 text-blue-200 text-xs">Consultation</span>
                )}
                {h === 14 && (
                  <span className="rounded-md px-2 py-1 bg-emerald-500/20 text-emerald-200 text-xs">Follow‑up</span>
                )}
              </li>
            ))}
          </ul>
        </div>
        <div className="rounded-2xl border border-white/10 bg-white/5 p-4">
          <p className="text-slate-300 mb-4">Create an appointment directly from your calendar.</p>
          <Link href="/dashboard" className="inline-flex items-center justify-center rounded-xl px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white">
            Open Dashboard
          </Link>
        </div>
      </div>
    </section>
  );
}


