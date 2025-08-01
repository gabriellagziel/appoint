import { useI18n } from '../lib/i18n'
import { useEffect, useState } from 'react'

interface Webhook {
  id: string
  url: string
  secret: string
}

export const WebhookManager: React.FC = () => {
  const { t } = useI18n()
  const [hooks] = useState<Webhook[]>([])
  const [url, setUrl] = useState('')
  const [secret, setSecret] = useState('')

  useEffect(() => {
    // fetch existing hooks (TODO wire API)
  }, [])

  function createWebhook() {
    // TODO POST to backend
  }

  return (
    <div className="space-y-4">
      <h3 className="font-semibold">{t('dashboard.webhooks')}</h3>
      <div className="flex space-x-2">
        <input className="border p-2 flex-1" placeholder={t('webhook.url')} value={url} onChange={(e) => setUrl(e.target.value)} />
        <input className="border p-2" placeholder={t('webhook.secret')} value={secret} onChange={(e) => setSecret(e.target.value)} />
        <button className="bg-blue-600 text-white px-3" onClick={createWebhook}>{t('webhook.create')}</button>
      </div>
      <ul>
        {hooks.map((h) => (
          <li key={h.id} className="flex items-center justify-between border p-2 mt-2">
            <span className="truncate flex-1 mr-2">{h.url}</span>
            <button className="text-red-600 text-sm" onClick={() => { }}>{t('webhook.delete')}</button>
          </li>
        ))}
      </ul>
    </div>
  )
}