export default function TrustStrip() {
  const items = [
    "Privacy-friendly",
    "Realtime",
    "Mobile-ready",
    "Firebase-secured",
  ];
  return (
    <section className="py-8">
      <ul className="flex flex-wrap items-center justify-center gap-3 text-xs text-slate-300">
        {items.map((t) => (
          <li key={t} className="rounded-full border border-white/10 bg-white/5 px-3 py-1">
            {t}
          </li>
        ))}
      </ul>
    </section>
  );
}
