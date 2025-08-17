import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50">
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
        <div className="text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
            App-Oint
            <span className="block text-blue-600">Business Dashboard</span>
          </h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-12">
            Manage your business operations, appointments, and customer relationships with our modern dashboard built for speed and clarity.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <Link 
              href="/login" 
              className="inline-flex items-center justify-center rounded-lg bg-blue-600 px-8 py-4 text-white font-medium hover:bg-blue-700 transition-colors"
            >
              Sign in to Dashboard
            </Link>
            <Link 
              href="/signup" 
              className="inline-flex items-center justify-center rounded-lg border border-gray-300 px-8 py-4 text-gray-900 font-medium hover:bg-gray-50 transition-colors"
            >
              Create Business Account
            </Link>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-20">
          {[
            {
              title: "Appointment Management",
              description: "Streamlined scheduling, calendar integration, and customer booking management.",
              icon: "📅"
            },
            {
              title: "Customer Analytics",
              description: "Track performance, customer insights, and business metrics in real-time.",
              icon: "📊"
            },
            {
              title: "Business Operations",
              description: "Manage staff, services, and business settings from one central location.",
              icon: "⚙️"
            }
          ].map((feature) => (
            <div key={feature.title} className="text-center p-6 rounded-xl border border-gray-200 bg-white shadow-sm">
              <div className="text-4xl mb-4">{feature.icon}</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">{feature.title}</h3>
              <p className="text-sm text-gray-600">{feature.description}</p>
            </div>
          ))}
        </div>
      </main>
    </div>
  );
}
