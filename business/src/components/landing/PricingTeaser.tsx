import Link from "next/link";

const plans = [
  {
    name: "Free",
    price: "$0",
    bullets: ["Up to 5 appointments/mo", "1 staff", "Basic features"],
  },
  {
    name: "Pro",
    price: "$29",
    bullets: ["Up to 50 appointments/mo", "5 staff", "Branding & Custom Fields", "Public Booking"],
  },
  {
    name: "Enterprise",
    price: "Contact",
    bullets: ["Unlimited", "SLA & Support", "Multi‑location"],
  },
];

export default function PricingTeaser() {
  return (
    <section className="py-20">
      <h3 className="text-2xl font-semibold mb-8">Simple, scalable pricing</h3>
      <div className="grid md:grid-cols-3 gap-6">
        {plans.map((p) => (
          <div key={p.name} className="rounded-2xl bg-white/5 border border-white/10 p-6">
            <h4 className="font-semibold">{p.name}</h4>
            <div className="mt-2 text-3xl font-bold">{p.price}</div>
            <ul className="mt-4 space-y-2 text-slate-300 text-sm">
              {p.bullets.map((b) => (
                <li key={b}>• {b}</li>
              ))}
            </ul>
            <Link href="/dashboard/billing" className="mt-6 inline-flex rounded-xl px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white">
              Choose {p.name}
            </Link>
          </div>
        ))}
      </div>
    </section>
  );
}


