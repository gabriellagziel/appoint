import Link from "next/link";

export default function OpenCallsSection() {
  return (
    <section className="py-20">
      <div className="rounded-2xl border border-white/10 bg-white/5 p-6">
        <h3 className="text-2xl font-semibold">Open Calls — "Available now / today"</h3>
        <p className="mt-3 text-slate-300">
          Announce last‑minute availability and let clients grab a spot instantly.
        </p>
        <div className="mt-6 flex flex-col sm:flex-row gap-3">
          <Link href="/dashboard/availability" className="rounded-xl px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white">
            Create Open Call
          </Link>
          <Link href={process.env.NEXT_PUBLIC_DEMO_BUSINESS_ID ? `/public/business/${process.env.NEXT_PUBLIC_DEMO_BUSINESS_ID}` : "/login"} className="rounded-xl px-4 py-2 bg-white/10 hover:bg-white/20 border border-white/10">
            View Public Page (demo)
          </Link>
        </div>
      </div>
    </section>
  );
}


