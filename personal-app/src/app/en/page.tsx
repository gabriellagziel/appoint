export default function EnglishPage() {
  return (
    <div className="min-h-screen bg-white">
      <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Welcome to APP-OINT
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Time Organized. Set Send Done.
          </p>
          <div className="space-y-4">
            <div className="bg-blue-50 p-4 rounded-lg">
              <h2 className="text-lg font-semibold text-blue-900">Create Meeting</h2>
            </div>
            <div className="bg-green-50 p-4 rounded-lg">
              <h2 className="text-lg font-semibold text-green-900">Agenda</h2>
            </div>
            <div className="bg-purple-50 p-4 rounded-lg">
              <h2 className="text-lg font-semibold text-purple-900">Family</h2>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
