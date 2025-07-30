import { useI18n } from '@/lib/i18n'

interface Invoice {
  id: string
  month: string
  amount: number
  status: string
  pdfUrl: string
}

interface Props {
  invoices: Invoice[]
}

export const InvoiceTable: React.FC<Props> = ({ invoices }) => {
  const { t } = useI18n()
  return (
    <table className="w-full border text-sm">
      <thead>
        <tr className="bg-gray-50">
          <th className="p-2 border">{t('invoice.month')}</th>
          <th className="p-2 border">{t('invoice.amount')}</th>
          <th className="p-2 border">{t('invoice.status')}</th>
          <th className="p-2 border" />
        </tr>
      </thead>
      <tbody>
        {invoices.map((inv) => (
          <tr key={inv.id} className="border-b">
            <td className="p-2 border">{inv.month}</td>
            <td className="p-2 border">€{inv.amount.toFixed(2)}</td>
            <td className="p-2 border">{inv.status}</td>
            <td className="p-2 border text-right">
              <a href={inv.pdfUrl} target="_blank" rel="noopener noreferrer" className="text-blue-600">
                {t('invoice.download')}
              </a>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}