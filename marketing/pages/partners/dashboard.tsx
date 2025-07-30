import { useEffect, useState } from 'react'
import { Navbar } from '@/components/Navbar'
import { UsageChart } from '@/components/UsageChart'
import { LatencyChart } from '@/components/LatencyChart'
import { InvoiceTable } from '@/components/InvoiceTable'
import { WebhookManager } from '@/components/WebhookManager'
import { IcsTokenCard } from '@/components/IcsTokenCard'
import { useI18n, I18nContext } from '@/lib/i18n'
import en from '@/locales/en.json'

export default function Dashboard() {
  const [usage, setUsage] = useState([] as any[])
  const [latency, setLatency] = useState([] as any[])
  const [invoices, setInvoices] = useState([] as any[])
  const [token, setToken] = useState('')

  useEffect(() => {
    // TODO: fetch data from backend endpoints
  }, [])

  async function rotateToken() {
    // TODO POST to rotate endpoint then refresh token
  }

  return (
    <I18nContext.Provider value={{ t: (k: string) => (en as any)[k] || k }}>
      <main className="min-h-screen">
        <Navbar />
        <section className="p-6 space-y-8 max-w-5xl mx-auto">
          <h1 className="text-3xl font-bold">Dashboard</h1>
          <div className="grid md:grid-cols-2 gap-6">
            <UsageChart data={usage} />
            <LatencyChart data={latency} />
          </div>
          <InvoiceTable invoices={invoices} />
          <IcsTokenCard token={token} onRotate={rotateToken} />
          <WebhookManager />
        </section>
      </main>
    </I18nContext.Provider>
  )
}