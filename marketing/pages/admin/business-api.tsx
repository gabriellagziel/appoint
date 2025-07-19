import { useEffect, useState } from 'react'
import { Navbar } from '@/components/Navbar'

interface Business {
  id: string
  name: string
  email: string
  apiKey: string
  usageThisMonth: number
  monthlyQuota: number
  status: string
}

export default function AdminBusinessApiPage() {
  const [businesses, setBusinesses] = useState<Business[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function fetchData() {
      try {
        const res = await fetch('/api/admin/businesses')
        const data = await res.json()
        setBusinesses(data)
      } catch (err: any) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }
    fetchData()
  }, [])

  return (
    <main className="min-h-screen">
      <Navbar />
      <section className="p-8">
        <h1 className="text-3xl font-bold mb-6">Business API – Admin Dashboard</h1>
        {loading && <p>Loading...</p>}
        {error && <p className="text-red-600">{error}</p>}
        {!loading && !error && (
          <table className="min-w-full border">
            <thead>
              <tr className="bg-gray-50">
                <th className="p-2 border">Business</th>
                <th className="p-2 border">Email</th>
                <th className="p-2 border">API Key</th>
                <th className="p-2 border">Usage</th>
                <th className="p-2 border">Status</th>
              </tr>
            </thead>
            <tbody>
              {businesses.map(b => (
                <tr key={b.id} className="border-b">
                  <td className="p-2 border">{b.name}</td>
                  <td className="p-2 border">{b.email}</td>
                  <td className="p-2 border text-xs break-all">{b.apiKey}</td>
                  <td className="p-2 border">{b.usageThisMonth}/{b.monthlyQuota}</td>
                  <td className="p-2 border">{b.status}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </main>
  )
}