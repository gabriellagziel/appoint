export default function LoginPage() {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Admin Login
          </h2>
          <p className="mt-2 text-center text-sm text-gray-600">
            Sign in to your admin account
          </p>
        </div>
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <div className="text-center">
            <p className="text-gray-600">Authentication implementation needed</p>
            <a 
              href="/" 
              className="mt-4 inline-block bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
            >
              Continue to Dashboard
            </a>
          </div>
        </div>
      </div>
    </div>
  )
}