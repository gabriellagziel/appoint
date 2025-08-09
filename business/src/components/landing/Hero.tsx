import Link from "next/link";

export default function Hero() {
  return (
    <section className="py-20 md:py-28 text-center">
      <h1 className="text-4xl md:text-6xl font-bold tracking-tight text-balance">
        <span className="bg-gradient-to-r from-blue-400 via-cyan-300 to-emerald-300 bg-clip-text text-transparent">
          Run your day on a live calendar.
        </span>
      </h1>
      <p className="mt-6 text-lg text-slate-300 max-w-2xl mx-auto">
        App-Oint Business Studio brings appointments, clients, staff, and two-way
        scheduling together — in real time.
      </p>
      <div className="mt-10 flex flex-col sm:flex-row gap-3 justify-center">
        <Link href="/login" className="inline-flex items-center justify-center rounded-xl px-5 py-3 text-sm font-medium bg-blue-600 hover:bg-blue-700 text-white shadow">
          Get Started
        </Link>
        <Link href="/dashboard" className="inline-flex items-center justify-center rounded-xl px-5 py-3 text-sm font-medium bg-white/10 hover:bg-white/20 text-white border border-white/10">
          Open Dashboard
        </Link>
      </div>
      <div className="mt-12 mx-auto max-w-3xl rounded-2xl border border-white/10 bg-white/5 backdrop-blur p-6 shadow-md">
        <div className="h-48 rounded-xl bg-gradient-to-br from-blue-500/20 via-cyan-400/10 to-emerald-300/10" />
        <p className="mt-3 text-sm text-slate-400">Preview — your day at a glance</p>
      </div>
    </section>
  );
}


