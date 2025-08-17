"use client";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-indigo-50">
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
        <div className="text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
            App-Oint
            <span className="block text-indigo-600">Enterprise Portal</span>
          </h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-12">
            Enterprise-grade appointment scheduling, team management, and system integration for large organizations.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <button className="inline-flex items-center justify-center rounded-lg bg-indigo-600 px-8 py-4 text-white font-medium hover:bg-indigo-700 transition-colors">
              Enterprise Login
            </button>
            <button className="inline-flex items-center justify-center rounded-lg border border-gray-300 px-8 py-4 text-gray-900 font-medium hover:bg-gray-50 transition-colors">
              Contact Sales
            </button>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-20">
          {[
            {
              title: "Enterprise Integration",
              description: "Seamless integration with your existing enterprise systems and workflows.",
              icon: "🔗"
            },
            {
              title: "Team Management",
              description: "Advanced user management, role-based access control, and team collaboration.",
              icon: "👥"
            },
            {
              title: "Scalable Infrastructure",
              description: "Built for enterprise scale with high availability and performance.",
              icon: "🚀"
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
