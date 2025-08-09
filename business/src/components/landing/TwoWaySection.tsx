import Link from "next/link";

export default function TwoWaySection() {
  return (
    <section className="py-20">
      <div className="grid md:grid-cols-2 gap-8 items-center">
        <div>
          <h2 className="text-3xl md:text-4xl font-semibold mb-4">Two-way scheduling. Business ↔ User.</h2>
          <ul className="space-y-3 text-slate-300">
            <li>• Users book you from your public page or the App-Oint app.</li>
            <li>• You invite clients and confirm/decline or suggest a new time.</li>
            <li>• Everything syncs instantly across both sides.</li>
          </ul>
          <div className="mt-6 flex gap-3">
            <Link href={process.env.NEXT_PUBLIC_DEMO_BUSINESS_ID ? `/public/business/${process.env.NEXT_PUBLIC_DEMO_BUSINESS_ID}` : "/login"} className="rounded-xl px-4 py-2 bg-white/10 hover:bg-white/20 border border-white/10">
              View Public Page (demo)
            </Link>
            <Link href="/dashboard" className="rounded-xl px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white">
              Create Appointment
            </Link>
          </div>
        </div>
        <div className="rounded-2xl border border-white/10 bg-white/5 backdrop-blur p-6 shadow-md">
          <div className="h-56 rounded-xl bg-gradient-to-tr from-emerald-400/10 via-blue-500/10 to-cyan-400/10" />
          <p className="mt-3 text-sm text-slate-400">Two-way workflow preview</p>
        </div>
      </div>
    </section>
  );
}
