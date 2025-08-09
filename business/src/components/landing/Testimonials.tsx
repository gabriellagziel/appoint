export default function Testimonials() {
  return (
    <section className="py-20">
      <h3 className="text-2xl font-semibold">Testimonials</h3>
      <p className="mt-3 text-slate-400 text-sm">
        Real customer stories are coming soon. We don't use fake logos or quotes.
      </p>
      <div className="mt-6 grid md:grid-cols-3 gap-6">
        {[1,2,3].map((i) => (
          <div key={i} className="rounded-2xl bg-white/5 border border-white/10 p-6 h-32" />
        ))}
      </div>
    </section>
  );
}


