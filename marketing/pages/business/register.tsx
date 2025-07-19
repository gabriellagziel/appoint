import { useState } from 'react'
import { Navbar } from '@/components/Navbar'
import { BusinessRegisterForm } from '@/components/BusinessRegisterForm'

export default function BusinessRegisterPage() {
  const [apiKey, setApiKey] = useState<string | null>(null)

  return (
    <main className="min-h-screen">
      <Navbar />
      <section className="py-16 px-4">
        {!apiKey ? (
          <BusinessRegisterForm onSuccess={key => setApiKey(key)} />
        ) : (
          <div className="max-w-lg mx-auto text-center space-y-4">
            <h2 className="text-2xl font-semibold">Registration Successful 🎉</h2>
            <p>Your API key is:</p>
            <pre className="p-4 bg-gray-100 rounded break-all">{apiKey}</pre>
            <p className="text-sm text-gray-600">Store this key securely. It will not be shown again.</p>
          </div>
        )}
      </section>
    </main>
  )
}