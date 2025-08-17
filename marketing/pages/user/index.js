import Link from 'next/link'

export default function UserLanding() {
  return (
    <main className="mx-auto max-w-5xl px-4 py-16">
      <h1 className="text-3xl font-semibold">User App (PWA)</h1>
      <p className="mt-3 text-neutral-700">Add to Home Screen for a full-screen, fast experience. Free with ads, Premium (€4) no ads.</p>
      <div className="mt-6 flex gap-3">
        <a href="https://app.app-oint.com" className="px-5 py-3 rounded-xl bg-blue-600 text-white hover:bg-blue-700">Open the App</a>
        <Link href="/how-to-install-pwa/" className="px-5 py-3 rounded-xl border hover:bg-neutral-50">How to Add to Home Screen</Link>
      </div>
    </main>
  )
}



