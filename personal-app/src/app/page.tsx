export default function RootPage() {
  // This page should never be reached because middleware redirects first
  // But if it is, show a loading state
  return (
    <div className="min-h-screen bg-white flex items-center justify-center">
      <div className="text-center">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-600 mx-auto mb-4"></div>
        <p className="text-gray-600">Detecting your language...</p>
      </div>
    </div>
  );
}
