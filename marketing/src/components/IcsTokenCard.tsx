import { useI18n } from '@/lib/i18n'
import { useState } from 'react'

interface Props {
  token: string
  onRotate: () => Promise<void>
}

export const IcsTokenCard: React.FC<Props> = ({ token, onRotate }) => {
  const { t } = useI18n()
  const [loading, setLoading] = useState(false)

  async function rotate() {
    setLoading(true)
    await onRotate()
    setLoading(false)
  }

  return (
    <div className="border p-4 rounded space-y-2">
      <h3 className="font-semibold">{t('dashboard.icsToken')}</h3>
      <pre className="bg-gray-100 p-2 break-all">{token}</pre>
      <button className="bg-blue-600 text-white px-3 py-1 rounded" onClick={rotate} disabled={loading}>
        {t('dashboard.rotateToken')}
      </button>
    </div>
  )
}