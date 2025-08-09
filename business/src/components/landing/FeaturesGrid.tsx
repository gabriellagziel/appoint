const features = [
  { title: "Appointments", desc: "Create, confirm, decline, or suggest a new time." },
  { title: "CRM (Customers)", desc: "History, notes, and quick actions in one place." },
  { title: "Staff & Rooms", desc: "Assign services, manage availability, avoid double‑booking." },
  { title: "Reports", desc: "Today/Week/Month insights with CSV export." },
  { title: "Branding", desc: "Logo, colors, and custom questions on Pro+ plans." },
  { title: "Plan Limits", desc: "Feature gating and quotas — upgrade when you grow." },
];

export default function FeaturesGrid() {
  return (
    <section className="py-20">
      <h3 className="text-2xl font-semibold mb-8">Everything you need to run your business</h3>
      <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {features.map((f) => (
          <div key={f.title} className="rounded-2xl bg-white/5 border border-white/10 p-6 shadow-md">
            <h4 className="font-semibold">{f.title}</h4>
            <p className="mt-2 text-slate-300 text-sm">{f.desc}</p>
          </div>
        ))}
      </div>
    </section>
  );
}


