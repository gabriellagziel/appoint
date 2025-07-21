import { useState } from 'react'

interface Props {
  onSuccess: (apiKey: string) => void
}

export const BusinessRegisterForm: React.FC<Props> = ({ onSuccess }) => {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [industry, setIndustry] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)
    try {
      const resp = await fetch(process.env.NEXT_PUBLIC_REGISTER_ENDPOINT || '/api/registerBusiness', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ name, email, industry })
      })
      const data = await resp.json()
      if (!resp.ok) throw new Error(data.error || 'Registration failed')
      onSuccess(data.apiKey)
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Registration failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <form className="max-w-md mx-auto space-y-4" onSubmit={handleSubmit}>
      <h2 className="text-2xl font-semibold text-center">Business API Registration</h2>
      {error && <p className="text-red-600 text-sm">{error}</p>}
      <div>
        <label className="block mb-1">Business Name</label>
        <input
          className="w-full border rounded p-2"
          required
          value={name}
          onChange={e => setName(e.target.value)}
        />
      </div>
      <div>
        <label className="block mb-1">Email</label>
        <input
          type="email"
          className="w-full border rounded p-2"
          required
          value={email}
          onChange={e => setEmail(e.target.value)}
        />
      </div>
      <div>
        <label className="block mb-1">Industry / Sector</label>
        <input
          className="w-full border rounded p-2"
          value={industry}
          onChange={e => setIndustry(e.target.value)}
        />
      </div>
      <button
        className="w-full bg-blue-600 text-white rounded p-2 disabled:opacity-50"
        disabled={loading}
      >
        {loading ? 'Registering...' : 'Register'}
      </button>
    </form>
  )
}