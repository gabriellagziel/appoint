export default function EnterpriseLanding() {
  return (
    <main className="mx-auto max-w-5xl px-4 py-16">
      <h1 className="text-3xl font-semibold">Enterprise API</h1>
      <p className="mt-3 text-neutral-700">Schedule at scale via API. Keys, usage dashboards, and monthly invoicing.</p>
      <p className="mt-1 text-neutral-700">Typical pricing: $0.99 per meeting with location, $0.49 without.</p>
      <div className="mt-6 flex gap-3">
        <a href="https://enterprise.app-oint.com" className="px-5 py-3 rounded-xl border hover:bg-neutral-50">See the API Portal</a>
        <a href="https://enterprise.app-oint.com/docs" className="px-5 py-3 rounded-xl border hover:bg-neutral-50">Read the Docs</a>
      </div>
    </main>
  )
}



