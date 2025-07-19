import { ResponsiveContainer, LineChart, Line, XAxis, YAxis, Tooltip } from 'recharts'
import { useI18n } from '@/lib/i18n'

interface Props {
  data: { date: string; p95: number }[]
}

export const LatencyChart: React.FC<Props> = ({ data }) => {
  const { t } = useI18n()
  return (
    <div className="w-full h-64">
      <h3 className="font-semibold mb-2">{t('dashboard.latency')}</h3>
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data}>
          <XAxis dataKey="date" />
          <YAxis />
          <Tooltip />
          <Line type="monotone" dataKey="p95" stroke="#82ca9d" strokeWidth={2} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  )
}