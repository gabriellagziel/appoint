export default function Home() {
  return (
    <main className="min-h-screen bg-white">
      <section className="bg-gradient-to-br from-blue-50 to-indigo-50">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-24 text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900">
            Business Studio
            <span className="block text-blue-600">Appointments, Messages, Analytics</span>
          </h1>
          <p className="mt-6 text-lg text-gray-600 max-w-2xl mx-auto">
            Manage your operations with a modern dashboard built for speed and clarity.
          </p>
          <div className="mt-10 flex flex-col sm:flex-row gap-4 justify-center">
            <a href="/login" className="inline-flex items-center justify-center rounded-lg bg-blue-600 px-6 py-3 text-white font-medium hover:bg-blue-700">
              Sign in
            </a>
            <a href="/signup" className="inline-flex items-center justify-center rounded-lg border border-gray-300 px-6 py-3 text-gray-900 font-medium hover:bg-gray-50">
              Create account
            </a>
          </div>
        </div>
      </section>

      <section className="py-16">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          {["Appointments", "Messaging", "Branding"].map((title) => (
            <div key={title} className="rounded-xl border border-gray-200 p-6 bg-white">
              <h3 className="text-lg font-semibold text-gray-900">{title}</h3>
              <p className="mt-2 text-sm text-gray-600">Streamlined tools for your day-to-day workflow.</p>
            </div>
          ))}
        </div>
      </section>
    </main>
  )
}