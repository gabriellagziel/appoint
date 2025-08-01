import { IcsTokenCard } from '../../src/components/IcsTokenCard'
import { InvoiceTable } from '../../src/components/InvoiceTable'
import { LatencyChart } from '../../src/components/LatencyChart'
import { Navbar } from '../../src/components/Navbar'
import { UsageChart } from '../../src/components/UsageChart'
import { WebhookManager } from '../../src/components/WebhookManager'
import { I18nContext } from '../../src/lib/i18n'
import en from '../../src/locales/en.json'
import { useEffect, useState } from 'react'

export default function Dashboard() {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const [usage, setUsage] = useState<{ date: string; calls: number }[]>([])
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const [latency, setLatency] = useState<{ date: string; p95: number }[]>([])
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const [invoices, setInvoices] = useState<{ id: string; month: string; amount: number; status: string; pdfUrl: string }[]>([])
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const [token, setToken] = useState('')

  useEffect(() => {
    // TODO: fetch data from backend endpoints
  }, [])

  async function rotateToken() {
    // TODO POST to rotate endpoint then refresh token
  }

  return (
    <I18nContext.Provider value={{ t: (k: string) => (en as Record<string, string>)[k] || k }}>
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