import { useEffect, useState } from 'react'
import { IcsTokenCard } from '../../src/components/IcsTokenCard'
import { InvoiceTable } from '../../src/components/InvoiceTable'
import { LatencyChart } from '../../src/components/LatencyChart'
import { Navbar } from '../../src/components/Navbar'
import { UsageChart } from '../../src/components/UsageChart'
import { WebhookManager } from '../../src/components/WebhookManager'
import { I18nContext } from '../../src/lib/i18n'
import en from '../../src/locales/en.json'

export default function Dashboard() {
  const [usage, setUsage] = useState([])
  const [latency, setLatency] = useState([])
  const [invoices, setInvoices] = useState([])
  const [token, setToken] = useState('')

  useEffect(() => {
    // TODO: fetch data from backend endpoints
  }, [])

  async function rotateToken() {
    // TODO POST to rotate endpoint then refresh token
  }

  return (
    <I18nContext.Provider value={{ t: (k) => (en[k] || k) }}>
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