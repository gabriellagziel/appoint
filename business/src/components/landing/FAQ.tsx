const faqs = [
  { q: "How do clients book me?", a: "Via your public page or the App‑Oint app." },
  { q: "What's the live calendar?", a: "Your day view with real‑time updates and inline creation." },
  { q: "How do plans work?", a: "Free, Pro, and Enterprise with feature gating and limits." },
  { q: "Is there messaging?", a: "Yes, meeting‑based chat with read receipts." },
  { q: "What are Open Calls?", a: "Instant availability announcements (now/today)." },
];

export default function FAQ() {
  return (
    <section className="py-20">
      <h3 className="text-2xl font-semibold">FAQ</h3>
      <div className="mt-6 divide-y divide-white/10 rounded-2xl border border-white/10 bg-white/5">
        {faqs.map((f) => (
          <details key={f.q} className="p-4">
            <summary className="cursor-pointer font-medium">{f.q}</summary>
            <p className="mt-2 text-slate-300 text-sm">{f.a}</p>
          </details>
        ))}
      </div>
    </section>
  );
}


